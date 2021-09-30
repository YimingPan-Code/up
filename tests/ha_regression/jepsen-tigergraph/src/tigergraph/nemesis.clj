(ns tigergraph.nemesis
  (:require [jepsen
              [nemesis :as nemesis]
              [generator :as gen]
              [control :as c]
            ]
  )
)

(def gsebin
  "GSE binary name"
  "tg_dbs_gsed")

(def gpebin
  "GPE binary name"
  "tg_dbs_gped")

(def dictbin
  "Dictionary binary name"
  "tg_infr_dictd")

(def restbin
  "RESTPP binary name"
  "tg_dbs_restd")

(def component-to-binary
  "Map from binary name to component name."
  {
    :gse gsebin
    :gpe gpebin
    :dict dictbin
    :restpp restbin
  }
)

(defn tigergraph-start!
  ([component]
   (c/exec :gadmin :start :-v component))
  ([]
   (c/exec :gadmin :start :-v))
)

(defn tigergraph-stop!
  ([component]
   (c/exec :gadmin :stop :-v component :-fy))
  ([]
   (c/exec :gadmin :stop :-v :admin :-fy)
   (c/exec :gadmin :stop :-v :-fy))
)

(defn start-stop
  "Return generator of :start/:stop ops. The nemesis client should implement
  start/stop functions."
  [normal-time failure-time]
  {
    :during (gen/seq (cycle [
                              (gen/sleep normal-time)
                              {:type :info, :f :start}
                              (gen/sleep failure-time)
                              {:type :info, :f :stop}
                            ]
                     )
            )
    :final  (gen/once {:type :info, :f :stop})
  }
)

;"NOTICE! do not use this nemesis when the jepsen is running in the cluster"
(defn partition!
  "Partitioning the cluster into random two halves."
  [normal-time failure-time]
  (merge (start-stop normal-time failure-time)
         {
           :name      "Network Partition"
           :client    (nemesis/partition-random-halves)
         }
  )
)

(defn base-start-stopper
  [cnt signal component normalTime failureTime]
  (merge (start-stop normalTime failureTime)
         {
           :client (let [binary (get component-to-binary component)]
                     (nemesis/node-start-stopper
                       (comp (partial take cnt) shuffle)
                       (fn [test node]
                         (c/exec :killall :-s signal binary)
                         ;TODO(yihao) where to use the return value?
                         [:stop (str "SIG" signal component "-" node)])
                       (fn [test node]
                         (case signal
                           "STOP"     (c/exec :killall :-s "CONT" binary)
                           (tigergraph-start! component)
                         )
                         [:start (str component node)]
                       )
                     )
                   )
         }
  )
)

(defn stop-gse!
  "SIGSTOP tg_dbs_gsed process and recover later."
  [cnt]
  (merge (base-start-stopper cnt "STOP" :gse 30 10)
         {:name (str "Stop-" cnt "-GSE")}
  )
)

(defn kill-gse-9!
  "SIGKILL tg_dbs_gsed process and recover later."
  [cnt]
  (merge (base-start-stopper cnt "KILL" :gse 30 10)
         {:name (str "Kill9-" cnt "-GSE")}
  )
)

(defn stop-gpe!
  "SIGSTOP gpe process and recover later"
  [cnt]
  (merge (base-start-stopper cnt "STOP" :gpe 30 10)
         {:name (str "Stop-" cnt "-GPE")}
  )
)

(defn kill-gpe-9!
  "SIGKILL gpe process and recover later"
  [cnt]
  (merge (base-start-stopper cnt "KILL" :gpe 30 10)
         {:name (str "Kill9-" cnt "-GPE")}
  )
)

(def noop
  "No failure."
  {
    :name "Noop"
    :during gen/void
    :final  gen/void
    :client nemesis/noop
  }
)
