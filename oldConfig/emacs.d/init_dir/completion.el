;; ctags + srspeedbar
;(setq tags-table-list '('default-directory))
;(setq tags-file-name 'default-directory);

; auto completion with company
(company-mode 1)
;'(global-company-mode '(not anaconda-mode))
;(global-company-mode '(not jedi-mode))
(add-hook 'after-init-hook 'global-company-mode ) ;; use in all buffers
;; (add-to-list 'company-backends 'company-gtags 'company-lsp 'company-anaconda)
;; (add-to-list 'company-backends '(company-shell company-dabbrev))
;; (add-to-list 'company-shell-modes 'shell-script-mode)
(setq company-dabbrev-downcase 'nil)
;(add-to-list 'company-c-headers-path-system "/usr/include/")
