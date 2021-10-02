(require 'use-package)

(use-package evil
  :ensure t
  :init
  :custom
  (evil-want-keybinding nil)
  (evil-want-integration t)
  (evil-shift-width 3)
  (evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  ;(add-to-list evil-fold-list `(((c-mode) :toggle yafolding-toggle-element)))
  )

(use-package evil-collection
  :after evil
  :ensure t
  :init
  (evil-collection-init))

(use-package company
  :ensure t
  :custom
  (company-dabbrev-downcase 0) ; ignore case
  (company-idle-delay 0.5)
  (company-selection-wrap-around t)
  (company-minimum-prefix-length 5)
  :bind (:map company-active-map
              ("<tab>" . company-complete-common-or-cycle)
              ("TAB"   . company-complete-common-or-cycle)
              ("S-TAB" . company-complete-common-or-cycle)
              ("C-n"   . company-complete-common-or-cycle)
              ("C-p"   . company-select-previous)))

(use-package company-shell
  :ensure t)

(use-package rainbow-delimiters
  :ensure t)

(use-package helpful
  :ensure t)

(use-package regex-tool
  :custom
  (regex-tool-backend "Perl"))

(use-package helm
  :ensure t
  :custom
  (helm-move-to-line-cycle-in-source t) ; circular helm suggestions
  (helm-move-to-line-cycle-in-source nil) ; scroll through sections
  (helm-buffer-max-length 40)
  (helm-command-prefix-key "C-c z")
  (helm-use-mouse t)
  :bind (("C-s"   . 'helm-occur)
         ("M-x"   . 'helm-M-x)
         ("C-c r" . 'helm-resume)
         ("M-f"   . 'helm-find-files)
         ("C-c b" . 'helm-bookmarks)
         :map helm-map
              ("C-j"   . helm-next-line) ; navigate minibuffer
              ("C-k"   . helm-previous-line) ; navigate minibuffer
              ("TAB"   . helm-execute-persistent-action)
              ("<tab>" . helm-execute-persistent-action))
  )

(use-package helm-gtags
  :requires helm
  :ensure t
  :init
  (setq helm-gtags-fuzzy-match t)
  :hook
  (c-mode . helm-gtags-mode)
  (c++-mode . helm-gtags-mode)
  (asm-mode . helm-gtags-mode)
  :custom
  (helm-gtags-display-style nil)
  (helm-gtags-use-input-at-cursor t)
  (helm-gtags-maximum-candidates 150)
  (helm-gtags-pulse-at-cursor nil) ;; reduces lag over ssh
  ;; (helm-gtags-path-style 'root)
  (helm-gtags-auto-update t)
  (helm-gtags-ignore-case t)
  (helm-gtags-cache-select-result t)
  (helm-gtags-auto-update t)
  (helm-gtags-update-interval-second nil)
  (helm-gtags-path-style 'root)
  :bind (:map helm-gtags-mode-map
              ("M-t" . helm-gtags-dwim)
              ("M-T" . helm-gtags-find-tag)
              ("M-r" . helm-gtags-find-rtag)
              ("M-s" . helm-gtags-find-symbol)
              ("M-f" . helm-gtags-tags-in-this-function)
              ("C-k" . helm-gtags-previous-history)
              ("M->" . helm-gtags-next-history)
              ("M-<" . helm-gtags-previous-history)))

(use-package helm-xref
  :requires helm
  :ensure t)

(use-package auctex
  :defer t
  :ensure t)

(use-package idle-highlight-mode
  :ensure t
  :custom
  (idle-highlight-idle-time 2))

(use-package org-autolist
  :ensure t
  :init
  (add-hook 'org-mode-hook (lambda () (org-autolist-mode))))

(use-package projectile
  :ensure t
  :custom
  (projectile-mode +1)
  (projectile-enable-caching nil)
  (projectile-globally-ignored-files
   (append '("GTAGS" "GPATH" "GRTAGS" "TAGS"))))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  )

(use-package pkg-info
  :defer t)

(use-package eyebrowse
  :ensure t
  :config (progn
            (define-key eyebrowse-mode-map (kbd "C-a 1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "C-a 2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "C-a 3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "C-a 4") 'eyebrowse-switch-to-window-config-4)
            (define-key eyebrowse-mode-map (kbd "C-a 5") 'eyebrowse-switch-to-window-config-5)
            (define-key eyebrowse-mode-map (kbd "C-a 6") 'eyebrowse-switch-to-window-config-6)
            (define-key eyebrowse-mode-map (kbd "C-a 7") 'eyebrowse-switch-to-window-config-7)
            (define-key eyebrowse-mode-map (kbd "C-a 8") 'eyebrowse-switch-to-window-config-8)
            (define-key eyebrowse-mode-map (kbd "C-a 9") 'eyebrowse-switch-to-window-config-9)
            (define-key eyebrowse-mode-map (kbd "C-a 0") 'eyebrowse-switch-to-window-config-0)
            (define-key eyebrowse-mode-map (kbd "C-a -") 'eyebrowse-prev-window-config)
            (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
            (define-key eyebrowse-mode-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
            (define-key eyebrowse-mode-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
            (define-key eyebrowse-mode-map (kbd "M-7") 'eyebrowse-switch-to-window-config-7)
            (define-key eyebrowse-mode-map (kbd "M-8") 'eyebrowse-switch-to-window-config-8)
            (define-key eyebrowse-mode-map (kbd "M-9") 'eyebrowse-switch-to-window-config-9)
            (define-key eyebrowse-mode-map (kbd "M-0") 'eyebrowse-switch-to-window-config-0)
            (eyebrowse-mode t)
            (setq eyebrowse-new-workspace t)))

(add-to-list `evil-fold-list `((yafolding-mode)
                               :open-all yafolding-show-all
                               :close-all yafolding-hide-all
                               :toggle yafolding-toggle-element
                               :open yafolding-show-element
                               :close yafolding-hide-element
                               ))

(use-package elpher)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package lsp-mode
  :load-path "~/.emacs.d/submodules/lsp-mode/"
  :hook (gdscript-mode . lsp)
  :commands lsp)

(use-package helm-lsp
  :requires lsp-mode
  :commands helm-lsp-workspace-symbol)

(use-package go-mode
  :ensure t)

(use-package sudo-edit
  :ensure t)
  
(use-package julia-mode
  :ensure t)
