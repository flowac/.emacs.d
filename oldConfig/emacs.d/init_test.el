;; (setq user-emacs-directory "~/.emacs.d/emacs_test.d")
;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;; (package-initialize)

;; (unless (package-installed-p 'use-package)
  ;; (package-refresh-contents)
  ;; (package-install 'use-package))

;; (package-refresh-contents)
;; (require 'use-package)

(load-file "evics/evics.el")
(global-evics-normal-mode t)
(add-hook 'minibuffer-setup-hook (lambda () (evics-normal-mode -1)))

