(defun my-imenu-rescan ()
  (interactive)
  (imenu--menubar-select imenu--rescan-item))

(defun sp00ky-insert-org-ctag ()
  "Insert C code block in org mode"
  (interactive)
  (save-excursion (progn
                    (insert "#+BEGIN_SRC c\n#+END_SRC"))))

(defun sp00ky/kill-non-existent-buffers ()
  "Kill all buffers that do not exist anymore."
  (interactive)
  (dolist (buf (buffer-list) value)
    (let ((x (buffer-file-name buf)))
      (if x (if (eq 'nil (file-exists-p x))
                (kill-buffer buf))))))

; https://emacs.stackexchange.com/questions/19861/how-to-unhighlight-symbol-highlighted-with-highlight-symbol-at-point
(defun sp00ky-unhighlight-all-in-buffer ()
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

(defvar sp00ky-hs-hide nil
  "Current state of hideshow for toggling all.")
(with-eval-after-load 'evil-common
  (evil-define-command sp00ky-evil-toggle-folds ()
    "Open or close all folds."
    (setq sp00ky-hs-hide (not sp00ky-hs-hide))
    (if sp00ky-hs-hide
        (hs-hide-all)
      (hs-show-all))))

;(load "~/.emacs.d/init_dir/sp00ky_functions_testing.el")
;;; taken from:
;;; https://gist.github.com/mads-hartmann/3402786
(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_) 
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))


(define-generic-mode 'ciena-conf-generic-mode
  (list "//" "#")
  (list
   "true"
   "false"
   )
  '(("\\lcVersion_\\(Major\\|Minor\\|Patch\\)\\|boardData\\|platform\\|ucoreAttrs\\|xcvrs\\|internalPorts\\|hwPorts\\|inventory\\|internalPortUcoreAttrs" . font-lock-function-name-face))
;;;  (list
;;;   "portId"
;;;   "macNum"
;;;   "macPort"
;;;   "phyPort"
;;;   "phyNum"
;;;   "fapPort"
;;;   "zlPP"
;;;   "zpPP"
;;;   "ppPort"
;;;   "speedCap"
;;;   "macType"
;;;   "xcvrClass"
;;;   "npuType"
;;;   "mdioBusNum"
;;;   "mdioAddress"
;;;   "ifaceName"
;;;   "isAnegSupported"
;;;   "core"
;;;   "srd"
;;;   "phy"
;;;   "interfaceType"
;;;   "txPolarity"
;;;   "rxPolarity"
;;;   "isPluggable"
;;;   "intPortId"
;;;   "intPortType"
;;;   "slot"
;;;   "assyValue"
;;;   "boardRevNum"
;;;   "maxInternalPorts"
;;;   "maxNumEttps"
;;;   "numPP"
;;;   "numCores"
;;;   "maxMacPortSize"
;;;   )
  nil
  nil
  "Mode for ciena conf files")

(defun flyspell-correct-previous (&optional words)
  "Correct word before point, reach distant words.

WORDS words at maximum are traversed backward until misspelled
word is found.  If it's not found, give up.  If argument WORDS is
not specified, traverse 12 words by default.

Return T if misspelled word is found and NIL otherwise.  Never
move point."
  (interactive "P")
  (let* ((Δ (- (point-max) (point)))
         (counter (string-to-number (or words "12")))
         (result
          (catch 'result
            (while (>= counter 0)
              (when (cl-some #'flyspell-overlay-p
                             (overlays-at (point)))
                (flyspell-correct-word-before-point)
                (throw 'result t))
              (backward-word 1)
              (setq counter (1- counter))
              nil))))
    (goto-char (- (point-max) Δ))
    result))

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
