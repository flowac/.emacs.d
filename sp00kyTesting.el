(defvar sp00ky/last-highlighted-word nil
  "This variable keeps track of the last highlighted word. This is used to toggle word
hilighting")

(defun sp00ky/unhighlight-word-at-point (&optional target)
  "Unhighlight word at point, or the supplied word"
  (interactive)
  (if (not target)
      (setq target (list (symbol-name (symbol-at-point)))))
  (unhighlight-regexp (regexp-opt target)))

(defun sp00ky/highlight-word-at-point ()
  "Highlight the word under the point."
  (interactive)
  (let* ((target-symbol (symbol-at-point))
	 (target (list (symbol-name target-symbol))))
    (unless (not target))
    (sp00ky/unhighlight-all-in-buffer)
    (if (equal target sp00ky/last-highlighted-word)
	(progn
	  (sp00ky/unhighlight-word-at-point target)
	  (setq sp00ky/last-highlighted-word nil))
      (progn
	(highlight-regexp (regexp-opt target))
	(setq sp00ky/last-highlighted-word target)))))

(global-set-key [f2] 'sp00ky/highlight-word-at-point)
