(defun helm-man-woman (arg)
  "Preconfigured `helm' for Man and Woman pages.
With a prefix arg reinitialize the cache."
  (interactive "P")
  (when arg (setq helm-man--pages nil))
  (helm :sources 'helm-source-man-pages
        :buffer "*helm man woman*"))

(defun sp00ky/kill-non-existent-buffers ()
  "Kill all buffers that do not exist anymore."
  (interactive)
  (dolist (buf (buffer-list) value)
    (let ((x (buffer-file-name buf)))
      (if x (if (eq 'nil (file-exists-p x))
                (kill-buffer buf))))))
