(ns tigergraph.gse
  (:refer-clojure :exclude [test set])
  (:require [tigergraph
              [base :as base]
              [gsql :as gsql]
            ]
            [jepsen.checker.timeline :as timeline]
            [jepsen
              [core :as jepsen]
              [client :as client]
              [control :as c]
              [checker :as checker]
              [model :as model]
              [generator :as gen]
              [util :as util]
            ]
            [knossos [op :as op]]
            [clojure.set :as set]
            [clojure.core.reducers :as r]
            [clojure.pprint :refer [pprint]]
            [clojure.tools.logging :refer :all]
  )
  (:import (java.util.concurrent CyclicBarrier))
)

(def identify 
  "Identifier for agent-node"
  (atom 0))

(def vertex-count
  "Record the vertex count while doing ops."
  (atom 0))

(defn delete-vertex
  "Delete vertex with id vertex-count"
  [_ _]
  {:type :invoke, :f :delete}
)

(defn write-vertex
  "Batch insert vertex with a specific count, start from @vertex-count.
   Return a sequence [start id, batch size]"
  [test process]
  {:type :invoke, :f :add, :value
    (let [batch (-> test :client :gsql-helper :vertex-batch-write-cnt
                    (* 2)
                    rand-int inc)]
      [(- (swap! vertex-count (partial + batch))
          batch)
       batch])}
)

(defn count-vertex
  "Query for the current vertex count"
  ([_ _] (count-vertex))
  ([] {:type :invoke, :f :count, :value nil})
)

(defn read-vertex
  "Query for the current vertex with specific value"
  ([_ _] (read-vertex))
  ([] {:type :invoke, :f :read, :value (sorted-set)})
)

(defrecord VertexOpClient [node gsql-helper]
  client/Client

  (setup! [this test node]
    (let [batch (-> this :gsql-helper :vertex-batch-write-cnt)]
      (info (str "Setup VertexOpClient on " node " with vertex batch count "
                 batch))
      ; clear graph store and reset schema
      (let [cnt (-> test :nodes count)
            agent-node (:agent-node test)]
        (when (and (= node agent-node)
                   (= (swap! identify inc) 1))
          (info "Creating graph schema for VertexOpClient on " node)
          (c/on-nodes test
                      [agent-node]
                      #(let [a %1 b %2] (gsql/gsql-setup! (:gsql-helper this))))
          (info "Created graph schema for VertexOpClient")))
      ; synchronize all node after create graph schema 
      (.await ^CyclicBarrier (:barrier-for-clients test))
      (assoc this :node node :batch batch))
  )

  (invoke! [this test op]
    (case (:f op)
      :add
        (let [value (:value op)
              json (gsql/gsql-invoke! (-> this :gsql-helper
                                          (assoc :agent-node (:agent-node test)))
                                      :write-vertex
                                      (first value) (last value))]
          (info json)
          (assoc op :type (if json
                            (if (-> "error" json false?) :ok :fail) :fail)
                 :compvalue (+ (first value) (last value))))
      :read
        (let [json (gsql/gsql-invoke! (-> this :gsql-helper
                                          (assoc :agent-node (:agent-node test)))
                                      :read-vertex nil nil)]
          (assoc op :type :ok :value
                 (if json
                   (if (-> "error" json true?) #{}
                     (->> (json "results")
                          ;TODO(yihao) may need transfer to int to improve
                          ;performance.
                          (pmap #(Integer. (% "v_id")))
                          (into #{})))
                   #{})))
      ;default
      (throw (RuntimeException. (str "op "
                                     (:f op)
                                     " not supported.")))))

  (teardown! [this test]
    (info (str "Teardown VertexOpClient on " (:node this)))
  )
)

(defn set
  "Given a set of :add operations followed by a final :read, verifies that
  every successfully added element is present in the read, and that the read
  contains only elements for which an add was attempted."
  []
  (reify checker/Checker
    (check [this test model history opts]
      (let [attempts (->> history
                          (r/filter op/invoke?)
                          (r/filter #(= :add (:f %)))
                          ; we need the sum of the invoke values
                          (r/map #(->> %1 :value (reduce +)))
                          (into #{}))
            adds (->> history
                      (r/filter op/ok?)
                      (r/filter #(= :add (:f %)))
                      (r/map :compvalue)
                      (into #{}))
            final-read (->> history
                          (r/filter op/ok?)
                          (r/filter #(= :read (:f %)))
                          (r/map :value)
                          (reduce (fn [_ x] x) nil))]
        (if-not final-read
          {:valid? :unknown
           :error  "Set was never read"}

          (let [; The OK set is every read value which we tried to add
                ok          (set/intersection final-read attempts)

                ; Unexpected records are those we *never* attempted.
                unexpected  (set/difference final-read attempts)

                ; Lost records are those we definitely added but weren't read
                lost        (set/difference adds final-read)

                ; Recovered records are those where we didn't know if the add
                ; succeeded or not, but we found them in the final set.
                recovered   (set/difference ok adds)]

            {:valid?          (and (empty? lost) (empty? unexpected))
             :ok              (util/integer-interval-set-str ok)
             :lost            (util/integer-interval-set-str lost)
             :unexpected      (util/integer-interval-set-str unexpected)
             :recovered       (util/integer-interval-set-str recovered)
             :ok-frac         (util/fraction (count ok) (count attempts))
             :unexpected-frac (util/fraction (count unexpected) (count attempts))
             :lost-frac       (util/fraction (count lost) (count attempts))
             :recovered-frac  (util/fraction (count recovered) (count attempts))}))))))

(defn test
  "Test for gse HA and consistency"
  [opts]
  (base/test
    (merge
      {
        :name       "Vertex-Sets"
        :client     {
                      :client (VertexOpClient. nil
                                               (tigergraph.gsql.VertexReqHelper.
                                                 256; batch size
                                                 "User" ; vertex type
                                                 1 ; attr value
                                                 "vertex_only.gsql"))
                      :during (->> (gen/mix [write-vertex])
                                   (gen/stagger 1/10))
                      :final (gen/once (read-vertex))
                    }
        :checker    (checker/compose
                      {
                        :timeline (timeline/html)   
                        :perf (checker/perf)
                        :vertex (set)
                      }
                    )
      }
      opts
    )
  )
)

