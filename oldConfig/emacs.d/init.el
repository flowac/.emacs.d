(setq gc-cons-threshold (* 2 1024 1024))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
;; (require 'diminish)
(require 'bind-key)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sp00ky t)
(defvar sp00ky/at-work t)

; Migrate to use package.el
(load "~/.emacs.d/init_dir/use_package.el")
(load "~/.emacs.d/init_dir/evil.el")
(load "~/.emacs.d/init_dir/c_cpp_settings.el")
(load "~/.emacs.d/init_dir/ibuffer.el")
(load "~/.emacs.d/init_dir/completion.el")
(load "~/.emacs.d/init_dir/sp00ky_functions.el")
(load "~/.emacs.d/init_dir/keybindings.el")
(load "~/.emacs.d/init_dir/python.el")
(load "~/.emacs.d/init_dir/memory_usage.el")
;; (load "~/.emacs.d/init_dir/flymake-cursor.el")
(load "~/.emacs.d/init_dir/info+.el")
(load "~/.emacs.d/init_dir/help-fns+.el")
(load "~/.emacs.d/init_dir/useful_settings.el")

(if (not sp00ky/at-work)
    (progn
      (load "~/.emacs.d/init_dir/tex.el")
      (load "~/.emacs.d/init_dir/flymake-cursor.el")))

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; evil plugin
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "0e01d78ec977390f023600a356e862e94a85a3b1673099b7468654135633e69d" "31c1aee3d4b62b9f8476359853886ecf6966685c5420f4d6f16daa80fba5e8d0" "f78de13274781fbb6b01afd43327a4535438ebaeec91d93ebdbba1e3fba34d3c" default))
 '(helm-minibuffer-history-key "M-p")
 '(help-at-pt-display-when-idle '(flymake-overlay) nil (help-at-pt))
 '(help-at-pt-timer-delay 0.9)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(julia-mode sudo-edit helm-xref xah-fly-keys go-mode elpher lsp-mode gdscript-mode helm-ag elpy helpful company-shell esup pos-tip rainbow-delimiters raven rust-mode eyebrowse company-gtags helm-rg helm-etags-plus helm-etags-pluss org-autolist pythonic use-package company-c-headers function-args helm helm-ebdb company-irony-c-headers neotree company-irony irony evil-collection pdf-tools flyspell-correct-popup auctex ggtags grandshell-theme alect-themes cyberpunk-theme highlight-indent-guides smooth-scroll smooth-scrolling flycheck sr-speedbar company all-the-icons monokai-theme))
 '(speedbar-show-unknown-files t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ediff
(setq ediff-split-window-function 'split-window-horizontally)

;; reverting buffer
(global-auto-revert-mode t)
(global-set-key [f5] 'revert-all-buffers)
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
        (revert-buffer t t t) )))
  (message "Refreshed open files.") )
                                        ; indentation markers


(setq nxml-sexp-element-flag nil)
