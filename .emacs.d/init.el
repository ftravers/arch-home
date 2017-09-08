(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(setq
 my:el-get-packages
 '(el-get
   emacs-powerline
   tramp
   tomorrow-theme))
(setq my:el-get-packages
      (append my:el-get-packages
              (mapcar #'el-get-source-name el-get-sources)))
;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("billpiel" . "http://billpiel.com/emacs-packages/") t)

(package-initialize)
(when (not package-archive-contents) (package-refresh-contents))
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents) 
      (package-install 'use-package)))
(require 'use-package)

(use-package markdown-mode :ensure markdown-mode)
;(use-package markdown-mode :ensure t
;:commands (markdown-mode gfm-mode) :mode (("README\\.md\\'" . gfm-mode) ("\\.md\\'" . markdown-mode) ("\\.markdown\\'" . markdown-mode))
;:init (setq markdown-command "multimarkdown"))
(use-package lua-mode :ensure lua-mode)
(use-package markdown-mode :ensure markdown-mode)
(use-package ox-gfm :ensure ox-gfm)
(use-package clojure-more :ensure clojure-mode)
(use-package sayid :ensure sayid)
(use-package color-theme :ensure color-theme)
(use-package projectile :ensure projectile)
(use-package paredit :ensure paredit)
(use-package undo-tree :ensure undo-tree)
(use-package highlight-parentheses :ensure highlight-parentheses)
(use-package lispy :ensure lispy)
(use-package magit :ensure magit)
;; (setq package-pinned-packages
;;       '((cider . "melpa-stable")))
(use-package cider :ensure cider)
(use-package bind-key :ensure bind-key)
(use-package helm-projectile :ensure helm-projectile)
(use-package company :ensure company)
(use-package diminish :ensure diminish)
(use-package haskell-mode  :ensure haskell-mode)
;; (use-package inf-clojure :ensure inf-clojure)
(use-package clj-refactor :ensure clj-refactor)
;; (unless (package-installed-p 'cider) (package-install 'cider))

(global-company-mode)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/git/emacs-async"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/git/helm"))
(require 'helm-config)
;; Helm - Projectile
(helm-mode 1)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "M-p") 'ace-window)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x c o") 'helm-occur)
(global-set-key (kbd "C-c f") 'helm-recentf)

;; (global-set-key (kbd "C-c h") 'helm-mini)
(setq helm-truncate-lines 1)

;;-----------------------------------------
;; FONT FACES SIZE
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#1d1f21" :foreground "#c5c8c6" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(mode-line ((t (:foreground "#030303" :background "#8b4513" :box nil))))
 '(mode-line-inactive ((t (:foreground "#f9f9f9" :background "#666666" :box nil))))
 '(show-paren-match ((((class color) (background light)) (:background "azure2"))))
 '(sp-pair-overlay-face ((t (:inherit (default highlight) :background "gray25" :distant-foreground "sienna" :foreground "white smoke")))))


;; ----------------------------------------------
;; Projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-switch-project-action 'helm-projectile)

;; ----------------------------------------------
;; Color Themese
(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get")
(load-theme 'tomorrow-night t)

;; ----------------------------------------------
(setq desktop-dirname             (expand-file-name  "~/.emacs.d/")
      desktop-auto-save-timeout   30
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-files-not-to-save   "^$" )


(desktop-save-mode 1)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq initial-scratch-message nil) ;; Don't insert instructions in the *scratch* buffer
(mouse-wheel-mode t) ;; mouse scrolling
(line-number-mode 1) ;; Show line-number and column-number in the mode line
(column-number-mode 1)
(global-hl-line-mode 1) ;; highlight current line
(setq x-select-enable-clipboard t) ;; set cut/copy to go to system clipboard
(fset 'yes-or-no-p 'y-or-n-p) ;; When emacs asks for "yes" or "no", let "y" or "n" sufficide
(setq scroll-step 1) ;; Scroll one line (not half a page) when moving past the bottom of the window
(setq indent-tabs-mode nil);; No tabs but spaces for indentation
(setq-default truncate-lines t)
;; (setq-default truncate-lines nil)
;; dont wrap long 
(setq-default indent-tabs-mode nil) ; always replace tabs with spaces
(setq-default tab-width 2) ; set tab width to 4 for all buffers
(setq tab-stop-list '(2 4 6 8 10 12 14 16))
(setq indent-line-function 'insert-tab)
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-#") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c C-h") 'hs-hide-all)
(global-set-key (kbd "C-c C-s") 'hs-show-all)
(global-set-key (kbd "C-=") 'er/expand-region)
(setq cua-enable-cua-keys nil)
(cua-mode)
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)


;; when opening a file, if intermediate folders dont exist, create them.
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))
(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-added "green3")
     (set-face-foreground 'magit-diff-removed "red3")
     (set-face-background 'magit-diff-base-highlight "black")))

;; ---------------------------
;; Backup files
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; ---------------------------
;; LISPY
(defun my-remove-lispy-key (key)
  (define-key lispy-mode-map-base key nil)
  (define-key lispy-mode-map-lispy key nil)
  (define-key lispy-mode-map-oleh key nil)
  (define-key lispy-mode-map-paredit key nil)
  (define-key lispy-mode-map-special key nil)
;  (define-key lispy-mode-map-x key nil)
  ) 

(defun collapse-expand () (interactive)
       (hs-toggle-hiding)
       (beginning-of-line))



(eval-after-load "lispy"
  `(progn
     (my-remove-lispy-key (kbd "d"))
     (lispy-define-key lispy-mode-map (kbd "e") 'cider-eval-last-sexp)
     (lispy-define-key lispy-mode-map (kbd "d") 'lispy-kill-at-point)
     (lispy-define-key lispy-mode-map (kbd "x") 'collapse-expand)))


;; cider-eval-last-sexp
;; ---------------------------
;;   CIDER
(setq cider-repl-use-pretty-printing t)

(defun mount-reset ()
  (interactive
   (cider-interactive-eval "(do (ns pcbe.dev) (reset))")))

(defun figwheel-cljs-repl ()
  (interactive
   (cider-interactive-eval
    "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")))

;; (defun fw2 ()
;;   (interactive
;;    (setq cider-cljs-lein-repl "(do (ra/start-figwheel!) (ra/cljs-repl)")))

(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")


;; (autoload 'inf-clojure "inf-clojure" "Run an inferior Clojure process" t)
;;    (add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)

(defun cider-namespace-refresh ()
  (interactive)
  (cider-interactive-eval
   "(require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/refresh)"))

(add-hook 'org-mode-hook 'turn-on-auto-fill)

(add-hook 'cider-repl-mode-hook
          '(lambda ()
             (define-key cider-repl-mode-map "{" #'paredit-open-curly)
             (define-key cider-repl-mode-map "}" #'paredit-close-curly)))
(defun cider-repl-refresh ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert (concat "(require 'clojure.tools.namespace.repl) "
                    "(clojure.tools.namespace.repl/refresh)"))
    (cider-repl-return)))

;; (define-key cider-mode-map (kbd "C-c r") 'cider-repl-refresh)

(setq cljr-warn-on-eval nil)

(add-hook 'cider-repl-mode-hook
          '(lambda ()
             (define-key cider-repl-mode-map (kbd "C-c r") #'cider-repl-refresh)))

(setq hide-all t)

(defun toggle-show-hide-all () (interactive)
       (if hide-all
           (progn
             (hs-show-all)
             (setq hide-all nil))
         (progn (hs-hide-all)
                (setq hide-all t))))

(add-hook
 'clojure-mode-hook
 (lambda ()
   #'inf-clojure-minor-mode
   (define-key clojure-mode-map (kbd "C-c r") #'mount-reset)
   (define-key clojure-mode-map (kbd "C-c c") #'figwheel-cljs-repl)
   (define-key clojure-mode-map (kbd "C-c l") #'lispy-mode)
   (define-key clojure-mode-map (kbd "C-c s") #'toggle-show-hide-all)
   
   (clj-refactor-mode 1)
   (cljr-add-keybindings-with-prefix "C-c C-m") ;; This choice of keybinding leaves cider-macroexpand-1 unbound
   (cider-mode 1)))

;; ----------------------------------------------
;; HIGHLIGHT PARENS
(setq hl-paren-colors
      '("red" "orange1" "yellow1" "green1" "cyan1"
        "slateblue1" "magenta1" "purple"))
(setq hl-paren-background-colors
      '("black" "black" "black" "black" "black" "black" "black" "black"))


(add-hook 'prog-mode-hook
          (lambda ()
            (lispy-mode 1)
            (define-key lispy-mode-map-lispy (kbd "\"") 'lispy-doublequote)
            (undo-tree-mode)
            (bind-keys* ("C-c C-f" . collapse-expand))
            (hs-minor-mode)
            (hs-hide-all)               
            ;; (hs-show-block)
            (highlight-parentheses-mode 1)))
(add-hook 'cider-repl-mode-hook
          (lambda ()
            (define-key cider-repl-mode-map (kbd "M-p") 'ace-window)
            (lispy-mode 1)
            (highlight-parentheses-mode 1)))

(when (and lispy-mode (called-interactively-p 'any))
    (mapc #'lispy-raise-minor-mode
          (cons 'lispy-mode lispy-known-verbs)))

(put 'narrow-to-region 'disabled nil)

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (progn
        (rename-file name new-name 1)
        (rename-buffer new-name)
        (set-visited-file-name new-name)
        (set-buffer-modified-p nil)))))

;; --------------- Diminish -------------
(diminish 'auto-revert-mode)
(diminish 'projectile-mode)
(diminish 'helm-mode)
(diminish 'lispy-mode)
(eval-after-load "company" '(diminish 'company-mode))
(eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
(eval-after-load "cider" '(diminish 'cider-mode))
(eval-after-load "yas" '(diminish 'yas-mode))
(eval-after-load "cljr" '(diminish 'cljr-mode))
(eval-after-load "eldoc" '(diminish 'eldoc-mode))
(eval-after-load "clojure" '(diminish 'clojure-mode))
(eval-after-load "highlight-parentheses" '(diminish 'highlight-parentheses-mode))
(add-hook 'hs-minor-mode-hook (lambda () (diminish 'hs-minor-mode)))
(add-hook 'highlight-parentheses-mode-hook (lambda () (diminish 'highlight-parentheses-mode)))

;; -------------- Boot & Cider
(setq cider-boot-parameters "cider repl -s wait")

;; -------------- clj refactor
;; (defun my-clojure-mode-hook ()
;;     (clj-refactor-mode 1)
;;     (yas-minor-mode 1) ; for adding require/use/import statements
;;     ;; This choice of keybinding leaves cider-macroexpand-1 unbound
;;     (cljr-add-keybindings-with-prefix "C-c C-m"))

;; (add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(put 'set-goal-column 'disabled nil)

(add-hook 'cider-mode-hook #'eldoc-mode)
(cider-auto-test-mode 0)
(setq nrepl-prompt-to-kill-server-buffer-on-quit nil)
(setq cider-preferred-build-tool "lein")
;; ;; this is default no need to set to 1 just delete this setting.
;; (setq cider-prompt-save-file-on-load 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-auto-mode nil)
 '(org-export-backends (quote (ascii html icalendar latex md)))
 '(package-selected-packages
   (quote
    (sayid use-package undo-tree magit lispy inf-clojure highlight-parentheses helm-projectile haskell-mode floobits company color-theme clj-refactor)))
 '(tramp-syntax (quote default) nil (tramp)))
(setq cider-repl-clear-help-banner nil)
(setq org-src-fontify-natively t)

;; try to get org-mode to output clojure tag for source code blocks
;; (setq org-export-filter-src-block-functions)

(defun org2markdown-bring-code (src backend info)
  (progn
    ;; (message "info::: %s" info)
    (if (member :language info)
        (concat "```clojure\n" src "```\n\n")
      src)))

(eval-after-load 'ox
  '(progn
     (add-to-list 'org-export-filter-src-block-functions
                  'org2markdown-bring-code)))

;; (debug-on-entry 'org2markdown-bring-code)
;; (cancel-debug-on-entry 'org2markdown-bring-code)
