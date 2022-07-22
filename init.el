;; TODO
;; - Using emacs compile to build:
;;     Will need to investigate dir variables
;;     Seems like we will need to set default directory then invoke compile, something like
;;     (defun compile-in-dir (dir command)
;;      (interactive "DCompile in directory: \nsCommand: ")
;       (let ((default-directory dir))
;;       (compile command)))
;;     Also look into compilation-search-path
;; - Look at so-long mode to handle long lines
;; - Look into fixing paragraph-start for programming modes (lines with whitespace should not count)
;; - Clean up modeline, for example, only need to show eyebrowse workspace thats currently active
;; - Enable visual-line-mode or auto-fill-mode for org-mode. For autofill mode, verify
;; if it can auto format lines when editing late
;; - Make helm respect screen split when using helm-buffer-max-length
;; - Maybe switch C-h i to 'info-display-manual
;; - Look at xref--marker-ring to make history function that does not pop the entry from the stack
;; - Figure out whats wrong with TAB in cc-mode
;;    - I think c-tab-always-indent fixes this
;; - elisp-eldoc support for multiline, see elisp-get-var-docstring, eldoc-documentation-function
;; - Emacs source code xref doesnt seem to work, see xref-backend-references. Issue seems to be that the
;;      Xref backend defaults to find | grep instead of using tags... Compare xref-backend-references and
;;      xref-backend-functions. I think there is also an configure option to not compress these
;; - Work on sp00ky global
;; - look at savehist
;; - Fix function definitions in C imenu that are in macros ... see BfdDebug file
;; - Look at removing mouse-buffer-menu
;; - Look at enabling pulse mode
;; - Look into undo-region
;; - helm look into typing something and hitting enter and it taking your literal input instead of
;; the item under the cursor
;; - Look at mouse-buffer-menu to see howto do x-popup-menu
;; - Look into org-comment-regexp, making it work when there is no space
;; - look into using package-quickstart
;;
;; MANUAL
;; - Read about assoc list (alists)
;; - Read about thread
;; - Read about CL, see example in helm-get-pid-from-process-name
;; - Look at command loop (Section 21 in elisp manual)
;;
;; Useful links:
;; https://karthinks.com/software/batteries-included-with-emacs/

;; Useful emacs compile command for being lightweight:
;; ./configure --without-all --with-xml2 --with-xft --with-libotf --with-x-toolkit=lucid --with-modules --with-png --with-jpeg --with-mailutils

(setq gc-cons-threshold (* 32 1024 1024))
;; Look into package-quickstate to speed package-initialize up
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
      '(corfu
        corfu-terminal
        ;; company
        ;; company-jedi
        docker-compose-mode
        graphviz-dot-mode
        htmlize
        call-graph
        citeproc
        eyebrowse       ; Can explore using built in tab-bar mode, or
                        ; window/frame registers
        geiser
        geiser-guile
        gnuplot
        helm
        helm-flyspell
        helm-gtags      ; Long term goal of replacing this with sp00ky-global
        helm-projectile
        helm-xref
        highlight-indent-guides
        highlight-parentheses
        projectile      ; Can use emacs built in project . el in emacs 28
        sudo-edit
        undo-tree     ; Can get rid of undo-tree in emacs 28, we can use undo-redo
        ))
