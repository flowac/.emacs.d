;; Home to various sp00ky functions
(defun sp00ky/insert-org-ctag ()
  "Insert C code block in org mode"
  (interactive)
  (save-excursion (progn
                    (insert "#+BEGIN_SRC c\n#+END_SRC"))))

; https://emacs.stackexchange.com/questions/19861/how-to-unhighlight-symbol-highlighted-with-highlight-symbol-at-point
(defun sp00ky/unhighlight-all-in-buffer ()
  "Remove all highlights made by `hi-lock' from the current buffer.
The same result can also be be achieved by \\[universal-argument] \\[unhighlight-regexp]."
  (interactive)
  (unhighlight-regexp t))

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

(defun sp00ky/evil-cut-to-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-yank)
    (call-interactively 'evil-delete-char)))

(defun sp00ky/evil-delete-char ()
  (interactive)
  (let ((evil-this-register ?_))
    (call-interactively 'evil-delete-char)))
(define-key evil-visual-state-map "x" 'sp00ky/evil-cut-to-0)
(define-key evil-normal-state-map "x" 'sp00ky/evil-delete-char)

(defun sp00ky/evil-paste-after-from-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-paste-after)))

(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_) 
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;                 MISC KEYBINDINGS               ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(defun sp00ky/idle-highlight-word-at-point ()
;;  "Highlight the word under the point."
;;  (interactive)
;;  (sp00ky/unhighlight-all-in-buffer)
;;  (let* ((target-symbol (symbol-at-point))
;;         (target (symbol-name target-symbol)))
;;    (idle-highlight-unhighlight)
;;    (when (and target-symbol
;;               (not (in-string-p))
;;               (looking-at-p "\\s_\\|\\sw") ;; Symbol characters
;;               (not (member target idle-highlight-exceptions)))
;;      (setq idle-highlight-regexp (concat "\\<" (regexp-quote target) "\\>"))
;;      (highlight-regexp idle-highlight-regexp 'idle-highlight))))
