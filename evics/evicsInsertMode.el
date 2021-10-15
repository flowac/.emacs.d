(defvar evics-insert-mode-map (make-sparse-keymap) "Evics insert mode keymap")

(define-key evics-insert-mode-map (kbd "M-c")
  '(lambda () (interactive)
     (evics-insert-mode -1)
     (evics-normal-mode t)
     (keyboard-quit)))

(define-key evics-insert-mode-map (kbd "ESC")
  '(lambda () (interactive)
     (evics-insert-mode -1)
     (evics-normal-mode t)
     (keyboard-quit)))


(define-minor-mode evics-insert-mode
  "Toggle evics normal mode."
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " <I>"
  ;; The minor mode bindings.
  :keymap evics-insert-mode-map
  (setq cursor-type 'bar))
