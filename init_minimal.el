
(setq user-emacs-directory "~/.emacs.d/")
(load "~/.emacs.d/evics/evics.el")
(xterm-mouse-mode     1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)

(toggle-debug-on-error)
(evics-global-mode t)
(define-key global-map (kbd "<escape>") 'keyboard-escape-quit)
(evics-init-esc)

(setq visual-order-cursor-movement t
      help-window-select    t)

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
