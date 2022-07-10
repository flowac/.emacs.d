;;; bcf-index-mode.el --- major mode for index files for bible commentary forever

(defvar bcf-font-lock-keywords
  `(
    ("\\(John\\|Matthew\\|Mark\\|Luke\\) [0-9]+:[0-9]+:")
    (,(regexp-opt '("Keyword:" "Reference:")))
    ))

(defvar bcf-imenu-generic-expression
  (list '("" "Keyword:\s\\(.*\\)" 1))
  "Bcf related imenu categories.")


(define-derived-mode bcf-index-mode text-mode "bcf-index"
  "Mode to edit bcf index files."
  (setq
   ;; font-lock-defaults `((,bcf-font-lock-keywords))
   imenu-generic-expression bcf-imenu-generic-expression))

(provide 'bcf-index)
