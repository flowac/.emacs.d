;; See example: evil-redirect-digit-argument
;; also see:    https://stackoverflow.com/questions/29956644/elisp-defmacro-with-lambda
(defun evics-keep-pred-cb ()
  "Callback to supply to set-transient-map"
  (interactive)
  t)

(defmacro evics-key-prefix-argument-overload (map key cb1 cb2)
  "Overload function key with the specified cbs. This is useful 
when we want different behaviour in the lack of prefix args. 
This function will call cb1 if `current-prefix-arg' is defined,
else it will call cb2"
  `(define-key ,map (kbd ,key) 
    '(lambda () (interactive)
       (cond (current-prefix-arg
              (setq this-command ,cb1)
              (call-interactively ,cb1))
             (t
              (setq this-command ,cb2)
              (call-interactively ,cb2))))))

(defun evics-left-char-same-line ()
  "Only go as far left as column 0"
  (interactive)
  (if (not (= 0 (current-column)))
      (left-char)))

(defun evics-goto-normal-mode ()
  "Switch from whatever evics mode to evics normal mode"
  (interactive)
  (evics-insert-mode -1)
  (evics-visual-mode -1)
  (evics-normal-mode t)
  (evics-left-char-same-line)
  (keyboard-quit) ;; For now keep this disabled... seems to clobber the message call below
  (message "-- NORMAL --"))

(defvar evics-region-position nil)
(make-variable-buffer-local 'evics-region-position)

(defvar evics-previous-line-number nil)
(make-variable-buffer-local 'evics-previous-line-number)

;; https://lists.gnu.org/archive/html/help-gnu-emacs/2010-12/msg01183.html
(defun evics-select-line ()
  "Select whole line, by setting the mark at the start of the line"
  (interactive)
  (setq evics-region-position (line-number-at-pos))
  (forward-line 1)
  (move-beginning-of-line nil)
  (set-mark (point))
  (forward-line -1)
  (evics-visual-mode 1))

