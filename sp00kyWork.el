;; Config specific to work.
(defun sp00kyWork/copy-to-clipboard ()
  "Send text from selected region to port 5556. Note, we are expecting this port to be port forwarded
with something like \"ssh -R 5556:localhost:5556\""
  (interactive)
  (if (use-region-p)
      (let ((regionp (buffer-substring-no-properties (mark) (point))))
        (shell-command (concat "echo -n " (shell-quote-argument regionp) "| nc localhost 5556"))
        (call-interactively 'evil-yank))))

(define-key evil-visual-state-map (kbd "y") 'sp00kyWork/copy-to-clipboard)
