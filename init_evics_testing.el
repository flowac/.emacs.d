(setq gc-cons-threshold (* 32 1024 1024))
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(defun sp00ky/set-init-file-path (fname)
  (concat user-emacs-directory fname))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:         PACKAGE INSTALLATION           ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I have moved away from using use-package, now I am just using emacs' built in
;; package functions.
(defun sp00ky/install-package (package)
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(setq my-packages
      '(company
        company-jedi
        eyebrowse       ; Can explore using built in tab-bar mode
        geiser
        geiser-guile
        gnuplot
        helm
        helm-gtags      ; Long term goal of replacing this with sp00ky-global
        helm-projectile
        helm-xref
        highlight-indent-guides
        highlight-parentheses
        projectile      ; Can use emacs built in project . el in emacs 28
        sudo-edit
        undo-tree))     ; Can get rid of undo-tree in emacs 28, we can use undo-redo
(mapc 'sp00ky/install-package my-packages)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:            PACKAGE INIT                ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;SUBSECTION: Company ;;;;;;;;;;;;;;;;
(setq company-dabbrev-downcase      nil
      company-idle-delay            0.2
      company-selection-wrap-around t
      company-minimum-prefix-length 5)

(company-mode 1)
(add-hook 'after-init-hook 'global-company-mode ) ;; use in all buffers

(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "TAB")   'company-complete-common-or-cycle)
(define-key company-active-map (kbd "S-TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-n")   'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-p")   'company-select-previous)

;;;;;;;;;;;;;;;;SUBSECTION: Helm ;;;;;;;;;;;;;;;;
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

;(add-to-list 'helm-imenu-type-faces '("^\\(Sections\\|Subsections\\)" . font-lock-builtin-face))

(require 'bookmark)
(setq bookmark-save-flag 1) ; Setting this to 1 ensures we save bookmarks each time we add one
(global-set-key (kbd "C-x B") 'helm-bookmarks)
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
(helm-mode 1)
(setq helm-autoresize-min-height 50)
(helm-autoresize-mode 1)

;;;;;;;;;;;;;;;;SUBSECTION: helm-gtags ;;;;;;;;;;;;;;;;
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
  ;; Look into swapping this with a prefix based keybinding C-c z is my helm prefix
  (define-key helm-gtags-mode-map (kbd "C-c z g") 'helm-gtags-parse-file)
  (define-key helm-gtags-mode-map (kbd "M-<") 'helm-gtags-previous-history))

(add-hook 'c-mode-hook 'helm-gtags-mode)

;;;;;;;;;;;;;;;;SUBSECTION: Eyebrowse ;;;;;;;;;;;;;;;;
(require 'eyebrowse)
(setq eyebrowse-new-workspace t)

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

;;;;;;;;;;;;;;;;SUBSECTION: Projectile ;;;;;;;;;;;;;;;;
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-w") 'projectile-command-map)
(setq projectile-enable-caching nil)
(setq projectile-globally-ignored-files
      (append '("GTAGS" "GPATH" "GRTAGS" "TAGS")))
(helm-projectile-on)

;;;;;;;;;;;;;;;;SUBSECTION: Highlight-Parentheses ;;;;;;;;;;;;;;;;
(require 'highlight-parentheses)
;;(setq highlight-parentheses-background-colors '("steelblue3"))
(add-hook 'prog-mode-hook 'highlight-parentheses-mode)
;; (add-hook 'c-mode-hook 'highlight-parentheses-mode)
;; (add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)
;; (add-hook 'scheme-mode-hook 'highlight-parentheses-mode)

;;;;;;;;;;;;;;;;SUBSECTION: Highlight-Indent-Guides ;;;;;;;;;;;;;;;;
(setq highlight-indent-guides-method     'character
      highlight-indent-guides-responsive 'stack)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:       MISC ELISP LOADING               ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(load (sp00ky/set-init-file-path "sp00kyFunctions.el"))
;(load (sp00ky/set-init-file-path "sp00kyAbbrevs.el"))
;(if (file-exists-p (sp00ky/set-init-file-path ".sp00kyWork"))
;    (load (sp00ky/set-init-file-path "sp00kyWork.el"))
;  (load (sp00ky/set-init-file-path "sp00kyHome.el")))

;;;;;;;;; Keybindings for loaded functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:            MISC KEYBINDINGS            ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(define-key help-mode-map (kbd "M-<") 'help-go-back)
(define-key help-mode-map (kbd "M->") 'help-go-forward)
(define-key Info-mode-map (kbd "H") 'Info-last)
(define-key Info-mode-map (kbd "J") 'Info-forward-node)
(define-key Info-mode-map (kbd "K") 'Info-backward-node)
(define-key Info-mode-map (kbd "L") 'Info-history-forward)
(define-key Info-mode-map (kbd ",") 'Info-index-next)

(define-key emacs-lisp-mode-map (kbd "M-r") 'xref-find-references)
(define-key emacs-lisp-mode-map (kbd "M-t") 'xref-find-definitions)
(define-key emacs-lisp-mode-map (kbd "M-<") 'xref-pop-marker-stack)

;; Trying to make escape act sanely...
(global-set-key (kbd "ESC ESC")  'keyboard-escape-quit)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'python)
(define-key python-mode-map (kbd "M-t") 'jedi:goto-definition)
(define-key python-mode-map (kbd "M-<") 'jedi:goto-definition-pop-marker)
(define-key python-mode-map (kbd "M-h") 'jedi:show-doc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:              MISC INIT                 ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Various configurations that I like:
(setq-default indent-tabs-mode nil); Replace Tabs with spaces
(setq ring-bell-function   'ignore ; Who wants to hear this annoying bell anyways...
      make-backup-files     nil    ; By default, emacs makes to many backup files.
      org-imenu-depth       6
      backup-inhibited      t
      help-window-select    t
      scroll-conservatively 101    ; Scroll just one line when hitting bottom of window
      text-scale-mode-step 1.05
      org-edit-src-content-indentation 0; Org mode autoindents src code
      xref-prompt-for-identifier nil    ; So we don't need to input the symbol each time we call xref
      eldoc-echo-area-use-multiline-p t ; Let eldoc use more than 1 line in the echo area
      auto-save-default     nil
      xterm-max-cut-length  200000)

; Setting tab width
(setq tab-stop-list     '(0 3)
      tab-width           3)

;; Highlighting matching parens
(setq show-paren-when-point-inside-paren t)
(show-paren-mode)

;; Enabling various minor modes built in with emacs
(global-auto-revert-mode t)
(global-hl-line-mode +1) ; highlight current line
(scroll-bar-mode     -1)
(tool-bar-mode       -1)
(menu-bar-mode       -1)
(xterm-mouse-mode     1)
(electric-pair-mode   t)
;; Modifications to mode line
(size-indication-mode)
(column-number-mode   t)
(line-number-mode     t)

(which-function-mode)
(setq which-func-unknown "n/a") ; Display n/a instead of ???
;; Show current function in headerline and remove Which Function Mode from the mode line
(setq-default header-line-format '((which-function-mode ("" which-func-format " "))))
(setq mode-line-misc-info (assq-delete-all 'which-function-mode mode-line-misc-info))

;; Changing title of duplicate buffer titles
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;; Delete unused buffers after a certain amount of time. This could potentially go into sp00kyWork.
(require 'midnight)
(setq clean-buffer-list-delay-general 14)
(midnight-mode t)

;(sp00ky/remove-unused-desktop-lock)
;(setq desktop-restore-eager 10
;      desktop-load-locked-desktop 'nil)
;(desktop-save-mode 1)

;; (setq sp00ky/number-to-hex-timer
      ;; (run-with-idle-timer 0.5 t 'sp00ky/at-point-to-hex t))

(autoload 'cflow-mode "cflow-mode")
(add-to-list 'auto-mode-alist '("\\.flow\\'" . cflow-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.bb\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.cint\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.gpi\\'" . gnuplot-mode))
;;;;;;;;;;;;;;;;SUBSECTION: Programming Mode Hooks ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;SUBSECTION: Shell-script mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/sh-mode-hook ()
  "Various settings to apply to shell script"
  (interactive)
  (setq tab-stop-list     '(0 3)
        tab-width           3
        sh-basic-offset      3))
(add-hook 'sh-mode-hook 'sp00ky/sh-mode-hook)
;;;;;;;;;;;;;;;;SUBSECTION: C mode Hooks ;;;;;;;;;;;;;;;;
(setq c-default-style "k&r")
(defun sp00ky/c-mode-hook ()
  "Various configs I want to apply for c-mode"
  (interactive)
  (setq tab-stop-list     '(0 3)
        tab-width           3
        c-basic-offset      3
        c-tab-always-indent nil
        fill-column         100))
(add-hook 'c-mode-hook 'sp00ky/c-mode-hook)

;;;;;;;;;;;;;;;;SUBSECTION: Elisp mode Hooks ;;;;;;;;;;;;;;;;
(defvar init-el-lisp-imenu-generic-expression
  ;; Match on word followed optionionally by space + word
  (append (list '("Sections" ";SECTION:\s*+\\(\\w+\\([\s-]\\w+\\)*\\)"   1)
                '("Subsections" "SUBSECTION:\s*+\\(\\w+\\([\s-]\\w+\\)*\\)" 1))
          lisp-imenu-generic-expression)
  "imenu expressions to parse specific tags in init.el")

(defun sp00ky/emacs-lisp-mode-hook ()
  "Various configs I want to apply for c-mode"
  (interactive)
  (setq tab-always-indent nil)
  (abbrev-mode)
  (if (string-equal (buffer-name) "init.el")
      (setq imenu-generic-skip-comments-and-strings nil
            imenu-generic-expression init-el-lisp-imenu-generic-expression)))
(add-hook 'emacs-lisp-mode-hook 'sp00ky/emacs-lisp-mode-hook)

;;;;;;;;;;;;;;;;SUBSECTION: Scheme (Guile) mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/scheme-mode-hook ()
  "Various configs I want to apply for c-mode"
  (interactive))
(add-hook 'scheme-mode-hook 'sp00ky/scheme-mode-hook)
(require 'geiser-guile)
;; Empty for now

;;;;;;;;;;;;;;;;SUBSECTION: Python mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/python-mode-hook ()
  "Various configs I want to apply for c-mode"
  (interactive)
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'sp00ky/python-mode-hook)

;;;;;;;;;;;;;;;;SUBSECTION: Org mode Hooks ;;;;;;;;;;;;;;;;
(setq org-adapt-indentation 'nil)
(defun sp00ky/org-mode-hook ()
  "Various config for org-mode"
  (visual-line-mode t)
  (setq-local word-wrap nil)
  (setq fill-column 100))
(add-hook 'org-mode-hook 'sp00ky/org-mode-hook)
(require 'org)
(plist-put org-format-latex-options :scale 2.5)

;;;;;;;;;;;;;;;;SUBSECTION: Javascript mode ;;;;;;;;;;;;;;;;
(defun sp00ky/js-mode-hook ()
  "Various config for org-mode"
  (setq tab-stop-list     '(0 3)
        tab-width           3
        js-indent-level     3
        fill-column         100))
(add-hook 'js-mode-hook 'sp00ky/js-mode-hook)

;;;;;;;;;;;;;;;;SUBSECTION: Protobuf mode ;;;;;;;;;;;;;;;;
;; This is grabbed from:
;; https://github.com/protocolbuffers/protobuf/blob/master/editors/protobuf-mode.el
(if (file-exists-p "/localdata/hmuresan/my_builds/protobuf/editors/protobuf-mode.el")
    (progn (load "/localdata/hmuresan/my_builds/protobuf/editors/protobuf-mode.el")
           (require 'protobuf-mode)
           (add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode)))
  (message "Cannot locate protobuf-mode.el, not loading"))

;;;;;;;;;;;;;;SUBSECTION: Misc init elisp ;;;;;;;;;;;;;;;;;
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)
;; Changing font to my current favourite font, DejaVu Sans Mono
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-16"))

;; It's annoying when a new emacs instance prompts about a pre-existing server
;(require 'server)
;(if (not server-process)
;    (server-start)
;  (message "Not starting emacs server, one already exists"))

;; Emacs' customize interface pollutes the init file in an unseemly way.
(setq custom-file "~/.emacs.d/.emacs-custom.el")
(load custom-file)
;; Emacs sets package-selected-packges with custom variable settings which is annoying. Because it
;; then populates package-selected-packages in .emacs-custom.el. So to avoid emacs from setting this
;; variable we override this function.
;; NOTE: This doesnt seem to really work... since I see package-selected-packages still being populated
;; in .emacs-custom.el
(defun package--save-selected-packages (&optional value)
  "Set and save `package-selected-packages' to VALUE."
  (when value
    (setq package-selected-packages value)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:               COMMENTS                 ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If we want relative line number then we can do something like:
;; (require 'display-line-numbers)
;; (setq display-line-numbers-type 'relative)
;; (add-hook 'c-mode-hook 'display-line-numbers-mode)

;; Making evil not overwrite copied text when pasting
;; (define-key evil-visual-state-map "p" 'sp00ky/evil-paste-after-from-0)
;; (define-key evil-normal-state-map "p" 'evil-paste-after)
;; (define-key evil-visual-state-map "x" 'sp00ky/evil-cut-to-0)
;; (define-key evil-normal-state-map "x" 'sp00ky/evil-delete-char)

;; Some interesting helm config to take from https://tuhdo.github.io/helm-intro.html
;; helm-split-window-default-side
;; (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      ;; helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      ;; helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      ;; helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      ;; helm-ff-file-name-history-use-recentf t
      ;; helm-echo-input-in-header-line t)

;; To change emacs user directory from ~/.emacs.d
;;(setq user-emacs-directory "~/multimedia/.emacs.d/")

;; EVICS
(load "~/.emacs.d/evics/evics.el")
(evics-global-mode t)
(evics-init-esc)

(global-undo-tree-mode)
(define-key evics-normal-mode-map (kbd "M-x") 'helm-M-x)

;; Needed because we are skipping init hook when using -q it seems
(global-company-mode 1)
(defun sp00ky/keyboard-escape-quit (orig-fun &rest args)
  "Do not close all windows when calling keyboard-escape-quit"
  (cl-flet ((delete-other-windows (nil) 'nil))
    (message "here")
    (apply orig-fun args)))
(advice-add 'keyboard-escape-quit :around #'sp00ky/keyboard-escape-quit)
