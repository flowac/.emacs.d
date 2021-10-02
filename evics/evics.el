(load-file "evics/evicsFunctions.el")
(load-file "evics/evicsNormalMode.el")
(load-file "evics/evicsInsertMode.el")
(load-file "evics/evicsVisualMode.el")

;;; Look into help-mode-map

(require 'winner)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;         Keymap            ;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key winner-mode-map (kbd "C-a h") 'windmove-left)
(define-key winner-mode-map (kbd "C-a l") 'windmove-right)
(define-key winner-mode-map (kbd "C-a j") 'windmove-down)
(define-key winner-mode-map (kbd "C-a k") 'windmove-up)
(winner-mode t)

(define-key emacs-lisp-mode-map (kbd "M-t") 'xref-find-definitions)
(define-key emacs-lisp-mode-map (kbd "M-<") 'xref-pop-marker-stack)

(define-global-minor-mode global-evics-normal-mode evics-normal-mode evics-normal-mode)
;; To test use:
;; emacs -nw -q -l init_test.el  --file scratch/tmp.txt


