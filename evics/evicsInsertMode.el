(defvar evics-insert-mode-map (make-sparse-keymap) "Evics insert mode keymap")

(defun evics-goto-normal-mode ()
  "Switch from whatever evics mode to evics normal mode"
  (interactive)
  (backward-char)
  (evics-insert-mode -1)
  (evics-normal-mode t)
  (keyboard-quit))

(define-key evics-insert-mode-map (kbd "M-c") 'evics-goto-normal-mode)

(define-key evics-insert-mode-map (kbd "<escape>") 'evics-goto-normal-mode)


(define-minor-mode evics-insert-mode
  "Toggle evics normal mode."
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " <I>"
  ;; The minor mode bindings.
  :keymap evics-insert-mode-map
  (setq cursor-type 'bar))
