;; Start emacs server
(server-start)
;; useful settings/ customizations
;; close the menubars for emacs
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq ring-bell-function 'ignore)
;; insert matching paren
(electric-pair-mode t)
(global-hl-line-mode +1) ; highlight current line
(column-number-mode t) ; show column number on bottom of screen

;; paren mode, highlight matching parens
(show-paren-mode 1)
(setq show-paren-when-point-in-periphery t)
(setq show-paren-when-point-inside-paren t)

;; (setq display-line-numbers 'visual)
;; (setq display-line-numbers-type 'visual)
;; (when (version<= "26.0.50" emacs-version )
  ;; (global-display-line-numbers-mode))

(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

; doesnt work atm
(setq x-select-enable-clipboard t) ; copy to system clipboard

;split vertically by default when opening two files
(setq split-height-threshold 70)
(setq split-width-threshold 180)

;;; changing title of duplicate buffer titles
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;fix emacs comments spacing
(setq ess-fancy-comments nil)

;;disable ediff white space
(setq ediff-diff-options "-w")

;; ediff marked buffers in ibuffer mode
(defun ibuffer-ediff-marked-buffers ()
  (interactive)
  (let* ((marked-buffers (ibuffer-get-marked-buffers))
         (len (length marked-buffers)))
    (unless (= 2 len)
      (error (format "%s buffer%s been marked (needs to be 2)"
                     len (if (= len 1) " has" "s have"))))
    (ediff-buffers (car marked-buffers) (cadr marked-buffers))))
(require 'ibuffer)

(add-to-list 'auto-mode-alist '("\\.def\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.bb\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.bash.*\\'" . shell-script-mode))

(setq large-file-warning-threshold nil) ; surpress large file warning
(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-16"))

(setq desktop-restore-eager 10)
(desktop-save-mode 1)

; Try and reduce font lock latency set to 2
(setq font-lock-maximum-decoration t)
(setq help-window-select t)

; Move eldoc documentation to popup, checkout posframe update this
(setq x-gtk-use-system-tooltips t)
(defun my-eldoc-display-message (format-string &rest args)
  "Display eldoc message near point."
  (when format-string
    (tooltip-show (apply 'format format-string args))))
(setq eldoc-message-function #'my-eldoc-display-message)
(setq eldoc-message-function 'eldoc-minibuffer-message)

(add-hook 'org-mode-hook 'visual-line-mode)
(setq Man-notify-method 'aggressive)
(setq bookmark-search-size 24)

;; scroll one line at a time
; Autosave every 500 typed characters
(setq auto-save-interval 500)
; Scroll just one line when hitting bottom of window
(setq scroll-conservatively 10000)

(setq-default sh-basic-offset 3)

(which-function-mode)
;;; Display n/a instead of ???
(setq which-func-unknown "n/a")
;;; Show current function in headerline
(setq-default header-line-format
              '((which-func-mode ("" which-func-format " "))))
(setq mode-line-misc-info
            ;; We remove Which Function Mode from the mode line, because it's mostly
            ;; invisible here anyway.
            (assq-delete-all 'which-func-mode mode-line-misc-info))

(set-face-attribute 'default nil :height 200)
(xterm-mouse-mode 1)
(setq tab-stop-list (number-sequence 3 60 3))

(setq asm-imenu-generic-expression
      '(("Functions" "\\(^[a-z].*\\):" 1)))

(require 'midnight)
(setq clean-buffer-list-delay-general 7)

(add-hook 'asm-mode-hook
          (lambda ()
            (setq imenu-generic-expression asm-imenu-generic-expression)))

(custom-set-variables
 '(help-at-pt-timer-delay 0.9)
 '(help-at-pt-display-when-idle '(flymake-overlay)))
(global-undo-tree-mode t)

(setq eww-search-prefix "https://html.duckduckgo.com/html/?q=")

(setq Info-fontify-quotations nil)


;; (add-hook 'org-mode-hook 'org-num-mode)