(mapc 'sp00ky/install-package my-packages)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:            PACKAGE INIT                ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;SUBSECTION: Evics ;;;;;;;;;;;;;;;;
(when (file-exists-p "/multimedia/builds/evics")
  (add-to-list 'load-path "/multimedia/builds/evics"))
(when (file-exists-p "/localdata/hmuresan/my_builds/evics")
  (add-to-list 'load-path "/localdata/hmuresan/my_builds/evics"))
(require 'evics)
(evics-global-mode t)
(global-undo-tree-mode)

;;;;;;;;;;;;;;;;SUBSECTION: call-graph ;;;;;;;;;;;;;;;;
(require 'hierarchy)
(require 'call-graph)
;;;;;;;;;;;;;;;;SUBSECTION: graphviz-dot-mode ;;;;;;;;;;;;;;;;
(require 'graphviz-dot-mode)
(setq graphviz-dot-indent-width 3
      graphviz-dot-preview-extension "svg")
;;;;;;;;;;;;;;;;SUBSECTION: docker-compose-mode ;;;;;;;;;;;;;;;;
(require 'docker-compose-mode)
(add-to-list 'auto-mode-alist '("\\.yml.append\\'" . docker-compose-mode))
;;;;;;;;;;;;;;;;SUBSECTION: Corfu ;;;;;;;;;;;;;;;;
(require 'corfu)
(require 'corfu-terminal)
;; Some useful corfu config can be found here:
;; https://kristofferbalintona.me/posts/202202270056/
(setq corfu-min-width 50
      corfu-max-width corfu-min-width
      corfu-preselect-first t
      corfu-echo-documentation t
      corfu-auto t
      corfu-auto-prefix 4
      corfu-quit-no-match 'separator)
(define-key corfu-map (kbd "<escape>") 'corfu-quit)
(unless (display-graphic-p)
  (corfu-terminal-mode +1))
(global-corfu-mode)
;; (define-key prog-mode-map (kbd "TAB") 'completion-at-point)
;; (define-key prog-mode-map (kbd "<backtab>") 'completion-at-point)
;; (define-key c-mode-map (kbd "TAB") 'completion-at-point)
;; (define-key c-mode-map (kbd "<backtab>") 'completion-at-point)
(setq tab-always-indent 'complete)

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
(define-key helm-map (kbd "C-j") 'helm-next-line)
(define-key helm-map (kbd "C-p") 'helm-previous-line)
(define-key helm-map (kbd "M-j") 'helm-next-line)
(define-key helm-map (kbd "M-p") 'helm-previous-line)

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

;;;;;;;;;;;;;;;;SUBSECTION: helm-flyspell ;;;;;;;;;;;;;;;;
(require 'flyspell)
(define-key flyspell-mode-map (kbd "C-;") 'helm-flyspell-correct)

;;;;;;;;;;;;;;;;SUBSECTION: helm-gtags ;;;;;;;;;;;;;;;;
(defun sp00ky/gtags-find-current-function ()
  "Find the references for the current function that point is
in."
  (interactive)
  (let ((f (which-function)))
    (helm-gtags-find-rtag f)))

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

;; Extra gtags keybindings are also defined below.
(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "f") 'helm-gtags-dwim)
  (define-key helm-gtags-mode-map (kbd "F") 'helm-gtags-find-tag-other-window)
  (define-key helm-gtags-mode-map (kbd "M-T") 'sp00ky/gtags-find-current-function)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  (define-key helm-gtags-mode-map (kbd "M-f") 'helm-gtags-tags-in-this-function)
  (define-key helm-gtags-mode-map (kbd "<") 'helm-gtags-previous-history)
  (define-key helm-gtags-mode-map (kbd ">") 'helm-gtags-next-history)
  (evics-add-to-emulation-map (cons 'helm-gtags-mode helm-gtags-mode-map) 1))

(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'sh-mode-hook 'helm-gtags-mode)

;;;;;;;;;;;;;;;;SUBSECTION: Eyebrowse ;;;;;;;;;;;;;;;;
(require 'eyebrowse)
(setq eyebrowse-new-workspace t)
(define-key evics-normal-mode-map (kbd "w 1") 'eyebrowse-switch-to-window-config-1)
(define-key evics-normal-mode-map (kbd "w 2") 'eyebrowse-switch-to-window-config-2)
(define-key evics-normal-mode-map (kbd "w 3") 'eyebrowse-switch-to-window-config-3)
(define-key evics-normal-mode-map (kbd "w 4") 'eyebrowse-switch-to-window-config-4)
(define-key evics-normal-mode-map (kbd "w 5") 'eyebrowse-switch-to-window-config-5)
(define-key evics-normal-mode-map (kbd "w 6") 'eyebrowse-switch-to-window-config-6)
(define-key evics-normal-mode-map (kbd "w 7") 'eyebrowse-switch-to-window-config-7)
(define-key evics-normal-mode-map (kbd "w 8") 'eyebrowse-switch-to-window-config-8)
(define-key evics-normal-mode-map (kbd "w 9") 'eyebrowse-switch-to-window-config-9)
(define-key evics-normal-mode-map (kbd "w 0") 'eyebrowse-switch-to-window-config-0)

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

;;;;;;;;;;;;;;;;SUBSECTION: Comint and REPLs ;;;;;;;;;;;;;;;;
(defun sp00ky/evics/comint-history-up-override ()
  "When in a comint derived repl mode, make j/k go to the next or
previous item in the command history respectively."
  (interactive)
  (if evics-normal-mode
      (progn
        ;; Move point to the end of the repl prompt so comint does
        ;; not complain
        (goto-char (process-mark (get-buffer-process (current-buffer))))
        (call-interactively 'comint-previous-input))
    (call-interactively 'self-insert-command)))

(defun sp00ky/evics/comint-history-down-override ()
  "When in a comint derived repl mode, make j/k go to the next or
previous item in the command history respectively."
  (interactive)
  (if evics-normal-mode
      (progn
        ;; Move point to the end of the repl prompt so comint does
        (goto-char (process-mark (get-buffer-process (current-buffer))))
        (call-interactively 'comint-next-input))
    (call-interactively 'self-insert-command)))

(defun sp00ky/evics/commint-insert-hook ()
  "Move point to input line in comint buffer"
  (when evics-insert-mode
    (goto-char (process-mark (get-buffer-process (current-buffer))))))

(defun sp00ky/evics/comint-mode-hook ()
  "Adding buffer local hook to evics insert mode so we are always
placed on the input line"
  (add-hook evics-insert-mode-hook 'sp00ky/evics/commint-insert-hook 0 t))

(define-key comint-mode-map (kbd "k") 'sp00ky/evics/comint-history-up-override)
(define-key comint-mode-map (kbd "j") 'sp00ky/evics/comint-history-down-override)

;; Geiser above in Geiser section

;; GUD
(require 'gud)
(defvar sp00ky/evics/gud-mode nil)
(defun sp00ky/gud-mode-hook ()
  ""
  (setq-local sp00ky/evics/gud-mode t))
(add-hook 'gud-mode-hook 'sp00ky/gud-mode-hook)

(define-key gud-mode-map (kbd "k") 'sp00ky/evics/comint-history-up-override)
(define-key gud-mode-map (kbd "j") 'sp00ky/evics/comint-history-down-override)

(evics-add-to-emulation-map (cons 'sp00ky/evics/gud-mode gud-mode-map) 1)


;;;;;;;;;;;;;;;;SUBSECTION: Projectile ;;;;;;;;;;;;;;;;
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-w") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-w ESC") 'nil)
(setq projectile-enable-caching nil)
(setq projectile-globally-ignored-files
      (append '("GTAGS" "GPATH" "GRTAGS" "TAGS")))
(helm-projectile-on)

;;;;;;;;;;;;;;;;SUBSECTION: Highlight-Parentheses ;;;;;;;;;;;;;;;;
(require 'highlight-parentheses)
(add-hook 'prog-mode-hook 'highlight-parentheses-mode)

;;;;;;;;;;;;;;;;SUBSECTION: Highlight-Indent-Guides ;;;;;;;;;;;;;;;;
(setq highlight-indent-guides-method     'character
      highlight-indent-guides-responsive 'stack)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;;;;;;;;;;;;;;;;SUBSECTION: re-builder ;;;;;;;;;;;;;;;;
(require 're-builder)
(defvar sp00ky/evics/reb-mode nil
  "Indicates if re-builder is active. This is used to control
  evics keymap prios")
(add-hook 'reb-mode-hook (lambda ()
                           (setq-local sp00ky/evics/reb-mode t)))
(evics-add-to-emulation-map (cons 'sp00ky/evics/reb-mode reb-mode-map) 1)
(define-key reb-mode-map (kbd "q") 'reb-quit)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:       MISC ELISP LOADING               ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load (sp00ky/set-init-file-path "sp00ky-functions.el"))
(load (sp00ky/set-init-file-path "sp00ky-abbrevs.el"))
(if (file-exists-p (sp00ky/set-init-file-path ".sp00ky-work"))
    (load (sp00ky/set-init-file-path "sp00ky-work.el"))
  (load (sp00ky/set-init-file-path "sp00ky-home.el")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:            MISC KEYBINDINGS            ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evics extended keybindings. Not needed in mini-mode.
(define-key evics-normal-mode-map (kbd "C-j") 'evics-join-line)
(define-key evics-normal-mode-map "s" 'save-buffer)
(define-key evics-normal-mode-map "J" 'forward-paragraph)
(define-key evics-normal-mode-map "K" 'backward-paragraph)

(define-key evics-user-normal-map (kbd ";") 'helm-buffers-list)
(define-key evics-user-normal-map (kbd "S") 'helm-occur)
(define-key evics-user-normal-map (kbd "]") 'scroll-up-command)
(define-key evics-user-normal-map (kbd "[") 'scroll-down-command)
(define-key evics-user-normal-map (kbd "`") 'sp00ky/highlight-word-at-point)
(define-key evics-user-normal-map (kbd ",") 'sp00ky/highlight-word-at-point)
(define-key evics-user-normal-map (kbd "M-,") 'sp00ky/unhighlight-all-in-buffer)

;; t prefix key
(define-key evics-user-normal-map (kbd "t e") 'sp00ky/gdb-wrapper)
(define-key evics-user-normal-map (kbd "t a") 'beginning-of-defun)
(define-key evics-user-normal-map (kbd "t o") 'sp00ky/switch-to-current-buffer-other-window)
(define-key evics-user-normal-map (kbd "t i") 'helm-imenu)
(define-key evics-user-normal-map (kbd "t r") 'helm-resume)
(define-key evics-user-normal-map (kbd "t x") 'toggle-truncate-lines)

(define-key evics-user-normal-map (kbd "t w g") 'helm-projectile-grep)
(define-key evics-user-normal-map (kbd "t w f") 'helm-projectile-find-file)
(define-key evics-user-normal-map (kbd "t f") 'helm-projectile-find-file)
(define-key evics-user-normal-map (kbd "t w p") 'helm-projectile-switch-project)
(define-key evics-user-normal-map (kbd "t p") 'helm-projectile-switch-project)

(define-key evics-user-normal-map (kbd "t g f") 'sp00ky/gtags-find-current-function)
(define-key evics-user-normal-map (kbd "t F") 'sp00ky/gtags-find-current-function)
(define-key evics-user-normal-map (kbd "t g n") 'helm-gtags-tags-in-this-function)
(define-key evics-user-normal-map (kbd "t g p") 'helm-gtags-parse-file)

(define-key evics-user-normal-map (kbd "t v g") 'vc-annotate)

;; Helm info keybindings
(define-key evics-user-normal-map (kbd "t h e") 'helm-info-emacs)
(define-key evics-user-normal-map (kbd "t h l") 'helm-info-elisp)
(define-key evics-user-normal-map (kbd "t h g") 'helm-info-guile)
(define-key evics-user-normal-map (kbd "t h v") 'describe-variable)
(define-key evics-user-normal-map (kbd "t h k") 'describe-key)
(define-key evics-user-normal-map (kbd "t h K") 'describe-keymap)
(define-key evics-user-normal-map (kbd "t h f") 'describe-function)

(with-eval-after-load 'winner
  (define-key evics-user-normal-map (kbd "w z") 'toggle-maximize-buffer)
  (define-key evics-user-normal-map (kbd "w h") 'windmove-left)
  (define-key evics-user-normal-map (kbd "w l") 'windmove-right)
  (define-key evics-user-normal-map (kbd "w j") 'windmove-down)
  (define-key evics-user-normal-map (kbd "w k") 'windmove-up)
  (define-key evics-user-normal-map (kbd "w o") 'delete-other-windows)
  (define-key evics-user-normal-map (kbd "w c") 'delete-window))

;; Evics mark active keybindings
(define-key evics-mark-active-mode-map (kbd "+") #'(lambda ()
                                                     (interactive)
                                                     (deactivate-mark)
                                                     (save-excursion
                                                       (mark-defun)
                                                       (call-interactively 'indent-region))))
(define-key evics-mark-active-mode-map (kbd "f") 'mark-defun)
;; (define-key evics-mark-active-mode-map (kbd "C-b") 'mark-whole-buffer)
(define-key evics-mark-active-mode-map (kbd "v") #'(lambda ()
                                                     (interactive)
                                                     (deactivate-mark)
                                                     (mark-paragraph)))




;; This sometimes invoked eval-expression instead of going to command
;; mode in evics. This is related to how TTYs send ESC and META.
(global-set-key (kbd "M-:")   'evics-command)
(global-set-key (kbd "M-w")   'hippie-expand)
(global-set-key (kbd "C-x C-b") 'switch-to-buffer)
(global-set-key (kbd "C-x C-b") 'switch-to-buffer)
(global-set-key (kbd "C-x C-e") 'eval-last-sexp)
(global-set-key (kbd "C-c s") 'split-window-horizontally)
(global-set-key (kbd "C-c m") 'bookmark-set)
(global-set-key (kbd "C-c M") 'bookmark-set-no-overwrite)
(global-set-key (kbd "C-c d") 'bookmark-delete)
(global-set-key (kbd "C-=")   'align)
(global-set-key (kbd "C-c l") 'recenter)
(global-set-key (kbd "C-h M") 'man)
(global-set-key (kbd "C-;")   'comment-line)
(global-set-key (kbd "M-;")   'comment-region)

;; In the future, lets move out these requires and add them to a hook.
(with-eval-after-load 'vc-annotate
  (define-key vc-annotate-mode-map (kbd "L") 'vc-annotate-show-log-revision-at-line))
(define-key help-mode-map (kbd "M-<") 'help-go-back)
(define-key help-mode-map (kbd "M->") 'help-go-forward)
(define-key Info-mode-map (kbd "M-<") 'Info-history-back)
(define-key Info-mode-map (kbd "M->") 'Info-history-forward)
(define-key Info-mode-map (kbd "H") 'Info-last)
(define-key Info-mode-map (kbd "J") 'Info-forward-node)
(define-key Info-mode-map (kbd "K") 'Info-backward-node)
(define-key Info-mode-map (kbd "C-k") 'Info-up)
(define-key Info-mode-map (kbd "L") 'Info-history-forward)
(define-key Info-mode-map (kbd ",") 'Info-index-next)

(define-key emacs-lisp-mode-map (kbd "M-r") 'xref-find-references)
(define-key emacs-lisp-mode-map (kbd "M-t") 'xref-find-definitions)
(define-key emacs-lisp-mode-map (kbd "M-<") 'xref-pop-marker-stack)

;; Trying to make escape act sanely...
(global-set-key (kbd "ESC ESC")  'keyboard-escape-quit)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(with-eval-after-load 'python
  (define-key python-mode-map (kbd "M-t") 'anaconda-mode-find-definitions)
  (define-key python-mode-map (kbd "M-r") 'anaconda-mode-find-references)
  (define-key python-mode-map (kbd "M-<") 'xref-pop-marker-stack)
  (define-key python-mode-map (kbd "M-h") 'anaconda-mode-show-doc)
  (define-key python-mode-map (kbd "TAB") 'sp00ky/indent-region-or-paragraph)
  (define-key python-mode-map (kbd "<backtab>") 'sp00ky/align-region-or-paragraph)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:              MISC INIT                 ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'gdb-mi
  (setq gdb-default-window-configuration-file "sp00ky-gdb-layout"
        gdb-display-io-nopopup t))

;; Various configurations that I like:
(setq-default abbrev-mode t)

(require 'ispell)
(setq-default ispell-program-name "aspell")

(setq-default indent-tabs-mode nil ; Replace Tabs with spaces
              show-trailing-whitespace t)
(setq ring-bell-function   'ignore ; Who wants to hear this annoying bell anyways...
      make-backup-files     nil    ; By default, emacs makes to many backup files.
      org-imenu-depth       6
      backup-inhibited      t
      help-window-select    t
      scroll-conservatively 101    ; Scroll just one line when hitting bottom of window
      text-scale-mode-step  1.05
      Man-notify-method     'aggressive
      org-edit-src-content-indentation 0   ; Org mode autoindents src code
      xref-prompt-for-identifier       nil ; So we don't need to input the symbol each
                                        ; time we call xref
      eldoc-echo-area-use-multiline-p  t   ; Let eldoc use more than 1 line in the echo area
      auto-save-default      nil
      xterm-max-cut-length   200000
      frame-resize-pixelwise t             ; Allow emacs frame to not be bound by char height
                                           ; This fixes when emacs is fullscreened and there is
                                           ; still some extra space at the bottom
      )

;; Mouse settings
(setq mouse-wheel-scroll-amount '(5
                                  ((shift). hscroll)
                                  ((meta))
                                  ((control) . text-scale)))


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
(electric-pair-mode   t)
;; Modifications to mode line
(size-indication-mode)
(column-number-mode   t)
(line-number-mode     t)

;; Removing mouse movement sequences, they don't seem to play well in
;; TTY mode. Mouse movement + hitting escape seems to trigger emacs to
;; close windows.
(when (terminal-live-p (frame-terminal))
  (advice-add
   'xterm-mouse--tracking-sequence
   :override
   'sp00ky/xterm-mouse--tracking-sequence))
(xterm-mouse-mode t)

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
(setq clean-buffer-list-delay-general 10)
(midnight-mode t)

(sp00ky/remove-unused-desktop-lock)
(setq desktop-restore-eager 10
      desktop-load-locked-desktop 'nil
      desktop-auto-save-timeout 300)
(desktop-save-mode 1)

(setq sp00ky/number-to-hex-timer
      (run-with-idle-timer 0.5 t 'sp00ky/at-point-to-hex t))

;; Adding capfs config
(add-to-list 'completion-at-point-functions 'sp00ky/gtags-completion-at-point)

(autoload 'cflow-mode "cflow-mode")
(add-to-list 'auto-mode-alist '("\\.md\\'"   . text-mode))
(add-to-list 'auto-mode-alist '("\\.flow\\'" . cflow-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'"  . conf-mode))
(add-to-list 'auto-mode-alist '("\\.bb\\'"   . conf-mode))
(add-to-list 'auto-mode-alist '("\\.cint\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.gpi\\'"  . gnuplot-mode))
(add-to-list 'auto-mode-alist '("\\.completion\\'"  . shell-script-mode))
;;;;;;;;;;;;;;;;SUBSECTION: Programming Mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/align-region-or-paragraph ()
  "align paragraph"
  (interactive)
  (save-excursion
    (if (not mark-active)
        (mark-paragraph))
    (call-interactively 'align)
    (deactivate-mark)))

(defun sp00ky/indent-region-or-paragraph ()
  "Indent paragraph or region if active"
  (interactive)
  (save-excursion
    (if (not mark-active)
        (mark-paragraph))
    (call-interactively 'indent-region)))

(define-key prog-mode-map (kbd "TAB") 'sp00ky/indent-region-or-paragraph)
(define-key prog-mode-map (kbd "<backtab>") 'sp00ky/align-region-or-paragraph)
(with-eval-after-load 'cc-mode
  (define-key c-mode-map (kbd "TAB") 'sp00ky/indent-region-or-paragraph)
  (define-key c-mode-map (kbd "<backtab>") 'sp00ky/align-region-or-paragraph))
(with-eval-after-load 'protobuf-mode
  (define-key protobuf-mode-map (kbd "TAB") 'sp00ky/indent-region-or-paragraph)
  (define-key protobuf-mode-map (kbd "<backtab>") 'sp00ky/align-region-or-paragraph))


;;;;;;;;;;;;;;;;SUBSECTION: Shell-script mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/sh-mode-hook ()
  "Various settings to apply to shell script"
  (abbrev-mode t)
  (setq tab-stop-list     '(0 3)
        tab-width           3
        sh-basic-offset     3))
(add-hook 'sh-mode-hook 'sp00ky/sh-mode-hook)
;;;;;;;;;;;;;;;;SUBSECTION: C mode Hooks ;;;;;;;;;;;;;;;;
(setq c-default-style "k&r")
(defun sp00ky/c-mode-hook ()
  "Various configs I want to apply for c-mode"
  (c-set-offset 'case-label '+)
  ;; (setq-local completion-at-point-functions (list 'sp00ky/gtags-completion-at-point))
  (setq tab-stop-list     '(0 3)
        tab-width           3
        c-basic-offset      3
        c-tab-always-indent nil
        comment-start       "// "
        comment-end         ""
        fill-column         80))
(add-hook 'c-mode-hook 'sp00ky/c-mode-hook)
(add-hook 'protobuf-mode-hook 'sp00ky/c-mode-hook)
;;;;;;;;;;;;;;;;SUBSECTION: Conf mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/text-mode-hook ()
  (setq fill-column 80))
(add-hook 'text-mode-hook 'sp00ky/text-mode-hook)

;;;;;;;;;;;;;;;;SUBSECTION: Tex mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/tex-mode-hook ()
  (flyspell-mode-on))
(add-hook 'tex-mode-hook 'sp00ky/tex-mode-hook)

;;;;;;;;;;;;;;;;SUBSECTION: Elisp mode Hooks ;;;;;;;;;;;;;;;;
(defvar init-el-lisp-imenu-generic-expression
  ;; Match on word followed optionionally by space + word
  (append (list '("Sections" ";SECTION:\s*+\\(\\w+\\([\s-]\\w+\\)*\\)"   1)
                '("Subsections" "SUBSECTION:\s*+\\(\\w+\\([\s-]\\w+\\)*\\)" 1))
          lisp-imenu-generic-expression)
  "imenu expressions to parse specific tags in init.el")

(defun sp00ky/emacs-lisp-mode-hook ()
  "Various configs I want to apply for c-mode"
  (setq tab-always-indent nil)
  (abbrev-mode t)
  (if (string-equal (buffer-name) "init.el")
      (setq imenu-generic-skip-comments-and-strings nil
            imenu-generic-expression init-el-lisp-imenu-generic-expression)))
(add-hook 'emacs-lisp-mode-hook 'sp00ky/emacs-lisp-mode-hook)
(define-key emacs-lisp-mode-map (kbd "M-t") 'xref-find-definitions)
(define-key emacs-lisp-mode-map (kbd "M-<") 'xref-pop-marker-stack)

;;;;;;;;;;;;;;;;SUBSECTION: geiser, Scheme (Guile) mode Hooks ;;;;;;;;;;;;;;;;
(require 'geiser-guile)
(require 'geiser-mode)
(define-key geiser-mode-map (kbd "M-t") 'geiser-edit-symbol-at-point)
(define-key geiser-mode-map (kbd "M-<") 'geiser-pop-symbol-stack)
;; (define-key geiser-mode-map (kbd "z") 'geiser-eval-buffer)

(require 'geiser-repl)
(setq geiser-repl-current-project-function 'projectile-project-root)
(defvar sp00ky/evics/geiser-repl-mode nil)
(defun sp00ky/geiser-repl-mode-hook ()
  ""
  (setq-local sp00ky/evics/geiser-repl-mode t))
(add-hook 'geiser-repl-mode-hook 'sp00ky/geiser-repl-mode-hook)

(define-key geiser-repl-mode-map (kbd "C-a") 'nil)
(define-key geiser-repl-mode-map (kbd "k") 'sp00ky/evics/comint-history-up-override)
(define-key geiser-repl-mode-map (kbd "j") 'sp00ky/evics/comint-history-down-override)

(evics-add-to-emulation-map (cons 'sp00ky/evics/geiser-repl-mode geiser-repl-mode-map) 1)

;;;;;;;;;;;;;;;;SUBSECTION: Python mode Hooks ;;;;;;;;;;;;;;;;
(defun sp00ky/python-mode-hook ()
  "Various configs I want to apply for c-mode"
  (interactive)
  (add-to-list 'completion-at-point-functions 'anaconda-mode-complete))
(remove-hook 'python-mode-hook 'sp00ky/python-mode-hook)
(add-hook 'python-mode-hook 'anaconda-mode)

;;;;;;;;;;;;;;;;SUBSECTION: Org mode Hooks ;;;;;;;;;;;;;;;;
(require 'citeproc)
(require 'oc-csl)
(defun sp00ky/org-mode-hook ()
  "Various config for org-mode"
  (flyspell-mode t)
  (visual-line-mode t)
  (setq-local word-wrap nil)
  (setq fill-column 90))

(with-eval-after-load 'org
  (setq org-adapt-indentation 'nil)
  (add-hook 'org-mode-hook 'sp00ky/org-mode-hook)
  (plist-put org-format-latex-options :scale 2.5))

(setq org-publish-project-alist
      '(("notes"
         :base-directory "~/notes/"
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/notes/html"
         :section-numbers nil
         :with-toc t
         :makeindex t
         :html-head-include-default-style nil
         :html-head "<link rel=\"stylesheet\"
                         href=\"../style.css\"
                         type=\"text/css\"/>"
         :html-postamble t
         :html-postamble-format (("en" "<p class=\"date\">Last Updated: %T\n</p>"))
         )))

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
    (progn (load "/localdata/hmuresan/my_builds/protobuf/editors/protobuf-mode")
           (require 'protobuf-mode)
           (add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode)))
  (message "Cannot locate protobuf-mode.el, not loading"))

;;;;;;;;;;;;;;SUBSECTION: Misc init elisp ;;;;;;;;;;;;;;;;;
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)
;; Changing font to my current favourite font, DejaVu Sans Mono
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-16"))
(set-face-attribute 'fixed-pitch nil :font "DejaVu Sans Mono-16")

;; It's annoying when a new emacs instance prompts about a pre-existing server
(require 'server)
(if (not (server-running-p))
    (server-start)
  (message "Not starting emacs server, one already exists"))

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

(let ((file "~/.emacs.d/bb-mode.el"))
  (when (file-exists-p file)
    (load file)
    (require 'bb-mode)
    (setq auto-mode-alist (cons '("\\.bb$"  . bb-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.inc$" . bb-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.bbappend$" . bb-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.bbclass$"  . bb-mode) auto-mode-alist))
    ;; (setq auto-mode-alist (cons '("\\.conf$" . bb-mode) auto-mode-alist))
    ))

(let ((file "~/.emacs.d/help-fns+.el"))
  (when (file-exists-p file)
    (load file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;SECTION:               COMMENTS                 ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If we want relative line number then we can do something like:
;; (require 'display-line-numbers)
;; (setq display-line-numbers-type 'relative)
;; (add-hook 'c-mode-hook 'display-line-numbers-mode)

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
