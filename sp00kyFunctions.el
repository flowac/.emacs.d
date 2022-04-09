;; Home to various sp00ky functions
(defvar sp00ky/number-to-hex-timer nil
  "Timer for `sp00ky/at-point-to-hex' to reschedule itself, or nil.")
(require 'eldoc)
(defun sp00ky/at-point-to-hex (&optional quiet)
  "Convert the number at point to hex"
  (interactive)
  (if (numberp (thing-at-point 'number))
      (eldoc-message (format "0x%X" (thing-at-point 'number)))
    (if (not quiet)
        (message "Expecting number at point"))))

(require 'desktop)
(defun sp00ky/remove-unused-desktop-lock ()
  "If emacs crashes or exits abruptly then it does not remove the 
desktop lock. This causes subsequent emacs sessions to not load the
desktop file. Using desktop-load-locked-desktop doesn't address the
issue since this will cause us to load the desktop file if we have two
emacs instances running."
  (let ((os-list '(gnu/linux)))
    (if (member system-type os-list)
        (mapcar
         (lambda (dir)
           (if (file-exists-p (concat dir desktop-base-lock-name))
               ;; Seems like in elisp this is the only way to get file contents...
               (with-temp-buffer
                 (insert-file-contents (concat dir desktop-base-lock-name))
                 (let ((lock-file (concat dir desktop-base-lock-name))
                       (comm-file (concat "/proc/" (buffer-string) "/comm")))
                   (message "Found lock file: %s" lock-file)
                   (if (file-exists-p comm-file)
                       (with-temp-buffer 
                         (insert-file-contents comm-file)
                         (if (string-match "emacs" (buffer-string))
                             (message "Active emacs session has lock file")
                           (progn
                             (message "Removing desktop lockfile since lockfile pid is not emacs")
                             (delete-file lock-file))))
                     (progn
                       (message "Removing desktop lockfile since lockfile pid is not emacs")
                       (delete-file lock-file)))))))
         desktop-path)
      (message "Cannot handle os: %s" system-type))))

(defun sp00ky-update-env (fn)
  (let ((str 
         (with-temp-buffer
           (insert-file-contents fn)
           (buffer-string))) lst)
    (setq lst (split-string str "\000"))
    (while lst
      (setq cur (car lst))
      (when (string-match "^\\(.*?\\)=\\(.*\\)" cur)
        (setq var (match-string 1 cur))
        (setq value (match-string 2 cur))
        (setenv var value))
      (setq lst (cdr lst)))))

(defun sp00ky/insert-org-ctag ()
  "Insert C code block in org mode"
  (interactive)
  (save-excursion (progn
                    (insert "#+BEGIN_SRC c\n#+END_SRC"))))

(defun sp00ky/ignore ()
  "Do nothing. Need to define this to specific keys that will have no
action happen when pressed."
  (interactive)
  'nil)

; https://emacs.stackexchange.com/questions/19861/how-to-unhighlight-symbol-highlighted-with-highlight-symbol-at-point
(defun sp00ky/unhighlight-all-in-buffer ()
  "Remove all highlights made by `hi-lock' from the current buffer.
The same result can also be be achieved by \\[universal-argument] \\[unhighlight-regexp]."
  (interactive)
  (unhighlight-regexp t))

(defvar-local sp00ky/last-highlighted-word nil
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

;;=========================================================================
;; Evil code fragment to remove in the future.
(unless sp00ky/use-evics
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
      (call-interactively 'evil-paste-after))))
;;=========================================================================

(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_) 
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))

(defun xah-syntax-color-hex ()
  "Syntax color text of the form 「#ff1100」 and 「#abc」 in current buffer.
URL `http://ergoemacs.org/emacs/emacs_CSS_colors.html'
Version 2017-03-12"
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[[:xdigit:]]\\{3\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background
                      (let* (
                             (ms (match-string-no-properties 0))
                             (r (substring ms 1 2))
                             (g (substring ms 2 3))
                             (b (substring ms 3 4)))
                        (concat "#" r r g g b b))))))
     ("#[[:xdigit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-flush))

(defun xah-display-minor-mode-key-priority  ()
  "Print out minor mode's key priority.
URL `http://ergoemacs.org/emacs/minor_mode_key_priority.html'
Version 2017-01-27"
  (interactive)
  (mapc
   (lambda (x) (prin1 (car x)) (terpri))
   minor-mode-map-alist))

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
