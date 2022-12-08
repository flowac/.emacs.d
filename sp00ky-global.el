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
(defvar global-base-command "global --path-style absolute --result grep "
  "Shell command to invoke global.")

(defun sp00ky-invoke-global (symbol)
  "Sp00ky global wrapper."
  (split-string
   (shell-command-to-string (concat global-base-command symbol))
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

(global-set-key (kbd "C-c ]") 'sp00ky-get-tag-list)

(defun sp00ky-test ()
  "test"
  (interactive)
  (print (thing-at-point 'symbol t)))

;;; test.el ends here
