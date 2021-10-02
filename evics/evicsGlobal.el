  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;     Global evics Mode          ;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar evics-normal-mode-map (make-sparse-keymap) "Evics normal mode keymap")

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;         Keymap            ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key winner-mode-map (kbd "C-a h") 'windmove-left)
(define-key winner-mode-map (kbd "C-a l") 'windmove-right)
(define-key winner-mode-map (kbd "C-a j") 'windmove-down)
(define-key winner-mode-map (kbd "C-a k") 'windmove-up)
