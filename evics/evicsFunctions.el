;; See example: evil-redirect-digit-argument
;; also see:    https://stackoverflow.com/questions/29956644/elisp-defmacro-with-lambda
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

;; https://lists.gnu.org/archive/html/help-gnu-emacs/2010-12/msg01183.html
(defun evics-select-line ()
  "Select whole line, by setting the mark at the start of the line"
    (interactive)
    (end-of-line) ; move to end of line
    (set-mark (line-beginning-position)))
