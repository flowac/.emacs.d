;; AUCTeX
; Get support for the latex documents
(require 'tex)
;; RefTeX
(require 'reftex-toc)
(require 'reftex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-PDF-mode t)
(setq TeX-view-program-selection '(((output-dvi has-no-display-manager)
                                    "dvi2tty")
                                   ((output-dvi style-pstricks)
                                    "dvips and gv")
                                   (output-dvi "xdvi")
                                   (output-pdf "emacs")
                                   (output-html "xdg-open")))

(setq-default TeX-master nil)
; Get rid of xpm erro
(unless (image-type-available-p 'xpm)
    (setq LaTeX-enable-toolbar nil))
;syntax for code
(setq font-latex-match-reference-keywords
      '(
        ("code" "{")
        ("par")))

(defun insert-coordinates ()
  "Used to easily insert (x,y) coordinates"
  (interactive)
  (while '(1) (insert 
              "("
              (read-string "Enter X coordinate " nil nil nil)
              ","
              (read-string "Enter Y coordinate " nil nil nil)
              ") ")))


;(auto-fill-mode t)
(add-hook 'LaTeX-mode-hook (lambda()
                             (flyspell-mode t)
                             (nlinum-relative-mode)
                             ))
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    (setq reftex-plug-into-AUCTeX t)
(setq reftex-ref-macro-prompt nil) ; get rid of reference format forcross ref
;(add-to-list 'reftex-label-alist '("\meow{}" ?e "eq:" "\meow{%s}" 1 ("meo") nil))
(setq reftex-insert-label-flags '("s" t))

;(require 'flyspell-correct-popup)

;(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
;(define-key popup-menu-keymap (kbd "S-TAB") 'popup-previous)


