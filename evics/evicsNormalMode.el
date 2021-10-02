  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;         Normal Mode            ;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar evics-normal-mode-map (make-sparse-keymap) "Evics normal mode keymap")

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;         Keymap            ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evics-normal-mode-map (kbd "`") 'ignore)
(define-key evics-normal-mode-map (kbd "~") 'ignore)
(define-key evics-normal-mode-map (kbd "1") 'digit-argument)
(define-key evics-normal-mode-map (kbd "!") 'ignore)
(define-key evics-normal-mode-map (kbd "2") 'digit-argument)
(define-key evics-normal-mode-map (kbd "@") 'ignore)
(define-key evics-normal-mode-map (kbd "3") 'digit-argument)
(define-key evics-normal-mode-map (kbd "#") 'ignore)
(define-key evics-normal-mode-map (kbd "4") 'digit-argument)
(define-key evics-normal-mode-map (kbd "$") 'move-end-of-line)
(define-key evics-normal-mode-map (kbd "5") 'digit-argument)
(define-key evics-normal-mode-map (kbd "%") 'ignore)
(define-key evics-normal-mode-map (kbd "6") 'digit-argument)
(define-key evics-normal-mode-map (kbd "^") 'ignore)
(define-key evics-normal-mode-map (kbd "7") 'digit-argument)
(define-key evics-normal-mode-map (kbd "&") 'ignore)
(define-key evics-normal-mode-map (kbd "8") 'digit-argument)
(define-key evics-normal-mode-map (kbd "*") 'ignore)
(define-key evics-normal-mode-map (kbd "9") 'digit-argument)
(define-key evics-normal-mode-map (kbd "(") 'ignore)
(define-key evics-normal-mode-map (kbd ")") 'ignore)
(define-key evics-normal-mode-map (kbd "-") 'ignore)
(define-key evics-normal-mode-map (kbd "_") 'ignore)
(define-key evics-normal-mode-map (kbd "=") 'ignore)
(define-key evics-normal-mode-map (kbd "+") 'ignore)

(define-key evics-normal-mode-map (kbd "<tab>") 'ignore)
(define-key evics-normal-mode-map (kbd "q") 'ignore)
(define-key evics-normal-mode-map (kbd "Q") 'ignore)
(define-key evics-normal-mode-map (kbd "w") 'ignore)
(define-key evics-normal-mode-map (kbd "W") 'ignore)
(define-key evics-normal-mode-map (kbd "e") 'forward-word-strictly)
(define-key evics-normal-mode-map (kbd "E") 'forward-word)
(define-key evics-normal-mode-map (kbd "r") 'ignore)
(define-key evics-normal-mode-map (kbd "R") 'ignore)
(define-key evics-normal-mode-map (kbd "t") 'ignore)
(define-key evics-normal-mode-map (kbd "T") 'ignore)
(define-key evics-normal-mode-map (kbd "y") 'ignore)
(define-key evics-normal-mode-map (kbd "Y") 'ignore)
(define-key evics-normal-mode-map (kbd "u") 'undo)
(define-key evics-normal-mode-map (kbd "U") 'ignore)
(define-key evics-normal-mode-map (kbd "i")
  '(lambda () (interactive)
     (evics-normal-mode -1)
     (evics-insert-mode t)))
(define-key evics-normal-mode-map (kbd "I") 'ignore)
(define-key evics-normal-mode-map (kbd "o") 'ignore)
(define-key evics-normal-mode-map (kbd "O") 'ignore)
(define-key evics-normal-mode-map (kbd "p") 'ignore)
(define-key evics-normal-mode-map (kbd "P") 'ignore)
(define-key evics-normal-mode-map (kbd "[") 'ignore)
(define-key evics-normal-mode-map (kbd "{") 'ignore)
(define-key evics-normal-mode-map (kbd "]") 'ignore)
(define-key evics-normal-mode-map (kbd "}") 'ignore)
(define-key evics-normal-mode-map (kbd "\\") 'ignore)
(define-key evics-normal-mode-map (kbd "|") 'ignore)

(define-key evics-normal-mode-map (kbd "a") 'ignore)
(define-key evics-normal-mode-map (kbd "A") 'ignore)
(define-key evics-normal-mode-map (kbd "s") 'ignore)
(define-key evics-normal-mode-map (kbd "S") 'ignore)
(define-key evics-normal-mode-map (kbd "d") 'ignore)
(define-key evics-normal-mode-map (kbd "D") 'ignore)
(define-key evics-normal-mode-map (kbd "f") 'ignore)
(define-key evics-normal-mode-map (kbd "F") 'ignore)
(define-key evics-normal-mode-map (kbd "h") 'left-char)
(define-key evics-normal-mode-map (kbd "H") 'backward-list)
(define-key evics-normal-mode-map (kbd "j") 'next-line)
(define-key evics-normal-mode-map (kbd "J") 'down-list)
(define-key evics-normal-mode-map (kbd "k") 'previous-line)
(define-key evics-normal-mode-map (kbd "K") 'backward-up-list)
(define-key evics-normal-mode-map (kbd "l") 'right-char)
(define-key evics-normal-mode-map (kbd "L") 'forward-list)
(define-key evics-normal-mode-map (kbd ";") 'ignore)
;; (define-key evics-normal-mode-map (kbd ":") 'ignore)
(define-key evics-normal-mode-map (kbd "'") 'ignore)
(define-key evics-normal-mode-map (kbd "\"") 'ignore)

(define-key evics-normal-mode-map (kbd "z") 'ignore)
(define-key evics-normal-mode-map (kbd "Z") 'ignore)
(define-key evics-normal-mode-map (kbd "x") 'delete-forward-char)
(define-key evics-normal-mode-map (kbd "X") 'ignore)
(define-key evics-normal-mode-map (kbd "c") 'ignore)
(define-key evics-normal-mode-map (kbd "C") 'ignore)
(define-key evics-normal-mode-map (kbd "v") 'set-mark-command)
(define-key evics-normal-mode-map (kbd "V") 'evics-select-line)
(define-key evics-normal-mode-map (kbd "b") 'backward-word)
(define-key evics-normal-mode-map (kbd "B") 'backward-word)
(define-key evics-normal-mode-map (kbd "n") 'isearch-repeat-forward)
(define-key evics-normal-mode-map (kbd "N") 'isearch-repeat-backward)
(define-key evics-normal-mode-map (kbd "m") 'ignore)
(define-key evics-normal-mode-map (kbd "M") 'ignore)
(define-key evics-normal-mode-map (kbd ",") 'ignore)
(define-key evics-normal-mode-map (kbd "<") 'ignore)
(define-key evics-normal-mode-map (kbd ".") 'ignore)
(define-key evics-normal-mode-map (kbd ">") 'ignore)
(define-key evics-normal-mode-map (kbd "/") 'isearch-forward)
(define-key evics-normal-mode-map (kbd "?") 'isearch-backward)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;             commands              ;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evics-normal-mode-map (kbd ": e") 'find-file)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;      Non alpha-numberic pressed       ;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evics-normal-mode-map (kbd "DEL") 'left-char)
(define-key evics-normal-mode-map (kbd "RET") 'isearch-exit)
;; (define-key evics-normal-mode-map (kbd "ESC") 'keyboard-escape-quit)
;; (define-key evics-normal-mode-map (kbd "<escape>")      'keyboard-escape-quit)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;      CTRL pressed         ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evics-normal-mode-map (kbd "C-f") 'scroll-up-command)
(define-key evics-normal-mode-map (kbd "C-b") 'scroll-down-command)
(define-key evics-normal-mode-map (kbd "C-j") 'delete-indentation)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;      Special Keys         ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(evics-key-prefix-argument-overload
 evics-normal-mode-map "0" 'digit-argument 'move-beginning-of-line)

(evics-key-prefix-argument-overload
 evics-normal-mode-map "G" 'goto-line 'end-of-buffer)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;      Delayed Keys         ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evics-normal-mode-map (kbd "g g") 'beginning-of-buffer)
;; (define-key evics-normal-mode-map (kbd "G G") 'end-of-buffer)

(define-minor-mode evics-normal-mode
  "Toggle evics normal mode."
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " <N>"
  ;; The minor mode bindings.
  :keymap evics-normal-mode-map
  (setq cursor-type 'box))
