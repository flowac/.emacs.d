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

(defun sp00ky-idle-highlight-word-at-point ()
  "Highlight the word under the point."
  (interactive)
  (sp00ky-unhighlight-all-in-buffer)
  (let* ((target-symbol (symbol-at-point))
         (target (symbol-name target-symbol)))
    (idle-highlight-unhighlight)
    (when (and target-symbol
               (not (in-string-p))
               (looking-at-p "\\s_\\|\\sw") ;; Symbol characters
               (not (member target idle-highlight-exceptions)))
      (setq idle-highlight-regexp (concat "\\<" (regexp-quote target) "\\>"))
      (highlight-regexp idle-highlight-regexp 'idle-highlight))))

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
