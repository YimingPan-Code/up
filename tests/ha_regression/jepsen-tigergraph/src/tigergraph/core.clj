(ns tigergraph.core
  "Tigergraph HA & Consistency tests."
  (:gen-class)
  (:refer-clojure :exclude [run!])
  (:require [tigergraph.gse :as gse]
            [tigergraph.nemesis]
            [jepsen.core :as jepsen]
            [jepsen.cli :as jc]
            [jepsen.os :as os]
            [jepsen.os.debian :as debian]
            [clojure.tools.logging :refer :all]
            [clojure.pprint :refer [pprint]]
  )
)

(def supported-test-suites
  "A map of test names to test constructors."
  {"gse" gse/test}
)

(def supported-oses
  "A map of supported operating system name to os environment preparation fn."
  {
    "debian" debian/os
    "none"   os/noop
    ; add more preparation requirement here
  }
)

(def supported-failures
  "A map of supported failure type name to failure (or nemesis) configuration."
  {
    ; no failure
    "noop"               tigergraph.nemesis/noop
    ; SIGSTOP tg_dbs_gsed process and recovery later
    "stop-gse"           (tigergraph.nemesis/stop-gse! 1)
    ; SIGKILL tg_dbs_gsed process and recovery later
    "kill-gse-9"         (tigergraph.nemesis/kill-gse-9! 1)
    ;"kill-gse-15"         tigergraph.nemesis.kill-gse-15!
    ; add more failure here and in 
    ; SIGSTOP gpe process and recovery later
    "stop-gpe"           (tigergraph.nemesis/stop-gpe! 1)
    ; SIGKILL gpe process and recovery later
    "kill-gpe-9"         (tigergraph.nemesis/kill-gpe-9! 1)
    ; Network-split the cluster into two groups
    "partition"          (tigergraph.nemesis/partition! 50 10)
  }
)

(def tigergraph-opt-spec
  "Command line options for tools.cli"
  [
    jc/help-opt

    (jc/repeated-opt "-n" "--node HOSTNAME" "Node(s) to run test on"
                  ["m1", "m2", "m3"])
    [nil "--agent-node AGENT_NODE" "The node which has gium/gsql"
     :default "m1"]

    [nil "--nodes-file FILENAME" "File containing node hostnames, one per line."]

    [nil "--username USER" "Username for logins"
     :default "graphsql"]

    [nil "--password PASS" "Password for sudo access"
     :default "graphsql"]

    [nil "--strict-host-key-checking" "Whether to check host keys"
     :default false]

    [nil "--ssh-private-key FILE" "Path to an SSH identity file"]

    [nil "--concurrency NUMBER" "How many workers should we run? Must be an integer, optionally followed by n (e.g. 3n) to multiply by the number of nodes."
     :default  "3n"
     :validate [(partial re-find #"^\d+n?$")
                "Must be an integer, optionally followed by n."]]

    (jc/repeated-opt "-t" "--test-suite NAME" "Test(s) to run" [] supported-test-suites)

    [nil "--test-count NUMBER"
     "How many times should we repeat a test?"
     :default  1
     :parse-fn #(Long/parseLong %)
     :validate [pos? "Must be positive"]]

    [nil "--time-limit SECONDS"
     "Excluding setup and teardown, how long should a test run for, in seconds?"
     :default  60
     :parse-fn #(Long/parseLong %)
     :validate [pos? "Must be positive"]]

    [nil "--recovery-time SECONDS"
     "How long to wait for cluster recovery before final client ops."
     :default 60
     :parse-fn #(Long/parseLong %)
     :validate [pos? "Must be positive"]]

    (jc/repeated-opt nil "--failure NAME" "Which failure to use"
                     [tigergraph.nemesis/noop]
                     supported-failures)

    ["-o" "--os NAME" "debian, or none"
     :default  os/noop
     :parse-fn supported-oses
     :validate [identity (jc/one-of supported-oses)]]
  ]
)

(defn command-descriptor
  "Command description table for tigergraph HA & Consistency tests."
  []
  (reduce merge
    [
      {"test" {
                :opt-spec tigergraph-opt-spec
                :opt-fn   jc/test-opt-fn
                :run      (fn [{:keys [options]}]
                            (info "Test options:\n"
                                  (with-out-str (pprint options)))
                            (doseq [i       (range (:test-count options))
                                    test-fn (:test-suite options)
                                    nemesis (:failure options)]
                              (let [test (jepsen/run!
                                           (test-fn
                                             (-> options
                                                 (assoc :nemesis nemesis)
                                                 (dissoc :failure :test-suite))))]
                                (when-not (:valid? (:results test))
                                  (System/exit 1)
                                )
                              )
                            )
                          )
              }
      },
      ; add more command here
      { }
    ]
  )
)

(defn -main
  [& args]
  (jc/run! (merge (jc/serve-cmd)
                  (command-descriptor))
           args
  )
)
