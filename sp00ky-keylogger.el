(defun keymetrics-post-command-hook ()
  "DOCSTRING"
  ;; (print (format "%s - %s" (this-command-keys) this-command))
  )
(add-hook 'post-command-hook 'keymetrics-post-command-hook)
