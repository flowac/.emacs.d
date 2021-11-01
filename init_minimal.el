
(setq user-emacs-directory "~/.emacs.d/")
(load "~/.emacs.d/evics/evics.el")
(xterm-mouse-mode     1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)

(toggle-debug-on-error)
(global-evics-normal-mode t)
(define-key global-map (kbd "<escape>") 'keyboard-escape-quit)
(evics-init-esc)

