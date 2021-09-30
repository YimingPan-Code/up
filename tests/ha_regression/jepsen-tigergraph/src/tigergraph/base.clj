(ns tigergraph.base
  (:refer-clojure :exclude [test])
  (:require [tigergraph.db :as db]
            [jepsen
              [tests :as tests]
              [generator :as gen]
            ]
            [jepsen.os :refer [noop]]
            [jepsen.os
              [debian :as debian]
            ]
            [clojure.tools.logging :refer :all]
            [clojure.pprint :refer [pprint]]
  )
  (:import (java.util.concurrent CyclicBarrier))
)

(defn test
  "Return Base test parameters which will be overrided by other tests."
  [opts]
  (let [ new-opts (merge tests/noop-test
                         {:name          "BaseTest"
                          ;agent node is the node to run gadmin command
                          :agent-node    (:agent-node opts)
                          :db            (db/db (assoc opts :agent-node "m1"))
                          :nemesis       (:client (:nemesis opts))
                          :client        (:client (:client opts))
                          :generator
                            (gen/phases
                              (->> (gen/nemesis (:during (:nemesis opts))
                                                (:during (:client opts)))
                                   (gen/time-limit (:time-limit opts)))
                              (gen/log "Terminating Nemesis")
                              (gen/nemesis (:final (:nemesis opts)))
                              (gen/log "Recovering Clients")
                              (gen/sleep (:recovery-time opts))
                              (gen/clients (:final (:client opts)))
                            )
                          :barrier-for-clients (CyclicBarrier.
                            (:concurrency opts)
                            #(info "All VextexOpClients are set up!"))
                          :nonserializable-keys '(:barrier-for-clients)
                         }
                         (dissoc opts :client :nemesis :agent-node))]
    (info "Client:\n" (type new-opts))
    (info "Transfered TestOptions:\n" (with-out-str (pprint new-opts)))
    new-opts
  )
)

