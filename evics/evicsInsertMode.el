(defvar evics-insert-mode-map (make-sparse-keymap) "Evics insert mode keymap")

(defun evics-goto-normal-mode ()
  "Switch from whatever evics mode to evics normal mode"
  (interactive)
  (evics-insert-mode -1)
  (evics-normal-mode t)
  ;; (keyboard-quit) ;; For now keep this disabled... seems to clobber the message call below
  (message "-- NORMAL --"))

(define-key evics-insert-mode-map (kbd "M-c") 'evics-goto-normal-mode)

(define-key evics-insert-mode-map (kbd "<escape>") 'evics-goto-normal-mode)


(define-minor-mode evics-insert-mode
  "Toggle evics normal mode."
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " <I>"
  ;; The minor mode bindings.
  :keymap evics-insert-mode-map
  :group 'evics-insert
  (setq cursor-type 'bar))
