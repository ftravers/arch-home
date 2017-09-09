#!/usr/bin/sbcl --script
(load "quicklisp.lisp")
(quicklisp-quickstart:install)

(require :asdf)

;; Add my systems dir onto the registry path
(push #p"/home/fenton/projects/lisp/systems/" asdf:*central-registry*)

;; Setup quicklisp
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init) (load quicklisp-init)))

(ql:quickload "quicklisp-slime-helper")
