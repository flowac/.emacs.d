(pdf-tools-install)

;(setq pdf-info-epdfinfo-error-filename '("~/.emacs.d/log/epdfinfo.log"))
(setq pdf-annot-activate-created-annotations t)

;;;;; behaviour
(defun noct:pdf-view-goto-page (count)
  "Goto page COUNT.
If COUNT is not supplied, go to the last page."
  (interactive "P")
  (if count
      (pdf-view-goto-page count)
    (pdf-view-last-page)))

;;; workaround for pdf-tools not reopening to last-viewed page of the pdf:
;;; https://github.com/politza/pdf-tools/issues/18#issuecomment-269515117
(defun brds/pdf-set-last-viewed-bookmark ()
  (interactive)
  (when (eq major-mode 'pdf-view-mode)
    (bookmark-set (brds/pdf-generate-bookmark-name))))

(defun brds/pdf-jump-last-viewed-bookmark ()
  (bookmark-set "fake") ; this is new
  (when
      (brds/pdf-has-last-viewed-bookmark)
    (bookmark-jump (brds/pdf-generate-bookmark-name))))

(defun brds/pdf-has-last-viewed-bookmark ()
  (assoc
   (brds/pdf-generate-bookmark-name) bookmark-alist))

(defun brds/pdf-generate-bookmark-name ()
  (concat "PDF-LAST-VIEWED: " (buffer-file-name)))

(defun brds/pdf-set-all-last-viewed-bookmarks ()
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (brds/pdf-set-last-viewed-bookmark))))

(add-hook 'kill-buffer-hook 'brds/pdf-set-last-viewed-bookmark)
(add-hook 'pdf-view-mode-hook 'brds/pdf-jump-last-viewed-bookmark)
(unless noninteractive  ; as `save-place-mode' does
  (add-hook 'kill-emacs-hook #'brds/pdf-set-all-last-viewed-bookmarks))

;(evil-define-key 'normal pdf-view-mode-map
;  "G" 'noct:pdf-view-goto-page)
;;
;(evil-set-initial-state 'pdf-view-mode 'normal)
;(evil-define-key 'normal pdf-view-mode-map
;  [mouse-down-1] nil
;  (kbd "j") 'pdf-view-next-line-or-next-page
;  (kbd "k") 'pdf-view-previous-line-or-previous-page
;  (kbd "l") 'image-forward-hscroll
;  (kbd "h") 'image-backward-hscroll
;  (kbd "C-f") 'pdf-view-next-page
;  (kbd "C-b") 'pdf-view-previous-page
;  (kbd "o") 'pdf-outline 
;  (kbd "O") 'pdf-outline-quit
;  (kbd "+") 'pdf-view-enlarge
;  (kbd "-") 'pdf-view-shrink
;  (kbd "=") 'pdf-view-scale-reset
;  (kbd "W") 'pdf-view-fit-width-to-window
;  (kbd "r") 'revert-buffer
;  [down-mouse-1] 'pdf-view-mouse-set-region
;  (kbd "/") 'isearch-forward
;  (kbd "C-s") 'pdf-occur)
