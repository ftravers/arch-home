(ns ss.common
  #?(:cljs (:require
            [cljs-node-io.core :as io])))

(defn spit [file contents]
  #?(:clj (clojure.core/spit file contents)
     :cljs (io/spit file contents)))

(defn slurp [file]
  #?(:clj (clojure.core/slurp file)
     :cljs (io/slurp file)))

