;;; evil-keybindings
(defun sp00ky/evil-cut-to-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-yank)
    (call-interactively 'evil-delete-char)))

(defun sp00ky/evil-delete-char ()
  (interactive)
  (let ((evil-this-register ?_))
    (call-interactively 'evil-delete-char)))
(define-key evil-visual-state-map "x" 'sp00ky/evil-cut-to-0)
(define-key evil-normal-state-map "x" 'sp00ky/evil-delete-char)

(defun evil-paste-after-from-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-paste-after)))
(define-key evil-visual-state-map "p" 'evil-paste-after-from-0)
(define-key evil-normal-state-map "p" 'evil-paste-after)
(define-key evil-visual-state-map "x" 'sp00ky/evil-cut-to-0)
(define-key evil-normal-state-map "x" 'sp00ky/evil-delete-char)
(setq text-scale-mode-step 1.05)
(define-key evil-normal-state-map "+" 'text-scale-increase)
(define-key evil-normal-state-map "-" 'text-scale-decrease)

(evil-ex-define-cmd "Q" 'kill-this-buffer)
(evil-ex-define-cmd "E" 'evil-edit)
(evil-ex-define-cmd "Wq" 'evil-save-and-close)
(evil-ex-define-cmd "W" 'evil-write)
(evil-ex-define-cmd "Qa" "quitall")
(evil-ex-define-cmd "Wqa" 'evil-save-and-quit)
(evil-ex-define-cmd "q" 'kill-this-buffer)
;; Need to type out :quit to close emacs
(evil-ex-define-cmd "quit" 'evil-quit)

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; (define-key evil-motion-state-map (kbd "C-z") 'nil)
(define-key evil-motion-state-map (kbd "TAB") 'nil)
(define-key evil-window-map "\C-h" 'evil-window-left)

;;; company
(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "S-TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-n") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; helm
(global-set-key (kbd "C-s") 'helm-occur)
;; (global-unset-key (kbd "C-z"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c r") 'helm-resume)
(global-set-key (kbd "M-f") 'helm-find-files)
(define-key helm-map (kbd "C-j") 'helm-next-line) ; navigate minibuffer
(define-key helm-map (kbd "C-k") 'helm-previous-line) ; navigate minibuffer
; fix helm tabs
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)

;; helm-gtags
(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-dwim)
  (define-key helm-gtags-mode-map (kbd "M-T") 'helm-gtags-find-tag)
  (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  ;; (define-key helm-gtags-mode-map (kbd "M-f") 'helm-gtags-find-files)
  (define-key helm-gtags-mode-map (kbd "M-f") 'helm-gtags-tags-in-this-function)
  (define-key helm-gtags-mode-map (kbd "C-k") 'helm-gtags-previous-history)
  (define-key helm-gtags-mode-map (kbd "M->") 'helm-gtags-next-history)
  (define-key helm-gtags-mode-map (kbd "M-<") 'helm-gtags-previous-history)
  )

;;; ibuffer
(global-set-key (kbd "C-x B") 'ibuffer)
(global-set-key (kbd "C-x C-b") 'switch-to-buffer)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-c z") 'toggle-maximize-buffer)
(global-set-key (kbd "C-c s") 'split-window-horizontally)
(global-set-key (kbd "C-x C-e") 'eval-last-sexp)

;;; counsel
;(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
;(global-set-key (kbd "C-c r") 'ivy-resume)
;(global-set-key (kbd "C-c i") 'counsel-imenu)
;(global-set-key (kbd "M-x") 'counsel-M-x)
;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;(global-set-key (kbd "C-c b") 'counsel-bookmark)
;(global-set-key (kbd "C-c D") 'counsel-descbinds)
;(global-set-key (kbd "C-c g") 'counsel-git)

(global-set-key (kbd "C-c b") 'helm-bookmarks)
(global-set-key (kbd "C-c m") 'bookmark-set)
(global-set-key (kbd "C-c M") 'bookmark-set-no-overwrite)
(global-set-key (kbd "C-c d") 'bookmark-delete)
;(define-key ivy-minibuffer-map (kbd "C-m") 'ivy-call)
;(define-key ivy-minibuffer-map (kbd "<return>") 'ivy-done)
;(define-key ivy-minibuffer-map (kbd "TAB") 'ivy-call)

;;; neotree
(global-set-key [f8] 'neotree-toggle)
(add-hook 'neotree-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;(evil-define-key 'normal pdf-occur-buffer-mode-map
;  (kbd "RET") 'pdf-occur-goto-occurrence
;  (kbd "q") 'quit-window)

;;; speedbar
(global-set-key [f9] 'speedbar-get-focus)
(global-set-key [f10] 'speedbar-update-current-file)

;;; tex
;(define-key evil-insert-state-map (kbd "C-c c") 'insert-coordinates)
;(define-key flyspell-mode-map (kbd "C-;") 'flyspell-correct-previous)
;(define-key reftex-toc-mode-map (kbd "j") 'reftex-toc-next)
;(define-key reftex-toc-mode-map (kbd "k") 'reftex-toc-previous)

;;; misc
(global-set-key (kbd "C-=") 'align)
(global-set-key (kbd "C-c l") 'recenter)
(global-set-key (kbd "C-h M") 'man)
(global-set-key [f2] 'sp00ky-idle-highlight-word-at-point)
(global-set-key [(shift f2)] 'sp00ky-unhighlight-all-in-buffer)
;(global-set-key [f2] 'highlight-symbol)
(define-key ibuffer-mode-map "e" 'ibuffer-ediff-marked-buffers)
(global-set-key (kbd "ESC ESC") 'keyboard-escape-quit)
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)
;; (define-key key-translation-map (kbd "ESC") (kbd "ESC"))
(global-set-key (kbd "C-;") 'comment-line)
;(define-key undo-tree-map (kbd "C-/") 'nil)
(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "M-;") 'comment-region)
(define-key evil-motion-state-map (kbd "C-i") 'nil)
(add-hook 'c-mode-hook
          '(lambda ()
             (define-key c-mode-map (kbd "C-i") 'nil)))
(setq helm-imenu-fuzzy-match t)
(global-set-key (kbd "C-i") 'helm-imenu)
(global-set-key (kbd "TAB") 'evil-toggle-fold)
(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)

;;; projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-w") 'projectile-command-map)
;; (eval-after-load "evil-maps"
  ;; (define-key evil-motion-state-map (kbd "C-w") nil))
;; (define-key evil-normal-state-map (kbd "C-a") 'evil-window-map)
(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map
                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) (kbd "C-w") nil)
    (define-key (eval map) (kbd "C-a") 'evil-window-map)))
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-c z") 'helm-command-prefix)
;; Magit
(bind-keys :prefix-map my-magit-map
           :prefix "C-x m"
           ("g" . magit-status)
           ("l" . magit-log-current)
           ("y" . magit-show-refs)
           )
(evil-define-key evil-magit-state magit-status-mode-map "y" 'magit-show-refs)
(evil-define-key evil-magit-state magit-status-mode-map "p" 'magit-log)
(evil-define-key evil-magit-state magit-status-mode-map "P" 'magit-log-refresh)

;;;python
(define-key elpy-mode-map (kbd "M-t") 'elpy-goto-definition)
(define-key elpy-mode-map (kbd "M-<") 'pop-tag-mark)

(define-key Info-mode-map (kbd "H") 'Info-last)
(define-key Info-mode-map (kbd "J") 'Info-forward-node)
(define-key Info-mode-map (kbd "K") 'Info-backward-node)
(define-key Info-mode-map (kbd "L") 'Info-history-forward)


(define-key emacs-lisp-mode-map (kbd "M-t") 'xref-find-definitions)
(define-key emacs-lisp-mode-map (kbd "M-<") 'xref-pop-marker-stack)
