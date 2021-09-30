(ns tigergraph.gsql
  (:refer-clojure :exclude [test])
  (:require [jepsen
              [client :as client]
              [control :as c]
            ]
            [cheshire.core :as json]
            [clj-http.client :as http]
            [clojure.string :as string]
            [clojure.tools.logging :refer :all]
            [clojure.pprint :refer [pprint]]
  )
)

(defprotocol GSQLHelper
  (gsql-cleanup! [this])
  (gsql-setup! [this])
  (gsql-invoke! [this invoke-type arg1 arg2]))

(def resource-path
  (str (System/getProperty "user.dir") "/resources"))

(def target-resource-path
  "/tmp/resources/")

(defn generate-vertex-json
  "Generate post required vertex json data with a given vertex type.
   Returns a json map contains all vertex ids in start id, end id].
   Note that the end id's attribute is special-attr"
  [vertex-type attr special-attr start end]
  (loop [initial {}
         vertex-id (+ start 1)]
    (if (> vertex-id end)
      (let [result {"vertices" {vertex-type initial}}]
         result)
      (let [cur-attr (if (= vertex-id end) special-attr attr)]
        (recur (assoc initial (str vertex-id) cur-attr) (+ vertex-id 1)))))
)

(defn generate-vertex-set
  "Given a count of the vertex, generate a sequence of vertex id step by interval"
  [vertex-count step]
  (let [vertex-seq (conj (take-nth step (range (+ vertex-count 1))) vertex-count)]
    (set vertex-seq)))

(defrecord VertexReqHelper [vertex-batch-write-cnt
                            vertex-type
                            ; a special value for the last vertex of each batch
                            attr-value
                            gsql-file-name]
  GSQLHelper

  ;"Drop all schemas. This will be called inside gsql-setup!"
  (gsql-cleanup! [this]
    (info "Drop graph schema.")
    (c/trace (c/exec :gsql :DROP :ALL))
    (info "Dropped graph schema."))

  ;Install the new schema/query in $gsql-file-path. Throw exception when gsql
  ;fails.
  (gsql-setup! [this]
    (gsql-cleanup! this)
    (let [gsql-file-name (:gsql-file-name this)]
      (info "gsql " gsql-file-name)
      (c/trace (c/exec :mkdir :-p target-resource-path))
      (c/trace (c/upload (str resource-path "/" gsql-file-name)
                         target-resource-path))
      (c/trace (c/exec :gsql (str target-resource-path
                                  gsql-file-name)))))

  ;Invoke a graph request. arg1 may be needed by some type of requests
  ;(defprotocol don't support variable parameter).
  (gsql-invoke! [this invoke-type arg1 arg2]
    (try 
      (case invoke-type
        :write-vertex
          (json/parse-string (:body (http/post
                   (str "http://" (:agent-node this)
                        ":9000/graph?_api_=v2")
                     {:body (json/generate-string (generate-vertex-json
                                   (:vertex-type this)
                                   {"score"
                                     {"value"
                                        (dec (:attr-value this))}}
                                   {"score"
                                      {"value"
                                       (:attr-value this)}}
                                   arg1
                                   (+ arg1 arg2)))
                     :content-type :json})))
        :read-vertex
          (json/parse-string (:body (http/get
                   (str "http://"
                        (:agent-node this)
                        ":9000/graph/vertices/" (:vertex-type this)
                        "?filter=score"
                        "=" (:attr-value this) "&_api_=v2")
                   {:headers {"GSQL-TIMEOUT" 300000}}
                   )))
        :count-vertex
          (json/parse-string (http/post
                               (str "http://" (-> this :test :agent-node)
                                    ":9000/builtins?_api_=v2")
                               {:form-parms
                                {"function" "stat_vertex_number", "type" "*"}
                                :content-type :json}))
        ; default
        (throw (RuntimeException. (str "invoke-type "
                                       invoke-type
                                       " not supported."))))
      (catch Exception e
        (do (info (str e)) nil)))))

