;;; sp00ky-global.el --- My experimental elisp GNU Global interface

;;; Commentary:
;;

;;; TODO: Sp00ky-cache-current not working (not modifying global vars)

;;; Note: To evaluate local changes to defvars we can use eval-defun (C-M-x)
(defconst sp00ky-cache-future 0 "Index of the future list in the cache")
(defconst sp00ky-cache-past 1 "Index of the past list in the cache")
(defvar sp00ky-tag-caches (list (list (list) (list)))
  "Holds the list of caches. Each cache contains ((future) (past)). Both lists store the entries
from newest to oldest.")
(defvar sp00ky-global-base-command "global --path-style absolute --result grep "
  "Shell command to invoke global.")

(defun sp00ky-invoke-global (symbol)
  "Sp00ky global wrapper."
  (split-string
   (shell-command-to-string (concat sp00ky-global-base-command symbol))
   "[\n]+" t))

(defun sp00ky-cache-current ()
  "Cache current location in buffer"
  (let* ((cache (nth 0 sp00ky-tag-caches))
         (future (nth sp00ky-cache-future cache))
         (past (nth sp00ky-cache-past cache)))
    (setq future (cons "hello" future))
    (print cache)
    (print future)))

(defun sp00ky-goto-tag (tag)
  "Parse the tag in filename:linenumber:fnname format and then goto it"
  (let* ((tag-info (split-string tag "[:]+"))
         (path (nth 0 tag-info))
         (line (nth 1 tag-info))
         ; Currently unused, I am thinking put the point at the start
         ; of sym-name in the future
         (sym-name (nth 2 tag-info)))
    (find-file path)
    (goto-line (string-to-number line))))

(defun sp00ky-get-tag-list ()
  "Get tag list."
  (interactive)
  (let ((tags (sp00ky-invoke-global (thing-at-point 'symbol t))))
    (if (eq (length tags) 1)
        (sp00ky-goto-tag (car tags))
      (while tags
      ;;; car is first item in list, cdr is the rest of the list
        ;; (sp00ky-goto-tag (car tags))
        (print (car tags))
        (setq tags (cdr tags))))))

(defun sp00ky/gtags/get-function-def (elem)
  "DOCSTRING"
  (let ((jump-pos elem)
        tags tag-info tag-path tag-line b-lookup-doc)
    ;; First check if we are on a valid symbol. If not, we will check
    ;; the parent bracket.
    (when (string-match-p "^[_a-zA-Z0-9]+("
                          (buffer-substring-no-properties (point)
                                                          (line-end-position)))
      (setq jump-pos (point)
            b-lookup-doc t))
    (when (or b-lookup-doc
              (and (string-match-p "(" (char-to-string (char-after elem)))
                   (string-match-p "[a-zA-Z0-9]" (char-to-string (char-before elem)))))
      (goto-char jump-pos)
      ;; We know we have hit a function, we will try and look it up,
      ;; then grab the contents of the definition.
      (setq tags (sp00ky-invoke-global (thing-at-point 'symbol)))
      (when tags
        (setq tag-info (split-string (nth 0 tags) "[:]+")
              tag-path (nth 0 tag-info)
              tag-line (string-to-number (nth 1 tag-info)))
        (with-temp-buffer
          (insert-file-contents tag-path)
          (goto-char (point-min))
          (forward-line (- tag-line 1)) ;; Seems like we start at line 1 not 0.
          (buffer-substring (line-beginning-position) (search-forward ")")))))))

(defun sp00ky/gtags/eldoc-function (&optional cb)
  "DOCSTRING"
  (interactive)
  (save-excursion
    (let* ((ppss (syntax-ppss))
           (bracket-depth (nth 0 ppss))
           (open-paren-list (nth 9 ppss))
           bracket-check-results eldoc-string result)
      ;; In c, we are always in scoped contexts with {}, so we expect
      ;; this to usually be greater than 0. We will use a basic
      ;; heuristic to determine if the bracket we are at is that of a
      ;; function. [a-zA-Z]\(
      (if (> bracket-depth 0)
          (progn
            (setq bracket-check-results
                  (mapcar 'sp00ky/gtags/get-function-def open-paren-list))
            (setq eldoc-string (dolist (elem (reverse bracket-check-results) result)
                                 (when (not result)
                                   (setq result elem))))
            ;; (print eldoc-string)
            eldoc-string)
        nil))))

;; (global-set-key (kbd "C-c ]") 'sp00ky-get-tag-list)

;;(defun sp00ky-test ()
;;  "test"
;;  (interactive)
;;  (print (thing-at-point 'symbol t)))

;;; test.el ends here
