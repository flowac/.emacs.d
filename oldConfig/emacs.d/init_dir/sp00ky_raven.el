(defun sp00ky/raven-get-buffer-list ()
  (raven-source
   "Buffer list"
   (mapcar 'buffer-name (buffer-list))
   raven-buffer-actions))

(defun sp00ky/raven-buffer-list ()
  "Preconfigured `raven' interface to replace `execute-external-command'."
  (interactive)
   (raven (list (sp00ky/raven-get-buffer-list))))

(sp00ky/raven-get-buffer-list)
(sp00ky/raven-buffer-list)
