(defvar evics-visual-mode-map (make-sparse-keymap) "Evics insert mode keymap")

(define-key evics-visual-mode-map (kbd "M-c") 'evics-goto-normal-mode)
(define-key evics-visual-mode-map (kbd "<escape>") 'evics-goto-normal-mode)

(define-minor-mode evics-visual-mode
  "Toggle evics visual mode."
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " <V>"
  ;; The minor mode bindings.
  :keymap evics-insert-mode-map
  :group 'evics-insert
  (setq cursor-type 'bar))
