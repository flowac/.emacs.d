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

(defun sp00kyWork/copy-to-clipboard (start end)
  "Send text from selected region to port 5556. Note, we are
expecting this port to be port forwarded with something like
\"ssh -R 5556:localhost:5556\""
  (interactive "r")
  (if (use-region-p)
      (let ((tmp-file "/tmp/emacs-clipboard"))
        (write-region start end tmp-file)
        (async-shell-command (concat "cat " (shell-quote-argument tmp-file) " | nc localhost 5556"))
        (evics-kill-ring-save))))
(define-key evics-normal-mode-map (kbd "y") 'sp00kyWork/copy-to-clipboard)

(defun sp00ky/cnfp-dbg-parse-pkt ()
  "Take output from pp vis ppi and make it fit parsepkt. To use,
position cursor on the line after the pasted output."
  (interactive)
  ; Selec lines
  (set-mark-command nil)
  (while (not (looking-at-p "^| Pkt_H"))
    (previous-logical-line))
  ; combine packet to one hex string
  (replace-regexp "|.*?| \\([0-9a-z]*\\).*[\\\n|$]" "\\1" nil (point) (mark))
  (beginning-of-line)
  (insert "cnfp-dbg parsepkt ")
  (end-of-line)
  (insert " noshim")
  ; Copy one liner
  (beginning-of-line)
  (set-mark-command nil)
  (end-of-line 1)
  (sp00kyWork/copy-to-clipboard))

(defun sp00ky/split-tracepoint (start end)
  "Tace a tracepoint and split it. We will deliniate based upon the word before :. For example,
CnCoreSvcAction: Create oam_index: \"\"
Would turn into:
CnCoreSvcAction: Create
oam_index: \"\"
"
  (interactive "r")
  (goto-char start)
  (while (re-search-forward
          " [a-zA-Z]+[a-zA-Z0-9_]*:"
         end 
          t)
    (re-search-backward " ")
    (forward-char)
    (newline)))

(defun sp00ky/spartan-to-camel (start end)
  "Remove underscores and capitalize the first letter afterwards within selected region"
  (interactive "r")
  (goto-char start)
  (setq-local delete-active-region nil)
  (while (< (point) end)
    (if (= ?_ (char-after))
        (progn
          (delete-forward-char 1)
          (let ((current-char (char-after)))
            (delete-forward-char 1)
            (insert (capitalize current-char)))))
    (forward-char)))

(defun sp00ky/conf-mode-hook ()
  "Config to run when entering conf mode"
  ;; This was a little confusing to figure out. Anyways, it makes the
  ;; char / work as both the first and second char in a comment
  ;; sequence, else it will just be punctuation.
  (modify-syntax-entry ?/ ". 12"))
(add-hook 'conf-unix-mode-hook 'sp00ky/conf-mode-hook)

(defun sp00ky/log-macro-update (start end)
  "In our code we see lines such as:
     CNCORE_LOG( PACKAGE_NAME, LOG_ERR, NULL, \"Invalid virtual mac pointer\" );
We want to update these lines to look more like:
     HAL_LOG_ERR(\"Invalid virtual mac pointer\");
We will have to account for LOG_INFO and LOG_DEBUG accordingly."
  (interactive "r")
  (goto-char start)
  (defvar replacement-string "")
  (while (re-search-forward "CNCORE_LOG[ ]*(" end t)
    (beginning-of-line)
    (cond ((re-search-forward "LOG_INFO" (line-end-position) t)
           (setq replacement-string "HAL_LOG_INFO(\""))
          ((re-search-forward "LOG_ERR" (line-end-position) t)
           (setq replacement-string "HAL_LOG_ERR(\""))
          ((re-search-forward "LOG_DEBUG" (line-end-position) t)
           (setq replacement-string "HAL_LOG_DEBUG(\"")))
    (beginning-of-line)
    (replace-regexp
     "cncore_log.*?\"\\(error:\\|\\)"
     replacement-string
     nil (line-beginning-position) (line-end-position))
    (sp00ky/indent-region-or-paragraph)))
