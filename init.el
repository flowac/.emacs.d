;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                   PREAMBLE                     ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Useful emacs compile command for being lightweight:
;; ./configure --without-all --with-xml2 --with-xft --with-libotf --with-x-toolkit=lucid --with-modules --with-png --with-jpeg --with-mailutils

;;(setq user-emacs-directory "~/multimedia/.emacs.d/")
(setq gc-cons-threshold (* 2 1024 1024))

(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(defun sp00ky/set-init-file-path (fname)
  (concat user-emacs-directory fname))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;              PACKAGE INSTALLATION              ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I have moved away from using use-package, now I am just using emacs' built in
;; package functions.
(defun sp00ky/install-package (package)
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(setq my-packages
      '(helm
        undo-tree       ; can get rid of undo-tree in emacs 28, we can use undo-redo
        evil            ; Long term goal of completing Evics to replace this
        evil-collection ; Long term goal of completing Evics to replace this
        company
        projectile      ; Can use emacs built in project.el in emacs 28
        eyebrowse       ; Can explore using built in tab-bar mode
        sudo-edit
        highlight-parentheses
        helm-gtags        ; Long term goal of replacing this with sp00ky-global
        helm-projectile)) ; Can use emacs built in project.el in emacs 28

(mapc 'sp00ky/install-package my-packages)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                 PACKAGE INIT                   ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Evil ;;;;;;;;;;;;;;;;
(require 'undo-tree)
(setq evil-want-integration t
      evil-want-keybinding  nil
      evil-undo-system 'undo-tree)
(require 'evil)
(add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
(evil-mode 1)
(evil-collection-init)

;; Some aliases to cover my common typos.
(evil-ex-define-cmd "Q"    'kill-this-buffer)
(evil-ex-define-cmd "E"    'evil-edit)
(evil-ex-define-cmd "Wq"   'evil-save-and-close)
(evil-ex-define-cmd "W"    'evil-write)
(evil-ex-define-cmd "Qa"   "quitall")
(evil-ex-define-cmd "Wqa"  'evil-save-and-quit)
(evil-ex-define-cmd "q"    'kill-this-buffer)
(evil-ex-define-cmd "quit" 'evil-quit) ;; Need to type out :quit to close emacs

;; Go over lines that span multiple lines nicely
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
(define-key evil-normal-state-map "+"       'text-scale-increase)
(define-key evil-normal-state-map "-"       'text-scale-decrease)
(define-key evil-motion-state-map (kbd "TAB") 'nil)
(define-key evil-window-map "\C-h" 'evil-window-left)

;; Change evil window commands to C-a to be like my tmux config. Helps not confuse my fingers
;; if everything is the same.
(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map
                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) (kbd "C-w") nil)
    (define-key (eval map) (kbd "C-a") 'evil-window-map)))

;;;;;;;;;;;;;;;; Company ;;;;;;;;;;;;;;;;
(setq company-dabbrev-downcase      nil
      company-idle-delay            0.5
      company-selection-wrap-around t
      company-minimum-prefix-length 5)

(company-mode 1)
(add-hook 'after-init-hook 'global-company-mode ) ;; use in all buffers

(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "TAB")   'company-complete-common-or-cycle)
(define-key company-active-map (kbd "S-TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-n")   'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-p")   'company-select-previous)

;;;;;;;;;;;;;;;; Helm ;;;;;;;;;;;;;;;;
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-c z") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(setq helm-move-to-line-cycle-in-source t   ; circular helm suggestions
      helm-move-to-line-cycle-in-source nil ; scroll through sections
      helm-buffer-max-length            40
      helm-imenu-fuzzy-match            t
      helm-use-mouse                    t
      ;; No idea why helm has this weird tab completion for evil commands... setting this
      ;; to nil seems to address the problem. See:
      ;; https://groups.google.com/g/emacs-helm/c/jmiTit83VhE
      helm-mode-handle-completion-in-region nil)

(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-s")   'helm-occur)
(global-set-key (kbd "M-x")   'helm-M-x)
(global-set-key (kbd "C-c r") 'helm-resume)
(global-set-key (kbd "M-f")   'helm-find-files)

(define-key helm-map (kbd "C-j") 'helm-next-line)     ; navigate minibuffer
(define-key helm-map (kbd "C-k") 'helm-previous-line) ; navigate minibuffer
(define-key helm-map (kbd "C-v") 'helm-bookmarks)
(define-key helm-map (kbd "TAB")   #'helm-execute-persistent-action) ; Fix tab behaviour in helm
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action) ; Fix tab behaviour in helm

;; Some interesting helm config to take from https://tuhdo.github.io/helm-intro.html
;; helm-split-window-default-side
;; (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      ;; helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      ;; helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      ;; helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      ;; helm-ff-file-name-history-use-recentf t
      ;; helm-echo-input-in-header-line t)

(helm-mode 1)

;;;;;;;;;;;;;;;; helm-gtags ;;;;;;;;;;;;;;;;
(setq helm-gtags-fuzzy-match            t
      helm-gtags-display-style          nil
      helm-gtags-use-input-at-cursor    t
      helm-gtags-maximum-candidates     150
      helm-gtags-pulse-at-cursor        nil ;; reduces lag over ssh
      helm-gtags-auto-update            t
      helm-gtags-ignore-case            t
      helm-gtags-cache-select-result    t
      helm-gtags-auto-update            t
      helm-gtags-update-interval-second nil
      helm-gtags-path-style             'root)

(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-dwim)
  (define-key helm-gtags-mode-map (kbd "M-T") 'helm-gtags-find-tag)
  (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  (define-key helm-gtags-mode-map (kbd "M-f") 'helm-gtags-tags-in-this-function)
  (define-key helm-gtags-mode-map (kbd "C-k") 'helm-gtags-previous-history)
  (define-key helm-gtags-mode-map (kbd "M->") 'helm-gtags-next-history)
  (define-key helm-gtags-mode-map (kbd "M-<") 'helm-gtags-previous-history))

(add-hook 'c-mode-hook 'helm-gtags-mode)

;;;;;;;;;;;;;;;; Eyebrowse ;;;;;;;;;;;;;;;;
(require 'eyebrowse)
(define-key eyebrowse-mode-map (kbd "C-a 1") 'eyebrowse-switch-to-window-config-1)
(define-key eyebrowse-mode-map (kbd "C-a 2") 'eyebrowse-switch-to-window-config-2)
(define-key eyebrowse-mode-map (kbd "C-a 3") 'eyebrowse-switch-to-window-config-3)
(define-key eyebrowse-mode-map (kbd "C-a 4") 'eyebrowse-switch-to-window-config-4)
(define-key eyebrowse-mode-map (kbd "C-a 5") 'eyebrowse-switch-to-window-config-5)
(define-key eyebrowse-mode-map (kbd "C-a 6") 'eyebrowse-switch-to-window-config-6)
(define-key eyebrowse-mode-map (kbd "C-a 7") 'eyebrowse-switch-to-window-config-7)
(define-key eyebrowse-mode-map (kbd "C-a 8") 'eyebrowse-switch-to-window-config-8)
(define-key eyebrowse-mode-map (kbd "C-a 9") 'eyebrowse-switch-to-window-config-9)
(define-key eyebrowse-mode-map (kbd "C-a 0") 'eyebrowse-switch-to-window-config-0)
(define-key eyebrowse-mode-map (kbd "C-a -") 'eyebrowse-prev-window-config)
(define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
(define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
(define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
(define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
(define-key eyebrowse-mode-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
(define-key eyebrowse-mode-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
(define-key eyebrowse-mode-map (kbd "M-7") 'eyebrowse-switch-to-window-config-7)
(define-key eyebrowse-mode-map (kbd "M-8") 'eyebrowse-switch-to-window-config-8)
(define-key eyebrowse-mode-map (kbd "M-9") 'eyebrowse-switch-to-window-config-9)
(define-key eyebrowse-mode-map (kbd "M-0") 'eyebrowse-switch-to-window-config-0)
(eyebrowse-mode t)

;;;;;;;;;;;;;;;; Projectile ;;;;;;;;;;;;;;;;
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-w") 'projectile-command-map)
(setq projectile-enable-caching nil)
(setq projectile-globally-ignored-files
      (append '("GTAGS" "GPATH" "GRTAGS" "TAGS")))
(helm-projectile-on)

;;;;;;;;;;;;;;;; Highlight-Parentheses ;;;;;;;;;;;;;;;;
(require 'highlight-parentheses)
(setq highlight-parentheses-background-colors '("steelblue3"))
(add-hook 'c-mode-hook 'highlight-parentheses-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;               MISC ELSIP LOADING               ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (sp00ky/set-init-file-path "sp00kyFunctions.el"))
(load (sp00ky/set-init-file-path "sp00kyWork.el"))
(load (sp00ky/set-init-file-path "sp00kyHome.el"))
;; (define-key evil-visual-state-map "p" 'sp00ky/evil-paste-after-from-0)
;; (define-key evil-normal-state-map "p" 'evil-paste-after)
;; (define-key evil-visual-state-map "x" 'sp00ky/evil-cut-to-0)
;; (define-key evil-normal-state-map "x" 'sp00ky/evil-delete-char)

;;;;;;;;; Keybindings for loaded functions
(global-set-key [f2] 'sp00ky/highlight-word-at-point)
(global-set-key [(shift f2)] 'sp00ky/unhighlight-all-in-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                 MISC KEYBINDINGS               ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-x B")   'ibuffer)
(global-set-key (kbd "C-x C-b") 'switch-to-buffer)
;; Error about starting with non prefix key...
;; (global-set-key (kbd "C-a z")   'toggle-maximize-buffer)
(global-set-key (kbd "C-c s")   'split-window-horizontally)
(global-set-key (kbd "C-x C-e") 'eval-last-sexp)
(global-set-key (kbd "C-c m")   'bookmark-set)
(global-set-key (kbd "C-c M")   'bookmark-set-no-overwrite)
(global-set-key (kbd "C-c d")   'bookmark-delete)
(global-set-key (kbd "C-=")     'align)
(global-set-key (kbd "C-c l")   'recenter)
(global-set-key (kbd "C-h M")   'man)
(global-set-key (kbd "C-;")     'comment-line)
(global-set-key (kbd "M-;")     'comment-region)

(define-key Info-mode-map (kbd "H") 'Info-last)
(define-key Info-mode-map (kbd "J") 'Info-forward-node)
(define-key Info-mode-map (kbd "K") 'Info-backward-node)
(define-key Info-mode-map (kbd "L") 'Info-history-forward)

;; Trying to make escape act sanely...
(global-set-key (kbd "ESC ESC")  'keyboard-escape-quit)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                   MISC INIT                    ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Various configurations that I like:
(setq-default indent-tabs-mode nil); Replace Tabs with spaces
(setq ring-bell-function   'ignore ; Who wants to hear this annoying bell anyways...
      make-backup-files     nil    ; By default, emacs makes to many backup files.
      backup-inhibited      t
      help-window-select    t
      scroll-conservatively 101    ; Scroll just one line when hitting bottom of window
      text-scale-mode-step 1.05
      org-edit-src-content-indentation 0; Org mode autoindents src code
      auto-save-default     nil)

;; Enabling various minor modes built in with emacs
(global-auto-revert-mode t)
(global-hl-line-mode +1) ; highlight current line
(show-paren-mode      1) ; Show matching paren
(scroll-bar-mode     -1)
(tool-bar-mode       -1)
(menu-bar-mode       -1)
(xterm-mouse-mode     1)
(require 'uniquify) ; Changing title of duplicate buffer titles
(setq uniquify-buffer-name-style 'reverse)
(require 'midnight)
(setq clean-buffer-list-delay-general 7)
(midnight-mode t)
(setq desktop-restore-eager 10
      desktop-load-locked-desktop 'nil)
(desktop-save-mode 1)

;; Misc init elisp
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)

;; It's annoying when a new emacs instance prompts about a pre-existing server
(require 'server)
(if (not server-process)
    (server-start)
  (message "Not starting emacs server, one already exists"))

;; Changing font to my current favourite font, DejaVu Sans Mono
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-16"))

;; Emacs' customize interface pollutes the init file in an unseemly way.
(setq custom-file "~/.emacs.d/.emacs-custom.el")
(load custom-file)
;; Emacs sets package-selected-packges with custom variable settings which is annoying.
;; So to avoid emacs from setting this variable override this function.
(defun package--save-selected-packages (&optional value)
  "Set and save `package-selected-packages' to VALUE."
  (when value
    (setq package-selected-packages value)))
