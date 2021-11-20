(load-file (concat user-emacs-directory "/evics/" "evicsFunctions.el"))
(load-file (concat user-emacs-directory "/evics/" "evicsNormalMode.el"))
(load-file (concat user-emacs-directory "/evics/" "evicsInsertMode.el"))
(load-file (concat user-emacs-directory "/evics/" "evicsVisualMode.el"))

;;; Look into help-mode-map

(require 'winner)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;         Keymap            ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key winner-mode-map (kbd "C-a h") 'windmove-left)
(define-key winner-mode-map (kbd "C-a l") 'windmove-right)
(define-key winner-mode-map (kbd "C-a j") 'windmove-down)
(define-key winner-mode-map (kbd "C-a k") 'windmove-up)
(winner-mode t)

(define-key emacs-lisp-mode-map (kbd "M-t") 'xref-find-definitions)
(define-key emacs-lisp-mode-map (kbd "M-<") 'xref-pop-marker-stack)

(defvar evics-special-mode nil "val")
(defun evics-special-hook ()
  "This function sets evics-special-mode, which puts special mode keybindings before evics bindings"
  (interactive)
  (setq-local evics-special-mode t))
(add-hook 'special-mode-hook 'evics-special-hook)

(defvar evics-Info-mode nil "val")
(defun evics-Info-hook ()
  "This function sets evics-Info-mode, which puts Info mode keybindings before evics bindings"
  (interactive)
  (setq-local evics-Info-mode t))
(add-hook 'Info-mode-hook 'evics-Info-hook)

(require 'help-mode)
(require 'info)
(add-to-list 'minor-mode-map-alist (cons 'evics-special-mode special-mode-map))
(add-to-list 'minor-mode-map-alist (cons 'evics-Info-mode Info-mode-map))

;; (defun evics-transient-mode-hook ()
  ;; "Hide the cursor when entering transient mode, and show cursor when exiting"
  ;; (interactive)
  ;; (if (region-active-p)
      ;; (internal-show-cursor (selected-window) 'nil)
    ;; (internal-show-cursor (selected-window) t)))
;; (add-hook 'transient-mode 'evics-transient-mode-hook)

;; This will cause us to replace selected text when pasting etc...
(delete-selection-mode 1)

;; (define-global-minor-mode global-evics-normal-mode evics-normal-mode evics-normal-mode)
(defun evics-enable-normal-mode ()
  "Function that will determine if we want to enable evics"
  (if (not (minibufferp (current-buffer)))
      (evics-normal-mode 1)))
(define-globalized-minor-mode evics-global-mode evics-normal-mode evics-enable-normal-mode)
;; To test use:
;; emacs -nw -q -l init_test.el  --file scratch/tmp.txt


