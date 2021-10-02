;EVIL mode
(require 'evil)
(setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))
(evil-mode 1)
(setq evil-want-integration nil)
(require 'evil)
(when (require 'evil-collection nil t)
  (evil-collection-init))

;(define-key evil-normal-state-map (kbd "M-t") 'ggtags-find-tag-dwim)
;(define-key evil-normal-state-map (kbd "M-R") 'ggtags-find-definition)
;(define-key evil-normal-state-map (kbd "M-r") 'ggtags-find-reference)
;(define-key evil-normal-state-map (kbd "M-<") 'ggtags-prev-mark)
;(define-key evil-normal-state-map (kbd "M->") 'ggtags-next-mark)
