;; EVICS
;; - Keyboard macros "q"
;; - Make yank (pasting) more like vim
;; - Probably have to change evics-command-mode-map to be an alist instead of keymap to handle
;; string arguments
;; - Show current mode on modeline
;; - highlight under cursor when marking region
;; - maybe use previous-logical-line
;; - For regex replace, see if we can do global replace i.e. s/<pat>/<pat>/g
;; - Record kbd macros with q (see keyboard macro registers in manual)
;; - Make evics commands handle prefix values
;;

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
  "This function sets evics-special-mode, which puts special mode
keybindings before evics bindings"
  (interactive)
  (setq-local evics-special-mode t))
(add-hook 'special-mode-hook 'evics-special-hook)

(defvar evics-Info-mode nil "val")
(defun evics-Info-hook ()
  "This function sets evics-Info-mode, which puts Info mode
keybindings before evics bindings"
  (interactive)
  (setq-local evics-Info-mode t))
(add-hook 'Info-mode-hook 'evics-Info-hook)
;; (define-key Info-mode-map (kbd "h") 'left-char)
;; (define-key Info-mode-map (kbd "j") 'next-line)
;; (define-key Info-mode-map (kbd "k") 'previous-line)
;; (define-key Info-mode-map (kbd "l") 'right-char)


(require 'help-mode)
(require 'info)
;; (add-to-list 'minor-mode-map-alist (cons 'evics-special-mode special-mode-map))
;; (add-to-list 'minor-mode-map-alist (cons 'evics-Info-mode Info-mode-map))

(require 'thingatpt)
(define-thing-chars evics-WORD "[:alnum:]_-")

(defun evics-visual-pre-command ()
  "Check the current position vs evics-region-position and move
  mark accordingly to emulate vim line mode highlighting"
  (setq evics-previous-line-number (line-number-at-pos)))
(add-hook 'pre-command-hook 'evics-visual-pre-command)

(defun evics-visual-post-command ()
  "Check the current position vs evics-region-position and move
  mark accordingly to emulate vim line mode highlighting"
  (if (and (boundp evics-visual-mode)
           evics-visual-mode)
      (let ((line-number (line-number-at-pos)))
        (cond ((and (<= evics-previous-line-number line-number)
                    (= (+ 1 evics-region-position) line-number))
               (progn
                 (goto-line evics-region-position)
                 (set-mark (point))
                 (goto-line (+ 1 line-number))))
              ((and (= evics-region-position line-number)
                    (> evics-previous-line-number evics-region-position))
               (progn
                 (call-interactively 'evics-select-line)
                 (forward-line -1)))))))
;; (evics-visual-post-command)
(add-hook 'post-command-hook 'evics-visual-post-command)

(defun evics-mini-mode-override ()
  "Adding a overriding map to current mode to prevent it from
clobbering basic movement commands"
  (add-to-list 'minor-mode-overriding-map-alist
               (cons 'evics-normal-mode evics-mini-normal-mode-map)))
(add-hook 'special-mode-hook 'evics-mini-mode-override)
(add-hook 'Info-mode-hook 'evics-mini-mode-override)


;; This will cause us to replace selected text when pasting etc...
(delete-selection-mode 1)

;; (define-global-minor-mode global-evics-normal-mode evics-normal-mode evics-normal-mode)
(defun evics-enable-normal-mode ()
  "Function that will determine if we want to enable evics"
  (if (not (minibufferp (current-buffer)))
      (evics-normal-mode 1)))
(define-globalized-minor-mode evics-global-mode evics-normal-mode evics-enable-normal-mode)

(defvar evics-visual-block-callback nil
  "Callback to disable the transient rectangle-mark-mode-map that
  we enable when selecting rectangles in rectangle-mark-mode")
(make-variable-buffer-local 'evics-visual-block-callback)

(defun evics-toggle-transient-rectangle-map ()
  "DOCSTRING"
  (if rectangle-mark-mode
      (progn (setq evics-visual-block-callback
                   (set-transient-map
                    rectangle-mark-mode-map 'evics-keep-pred-cb)))
    (when evics-visual-block-callback
      (funcall evics-visual-block-callback)
      (setq evics-visual-block-callback nil))))
(define-key rectangle-mark-mode-map (kbd "I") 'string-insert-rectangle)
(add-hook 'rectangle-mark-mode-hook 'evics-toggle-transient-rectangle-map)

;; To test use:
;; emacs -nw -q -l init_test.el  --file scratch/tmp.txt


