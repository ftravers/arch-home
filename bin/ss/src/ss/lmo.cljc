#!/usr/bin/env lumo

(ns ss.lmo
  (:require [ss.common :refer [slurp spit]]))

(def data [{:foo 42} {:foo 43}])

(spit "data.edn"  data)
(spit "/home/fenton/flubber.txt" "test")
(comment (= data (read-string (slurp "data.edn")))
         (println "Hello World!")
         (spit "/home/fenton/flubber.txt" "test"))
