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
        (call-interactively 'evil-yank))))
;; Old method
;(defun sp00kyWork/copy-to-clipboard ()
;  "Send text from selected region to port 5556. Note, we are
;expecting this port to be port forwarded with something like
;\"ssh -R 5556:localhost:5556\""
;  (interactive)
;  (if (use-region-p)
;      (let ((regionp (buffer-substring-no-properties (mark) (point))))
;        (async-shell-command (concat "echo -n " (shell-quote-argument regionp) "| nc localhost 5556"))
;        (call-interactively 'evil-yank))))

(define-key evil-visual-state-map (kbd "y") 'sp00kyWork/copy-to-clipboard)

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
