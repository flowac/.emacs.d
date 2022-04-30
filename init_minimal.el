; Usage:
; emacs -q -nw -l ~/.emacs.d/init_minimal.el

;;(add-to-list 'load-path "~/.emacs.d/elpa/highlight-parentheses-20210821.1957")
;;(require 'highlight-parentheses)
;;(setq highlight-parentheses-highlight-adjacent t)
;;(setq highlight-parentheses-background-colors '("steelblue3"))
;;(highlight-parentheses-mode)


;;(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path "/localdata/hmuresan/my_builds/evics")
;; (load "/localdata/hmuresan/my_builds/evics/evics.el")
(load "~/scratch/visual-regexp.el")
(xterm-mouse-mode     1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)

(toggle-debug-on-error)
(require 'evics)
(evics-global-mode t)
(define-key global-map (kbd "<escape>") 'keyboard-escape-quit)
(evics-init-esc)

(setq visual-order-cursor-movement t
      help-window-select    t)

;;; Nice to have init
(add-to-list 'load-path "~/.emacs.d/elpa/highlight-parentheses-20210821.1957")
(require 'highlight-parentheses)
;; (setq highlight-parentheses-highlight-adjacent t) ; Replace show-paren mode
;; (setq highlight-parentheses-background-colors '("steelblue3"))
(electric-pair-mode)
(highlight-parentheses-mode)
;; (setq show-paren-highlight-openparen 'nil)
(setq show-paren-when-point-inside-paren t)
(show-paren-mode)

(defun xah-display-minor-mode-key-priority  ()
  "Print out minor mode's key priority.
URL `http://ergoemacs.org/emacs/minor_mode_key_priority.html'
Version 2017-01-27"
  (interactive)
  (mapc
   (lambda (x) (prin1 (car x)) (terpri))
   minor-mode-map-alist))

;; (global-set-key (kbd "m") (lambda () (interactive)(print (current-local-map))))
;; (global-set-key (kbd "M") (lambda () (interactive)(print (current-minor-mode-maps))))
