;; Config specific to work.

;; (setq display-buffer-alist 'nil)
;; Might want to make this better: https://emacs.stackexchange.com/questions/12747/how-to-conditionally-reuse-the-current-window-to-display-a-buffer
;; 
;; Control where the *Messages* buffer opens
;; (add-to-list 'display-buffer-alist
;;              '("\\*Messages\\*" . ((display-buffer-reuse-window
;;                                     display-buffer-pop-up-window)
;;                                    . ((inhibit-same-window . t)))))

(add-to-list 'display-buffer-alist
             '("\\*Async Shell Command\\*" . (display-buffer-no-window . nil)))

(defun sp00kyWork/copy-to-clipboard ()
  "Send text from selected region to port 5556. Note, we are expecting this port to be port forwarded
with something like \"ssh -R 5556:localhost:5556\""
  (interactive)
  (if (use-region-p)
      (let ((regionp (buffer-substring-no-properties (mark) (point))))
        (async-shell-command (concat "echo -n " (shell-quote-argument regionp) "| nc localhost 5556"))
        (call-interactively 'evil-yank))))

(define-key evil-visual-state-map (kbd "y") 'sp00kyWork/copy-to-clipboard)

