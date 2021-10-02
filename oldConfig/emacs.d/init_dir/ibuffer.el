;; ibuffers
(setq ibuffer-expert t) ;; remove prompt when closing buffer
(setq ibuffer-saved-filter-groups '(("default"
                                     ("elisp" (mode . emacs-lisp-mode))
                                     ("pdf"  (or
                                              (mode . pdf-view-mode)
                                              (mode . pdf-outline-buffer-mode)))
                                     ("eww" (mode . eww-mode))
                                     ("tex" (mode . latex-mode))
                                     ("c" (mode . c-mode ))
                                     ("python" (mode . python-mode))
                                     ("asm" (mode . asm-mode))
                                     )))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))
