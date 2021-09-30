(ns tigergraph.db
  (:require [tigergraph
              [nemesis :as nemesis]
              [gsql :as gsql]
            ]
            [jepsen
              [core :as jepsen]
              [control :as c]
              [db :as db]
            ]
            [clojure.tools.logging :refer :all]
            [clojure.pprint :refer [pprint]]
  )
)

(defn wait-gsql-ready
  [node]
  (let [pair-fn (fn [] (
                         (Thread/sleep 1000)
                         (let [ret (try
                                     (c/exec :gsql :ls)
                                     0
                                     (catch RuntimeException e -1)
                                   ),
                               time-now (quot (System/currentTimeMillis) 1000)]
                           '(ret (- time-now start-time))
                         )
                       ))]
    (loop [start-time (quot (System/currentTimeMillis) 1000)
           time-out 10]
      (let [[ret time-delta] (pair-fn)]
        (info node "Waiting gsql works...")
        (if (= 0 ret) 0
          (if (> time-delta time-out)
            (throw (RuntimeException.
                     (str "'gsql ls' not working in " time-out "seconds.")))
            (recur start-time time-out))))
    )
  )
)

(defn db
  "Tigergraph db abstraction."
  [opts]
  (reify db/DB
    (setup! [_ test node]
      (when (= node (:agent-node opts))
        (info node "Stopping all services")
        (nemesis/tigergraph-stop!)
        (info node "Starting all services")
        (nemesis/tigergraph-start!)
        ;(wait-gsql-ready node) 
        (c/trace (c/exec :rm :-rf gsql/target-resource-path))
        (c/trace (c/upload gsql/resource-path
                           gsql/target-resource-path
                           :recursive true))
        (Thread/sleep 1000)
        (info "Try get schema:\n" (c/exec :gsql :ls))
      )
      ; synchronize all node after start all service
      (jepsen/synchronize test)
    )

    (teardown! [_ test node] nil)
  )
)
