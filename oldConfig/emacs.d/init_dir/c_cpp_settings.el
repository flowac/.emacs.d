;; tab settings
;(add-hook 'c++-mode-hook 'irony-mode)
;(add-hook 'c-mode-hook 'irony-mode)
;(add-hook 'objc-mode-hook 'irony-mode)
;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;(setq ccls-executable "/usr/bin/ccls")

(add-to-list 'auto-mode-alist '("\\.append\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.cfs\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.cfi\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.hct\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.proto\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.compile\\'" . (lambda ()
                                                   (compilation-mode)
                                                   (auto-revert-mode))))

(with-eval-after-load 'company-gtags
  (add-to-list 'company-gtags-modes 'c-mode))

(c-set-offset 'case-label '+)
(setq c-default-style "k&r")
;(setq c-default-style "linux")
(setq-default tab-width 4)
(setq-default c-basic-offset 3)
(setq-default c-indent-level 3)
(setq-default c-brace-imaginary-offset 0)
(setq-default c-brace-offset -3)
(setq-default c-argdecl-indent 3)
(setq-default c-label-offset -3)
(setq-default c-continued-statement-offset 3)
(setq-default indent-tabs-mode nil)
(setq-default global-semantic-decoration-mode 1) ;highlight header files that cant be found
(setq-default fill-column 80)

;(add-hook 'c-mode-common-hook
;          (lambda ()
;            (when (derived-mode-p 'c-mode 'c++-mode)
;              (ggtags-mode 1)
;              (idle-highlight-mode 1))))

(add-hook 'c-mode-hook
          (lambda ()
            (setq comment-start "//"
                  comment-end "")
            (setq tab-width c-indent-level)
            (setq evil-shift-width c-indent-level)))

; from enberg on #emacs
(setq compilation-finish-function
  (lambda (buf str)
    (if (null (string-match ".*exited abnormally.*" str))
        ;;no errors, make the compilation window go away in a few seconds
        (progn
          (run-at-time
           "2 sec" nil 'delete-windows-on
           (get-buffer-create "*compilation*"))
          (message "No Compilation Errors!")))))
