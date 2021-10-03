(deftheme sp00ky
  "sp00ky dark theme")

(let (
      ;; parameters for color faces
      (class '((class color) (min-colors 255)))
      (sp00ky-green          "#155b05")
      (sp00ky-light-green    "#00ff00")
      (sp00ky-background     "#111111")
      (sp00ky-alt-background "#1f1f1f")
      (sp00ky-white          "#cccccc")
      (sp00ky-grey           "#656765")
      (sp00ky-yellow         "#e9ff00")
      (sp00ky-red            "#770202")
      (sp00ky-orange         "#ff8c00")
      (sp00ky-majenta        "#99008C")
      (sp00ky-purple         "#4C00CC")
      (sp00ky-light-purple   "#AB87FF")
      (sp00ky-cyan           "#00BFF2")
      (sp00ky-light-blue     "#83A5E9")
      (sp00ky-blue           "#00007A")
      (sp00ky-brown          "#4C261A")
      (sp00ky-pink           "#cc0099")
      )

  (custom-theme-set-faces
   'sp00ky
   `(default ((t (:foreground ,sp00ky-white :background ,sp00ky-background))))

   ;; mode-line
   `(mode-line ((t (:foreground ,sp00ky-white :background ,sp00ky-green :weight bold))))
   `(mode-line-inactive ((t (:foreground ,sp00ky-white :background ,sp00ky-red :weight bold :box nil ))))
   `(mode-line-buffer-id ((t (:foreground ,sp00ky-yellow))))
   `(mode-line-buffer-id ((t (:foreground ,sp00ky-yellow))))

   ;;mouse colour
   `(mouse ((t (:foreground ,sp00ky-red :background ,sp00ky-white :weight bold))))

   ;; strings
   `(font-lock-string-face ((t (:foreground ,sp00ky-orange))))
   `(font-lock-preprocessor-face ((t (:foreground ,sp00ky-pink))))
   `(font-lock-type-face ((t (:foreground ,sp00ky-cyan))))
   `(font-lock-keyword-face ((t (:foreground ,sp00ky-pink))))
   `(font-lock-function-name-face ((t (:foreground ,sp00ky-light-green))))
   `(font-lock-variable-name-face ((t (:foreground ,sp00ky-white))))
   `(font-lock-constant-face ((t (:foreground ,sp00ky-light-purple))))
   `(which-func ((t (:foreground ,sp00ky-light-green))))

   ;; comments
   `(font-lock-comment-face ((t (:foreground ,sp00ky-grey))))
   
   ;; highlighting current line
   `(highlight ((t (:background ,sp00ky-alt-background))))


   ;; highlighting current line
   `(ediff-odd-diff-A ((t (:background ,sp00ky-red))))
   `(ediff-even-diff-A ((t (:background ,sp00ky-red))))
   `(ediff-odd-diff-B ((t (:background ,sp00ky-green))))
   `(ediff-even-diff-B ((t (:background ,sp00ky-green))))
   `(ediff-current-diff-B ((t (:background ,sp00ky-light-green))))
   `(ediff-fine-diff-B ((t (:background ,sp00ky-blue))))

;;; PACKAGES

   ;; auctex
   `(font-latex-sectioning-5-face ((,class (:foreground ,sp00ky-yellow))))

   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face
     ((,class (:foreground ,sp00ky-yellow))))
   `(rainbow-delimiters-depth-2-face
     ((,class (:foreground ,sp00ky-white))))
   `(rainbow-delimiters-depth-3-face
     ((,class (:foreground ,sp00ky-cyan))))
   `(rainbow-delimiters-depth-4-face
     ((,class (:foreground ,sp00ky-green))))
   `(rainbow-delimiters-depth-5-face
     ((,class (:foreground ,sp00ky-pink))))
   `(rainbow-delimiters-depth-6-face
     ((,class (:foreground ,sp00ky-orange))))
   `(rainbow-delimiters-depth-7-face
     ((,class (:foreground ,sp00ky-purple))))
   `(rainbow-delimiters-depth-8-face
     ((,class (:foreground ,sp00ky-brown))))
   `(rainbow-delimiters-depth-9-face
     ((,class (:foreground ,sp00ky-majenta))))
   `(rainbow-delimiters-unmatched-face
     ((,class (:foreground ,sp00ky-red))))


   ;; neotree

   `(neo-file-link-face
     ((,class (:foreground ,sp00ky-white))))


;; org-mode
   `(org-level-2 ((,class (:foreground ,sp00ky-yellow))))
   `(org-level-4 ((,class (:foreground ,sp00ky-orange))))


   `(Info-quoted ((,class
		   (:inherit nil
		    :foreground ,sp00ky-majenta))))
   
   ))


;(provide-theme sp00ky)
