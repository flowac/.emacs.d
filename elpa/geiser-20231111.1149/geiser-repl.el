;;; geiser-repl.el --- Geiser's REPL  -*- lexical-binding: t; -*-

;; Copyright (C) 2009-2013, 2015-2016, 2018-2023 Jose Antonio Ortega Ruiz

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the Modified BSD License. You should
;; have received a copy of the license along with this program. If
;; not, see <http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5>.


;;; Code:

(require 'geiser-capf)
(require 'geiser-doc)
(require 'geiser-autodoc)
(require 'geiser-edit)
(require 'geiser-completion)
(require 'geiser-syntax)
(require 'geiser-impl)
(require 'geiser-eval)
(require 'geiser-connection)
(require 'geiser-menu)
(require 'geiser-image)
(require 'geiser-custom)
(require 'geiser-base)

(require 'comint)
(require 'compile)
(require 'scheme)
(require 'font-lock)
(require 'project)
(require 'paren)

(eval-when-compile (require 'subr-x))


;;; Customization:

(defgroup geiser-repl nil
  "Interacting with the Geiser REPL."
  :group 'geiser)

(geiser-custom--defcustom geiser-repl-buffer-name-function
    'geiser-repl-buffer-name
  "Function used to define the name of a REPL buffer.
The function is called with a single argument - an implementation
symbol (e.g., `guile', `chicken', etc.)."
  :type '(choice (function-item geiser-repl-buffer-name)
                 (function :tag "Other function")))

(geiser-custom--defcustom geiser-repl-per-project-p nil
  "Whether to spawn a separate REPL per project.
See also `geiser-repl-current-project-function' for the function
used to discover a buffer's project."
  :type 'boolean)

(defun geiser-repl-project-root ()
  "Use project.el, to determine a buffer's project root."
  (when-let (p (project-current)) (project-root p)))

(geiser-custom--defcustom geiser-repl-current-project-function
    #'geiser-repl-project-root
  "Function used to determine the current project.
The function is called from both source and REPL buffers, and
should return a value which uniquely identifies the project."
  :type '(choice (function-item :tag "Ignore projects" ignore)
                 (function-item :tag "Use project.el" geiser-repl-project-root)
                 (function-item :tag "Use projectile" projectile-project-root)
                 (function :tag "Other function")))

(geiser-custom--defcustom geiser-repl-use-other-window t
  "Whether to Use a window other than the current buffer's when
switching to the Geiser REPL buffer."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-window-allow-split t
  "Whether to allow window splitting when switching to the Geiser REPL buffer."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-history-filename
    (expand-file-name "~/.geiser_history")
  "File where REPL input history is saved, so that it persists between sessions.

This is actually the base name: the concrete Scheme
implementation name gets appended to it."
  :type 'file)

(geiser-custom--defcustom geiser-repl-history-size comint-input-ring-size
  "Maximum size of the saved REPL input history."
  :type 'integer)

(geiser-custom--defcustom geiser-repl-history-no-dups-p t
  "Whether to skip duplicates when recording history."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-save-debugging-history-p t
  "Whether to save debugging input in REPL history.

By default, REPL interactions while scheme is in the debugger are
not added to the REPL command history.  Set this variable to t to
change that."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-autodoc-p t
  "Whether to enable `geiser-autodoc-mode' in the REPL by default."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-read-only-prompt-p t
  "Whether the REPL's prompt should be read-only."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-read-only-output-p t
  "Whether the REPL's output should be read-only."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-highlight-output-p nil
  "Whether to syntax highlight REPL output."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-auto-indent-p t
  "Whether newlines for incomplete sexps are autoindented."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-send-on-return-p t
  "Whether to Send input to REPL when ENTER is pressed in a balanced S-expression,
regardless of cursor positioning.

When off, pressing ENTER inside a balance S-expression will
introduce a new line without sending input to the inferior
Scheme process. This option is useful when using minor modes
which might do parentheses balancing, or when entering additional
arguments inside an existing expression.

When on (the default), pressing ENTER inside a balanced S-expression
will send the input to the inferior Scheme process regardless of the
cursor placement."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-forget-old-errors-p t
  "Whether to forget old errors upon entering a new expression.

When on (the default), every time a new expression is entered in
the REPL old error messages are flushed, and using \\[next-error]
afterwards will jump only to error locations produced by the new
expression, if any."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-skip-version-check-p nil
  "Whether to skip version checks for the Scheme executable.

When set, Geiser won't check the version of the Scheme
interpreter when starting a REPL, saving a few tenths of a
second."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-query-on-exit-p nil
  "Whether to prompt for confirmation on \\[geiser-repl-exit]."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-delete-last-output-on-exit-p nil
  "Whether to delete partial outputs when the REPL's process exits."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-query-on-kill-p t
  "Whether to prompt for confirmation when killing a REPL buffer with
a life process."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-default-host "localhost"
  "Default host when connecting to remote REPLs."
  :type 'string)

(geiser-custom--defcustom geiser-repl-default-port 37146
  "Default port for connecting to remote REPLs."
  :type 'integer)

(geiser-custom--defcustom geiser-repl-startup-time 10000
  "Time, in milliseconds, to wait for Racket to startup.
If you have a slow system, try to increase this time."
  :type 'integer)

(geiser-custom--defcustom geiser-repl-inline-images-p t
  "Whether to display inline images in the REPL."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-auto-display-images-p t
  "Whether to automatically invoke the external viewer to display
images popping up in the REPL.

See also `geiser-debug-auto-display-images'."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-add-project-paths t
  "Whether to automatically add current project's root to load path on startup.

If set to `t' (the default), the directory returned by
`geiser-repl-current-project-function' is added to the load path.

If set to a list of sudirectories (e.g. (\".\" \"src\" \"tests\")),
their full path (starting with the project's root, is added
instead.

This variable is a good candidate for .dir-locals.el.

This option has no effect if no project root is found."
  :type '(choice boolean (list string)))

(geiser-custom--defcustom geiser-repl-startup-hook nil
  "Functions run right after a REPL has started and is fully set up.

See also `geiser-repl-startup-forms'."
  :type 'hook)

(geiser-custom--defcustom geiser-repl-startup-forms nil
  "List scheme forms, as strings, sent to a REPL on start-up.

This variable is a good candidate for .dir-locals.el.

See also `geiser-repl-startup-hook'."
  :type '(repeat string))

(geiser-custom--defcustom geiser-repl-autoeval-mode-delay 0.125
  "Delay before autoeval is run after an S-expression is balanced, in seconds."
  :type 'number)

(geiser-custom--defcustom geiser-repl-autoeval-mode-p nil
  "Whether `geiser-repl-autoeval-mode' gets enabled by default in REPL buffers."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-superparen-mode-p nil
  "Whether `geiser-repl-superparen-mode' gets enabled by default in REPL buffers."
  :type 'boolean)

(geiser-custom--defcustom geiser-repl-superparen-character ?\]
  "The character that represents a closing super parentheses."
  :type 'character)

(geiser-custom--defface repl-input
  'comint-highlight-input geiser-repl "evaluated input highlighting")

(geiser-custom--defface repl-output
  'font-lock-string-face geiser-repl "REPL output")

(geiser-custom--defface repl-prompt
  'comint-highlight-prompt geiser-repl "REPL prompt")



;;; Implementation-dependent parameters

(geiser-impl--define-caller geiser-repl--binary binary ()
  "A variable or function returning the path to the scheme binary
for this implementation.")

(geiser-impl--define-caller geiser-repl--arglist arglist ()
  "A function taking no arguments and returning a list of
arguments to be used when invoking the scheme binary.")

(geiser-impl--define-caller geiser-repl--prompt-regexp prompt-regexp ()
  "A variable (or thunk returning a value) giving the regular
expression for this implementation's geiser scheme prompt.")

(geiser-impl--define-caller
    geiser-repl--debugger-prompt-regexp debugger-prompt-regexp ()
  "A variable (or thunk returning a value) giving the regular
expression for this implementation's debugging prompt.")

(geiser-impl--define-caller geiser-repl--startup repl-startup (remote)
  "Function taking no parameters that is called after the REPL
has been initialised. All Geiser functionality is available to
you at that point.")

(geiser-impl--define-caller geiser-repl--enter-cmd enter-command (module)
  "Function taking a module designator and returning a REPL enter
module command as a string")

(geiser-impl--define-caller geiser-repl--import-cmd import-command (module)
  "Function taking a module designator and returning a REPL import
module command as a string")

(geiser-impl--define-caller geiser-repl--exit-cmd exit-command ()
  "Function returning the REPL exit command as a string")

(geiser-impl--define-caller geiser-repl--version version-command (binary)
  "Function returning the version of the corresponding scheme process,
   given its full path.")

(geiser-impl--define-caller geiser-repl--min-version minimum-version ()
  "A variable providing the minimum required scheme version, as a string.")

(geiser-impl--define-caller geiser-repl--connection-address connection-address ()
  "If this implementation supports a parallel connection, return its address.
The implementation is responsible of setting up the listening REPL on
startup.  When this function returns a non-nil address, a connection
will be set up using `geiser-connect-local' when a REPL is started.")


;;; Geiser REPL buffers and processes:

(defvar geiser-repl--repls nil)
(defvar geiser-repl--closed-repls nil)

(defvar geiser-repl--last-output-start nil)
(defvar geiser-repl--last-output-end nil)

(defvar-local geiser-repl--repl nil)

(defvar-local geiser-repl--project nil)

(defsubst geiser-repl--set-this-buffer-repl (r &optional this)
  (with-current-buffer (or this (current-buffer)) (setq geiser-repl--repl r)))

(defsubst geiser-repl--set-this-buffer-project (p)
  (setq geiser-repl--project p))

(defsubst geiser-repl--current-project ()
  (or (when geiser-repl-per-project-p
        (funcall geiser-repl-current-project-function))
      'no-project))

(defun geiser-repl--live-p ()
  (and geiser-repl--repl
       (get-buffer-process geiser-repl--repl)))

(defun geiser-repl--repl/impl (impl &optional proj repls)
  (let ((proj (or proj
                  geiser-repl--project
                  (geiser-repl--current-project)))
        (repls (or repls
                   geiser-repl--repls)))
    (catch 'repl
      (dolist (repl repls)
        (when (buffer-live-p repl)
          (with-current-buffer repl
            (when (and (eq geiser-impl--implementation impl)
                       (equal geiser-repl--project proj))
              (throw 'repl repl))))))))

(defun geiser-repl--set-up-repl (impl)
  (or (and (not impl) geiser-repl--repl)
      (geiser-repl--set-this-buffer-repl
       (let ((impl (or impl
                       geiser-impl--implementation
                       (geiser-impl--guess))))
         (when impl (geiser-repl--repl/impl impl))))))

(defun geiser-repl--active-impls ()
  (let ((act))
    (dolist (repl geiser-repl--repls act)
      (with-current-buffer repl
        (unless (memq geiser-impl--implementation act)
          (push geiser-impl--implementation act))))))

(defsubst geiser-repl--repl-name (impl)
  (format "%s REPL" (geiser-impl--impl-str impl)))

(defsubst geiser-repl--buffer-name (impl)
  (funcall geiser-repl-buffer-name-function impl))

(defun geiser-repl-buffer-name (impl)
  "Return default name of the REPL buffer for implementation IMPL."
  (let ((repl-name (geiser-repl--repl-name impl))
        (current-project (funcall geiser-repl-current-project-function)))
    (if (and geiser-repl-per-project-p current-project)
        (let ((project-name (file-name-nondirectory
                             (directory-file-name current-project))))
          (format "*Geiser %s: %s*" repl-name project-name))
      (format "*Geiser %s*" repl-name))))

(defun geiser-repl--switch-to-buffer (buffer)
  (unless (eq buffer (current-buffer))
    (let ((pop-up-windows geiser-repl-window-allow-split))
      (if geiser-repl-use-other-window
          (switch-to-buffer-other-window buffer)
        (switch-to-buffer buffer)))))

(defun geiser-repl--to-repl-buffer (impl)
  (unless (and (eq major-mode 'geiser-repl-mode)
               (eq geiser-impl--implementation impl)
               (not (get-buffer-process (current-buffer))))
    (let* ((proj (geiser-repl--current-project))
           (old (geiser-repl--repl/impl impl proj geiser-repl--closed-repls))
           (old (and (buffer-live-p old)
                     (not (get-buffer-process old))
                     old))
           (origin (current-buffer)))
      (geiser-repl--switch-to-buffer
       (or old (generate-new-buffer (geiser-repl--buffer-name impl))))
      (geiser-repl--set-this-buffer-repl (current-buffer) origin)
      (unless old
        (geiser-repl-mode)
        (geiser-impl--set-buffer-implementation impl)
        (geiser-repl--set-this-buffer-project proj)
        (geiser-syntax--add-kws t)))))

(defun geiser-repl--read-impl (prompt &optional active)
  (geiser-impl--read-impl prompt (and active (geiser-repl--active-impls))))

(defsubst geiser-repl--only-impl-p ()
  (and (null (cdr geiser-active-implementations))
       (car geiser-active-implementations)))

(defun geiser-repl--get-impl (prompt)
  (or (geiser-repl--only-impl-p)
      (and (eq major-mode 'geiser-repl-mode) geiser-impl--implementation)
      (geiser-repl--read-impl prompt)))


;;; Prompt &co.

(defun geiser-repl--last-prompt-end ()
  (cond ((and (boundp 'comint-last-prompt) (markerp (cdr comint-last-prompt)))
         (marker-position (cdr comint-last-prompt)))
        ((and (boundp 'comint-last-prompt-overlay) comint-last-prompt-overlay)
         (overlay-end comint-last-prompt-overlay))
        (t (save-excursion
             (geiser-repl--bol)
             (min (+ 1 (point)) (point-max))))))

(defun geiser-repl--last-prompt-start ()
  (cond ((and (boundp 'comint-last-prompt) (markerp (car comint-last-prompt)))
         (marker-position (car comint-last-prompt)))
        ((and (boundp 'comint-last-prompt-overlay) comint-last-prompt-overlay)
         (overlay-start comint-last-prompt-overlay))
        (t (save-excursion (geiser-repl--bol) (point)))))


;;; REPL connections

(defvar-local geiser-repl--address nil)

(defvar-local geiser-repl--connection nil)

(defun geiser-repl--local-p ()
  "Return non-nil, if current REPL is local (connected to socket)."
  (stringp geiser-repl--address))

(defun geiser-repl--remote-p ()
  "Return non-nil, if current REPL is remote (connected to host:port)."
  (consp geiser-repl--address))

(defsubst geiser-repl--host () (car geiser-repl--address))
(defsubst geiser-repl--port () (cdr geiser-repl--address))

(defun geiser-repl--read-address (&optional host port)
  (let ((defhost (or (geiser-repl--host) geiser-repl-default-host))
        (defport (or (geiser-repl--port) geiser-repl-default-port)))
    (cons (or host
              (read-string (format "Host (default %s): " defhost)
                           nil nil defhost))
          (or port (read-number "Port: " defport)))))

(defun geiser-repl--autodoc-mode (n)
  (when (or geiser-repl-autodoc-p (< n 0))
    (geiser--save-msg (geiser-autodoc-mode n))))

(defun geiser-repl--save-remote-data (address)
  (setq geiser-repl--address address)
  (cond ((consp address)
         (setq header-line-format
               (format "Host: %s   Port: %s"
                       (geiser-repl--host)
                       (geiser-repl--port))))
        ((stringp address)
         (setq header-line-format
               (format "Socket: %s" address)))))

(defun geiser-repl--fontify-output-region (beg end)
  "Apply highlighting to a REPL output region."
  (remove-text-properties beg end '(font-lock-face nil face nil))
  (if geiser-repl-highlight-output-p
      (geiser-syntax--fontify-syntax-region beg end)
    (geiser-repl--fontify-plaintext beg end)))

(defun geiser-repl--fontify-plaintext (start end)
  "Fontify REPL output plainly."
  (add-text-properties
   start end
   '(font-lock-fontified t
                         fontified t
                         font-lock-multiline t
                         font-lock-face geiser-font-lock-repl-output)))

(defun geiser-repl--narrow-to-prompt ()
  "Narrow to active prompt region and return t, otherwise returns nil."
  (let* ((proc (get-buffer-process (current-buffer)))
         (pmark (and proc (process-mark proc)))
         (intxt (when (>= (point) (marker-position pmark))
                  (save-excursion
                    (if comint-eol-on-send
                        (if comint-use-prompt-regexp
                            (end-of-line)
                          (goto-char (field-end))))
                    (buffer-substring pmark (point)))))
         (prompt-beg (marker-position pmark))
         (prompt-end (+ prompt-beg (length intxt))))
    (when (> (length intxt) 0)
      (narrow-to-region prompt-beg prompt-end)
      t)))

(defun geiser-repl--wrap-fontify-region-function (_beg _end &optional _loudly)
  (save-restriction
    (when (geiser-repl--narrow-to-prompt)
      (let ((font-lock-dont-widen t))
        (font-lock-default-fontify-region (point-min) (point-max) nil)))))

(defun geiser-repl--wrap-unfontify-region-function (_beg _end &optional _loudly)
  (save-restriction
    (when (geiser-repl--narrow-to-prompt)
      (let ((font-lock-dont-widen t))
        (font-lock-default-unfontify-region (point-min) (point-max))))))

(defun geiser-repl--find-output-region ()
  (save-excursion
    (goto-char (point-max))
    (re-search-backward comint-prompt-regexp)
    (move-to-column 0)
    (set-marker geiser-repl--last-output-end (point))
    (save-excursion
      (when (re-search-backward comint-prompt-regexp nil t)
        (forward-line)
        (when (> (point) geiser-repl--last-output-start)
          (set-marker geiser-repl--last-output-start (point)))))
    (> (- geiser-repl--last-output-end geiser-repl--last-output-start) 2)))

(defun geiser-repl--treat-output-region ()
  (with-silent-modifications
    (add-text-properties (max (point-min) (1- geiser-repl--last-output-start))
                         (min geiser-repl--last-output-end (point-max))
                         `(read-only ,geiser-repl-read-only-output-p))
    (geiser-repl--fontify-output-region geiser-repl--last-output-start
                                        geiser-repl--last-output-end)
    (geiser--font-lock-ensure geiser-repl--last-output-start
                              geiser-repl--last-output-end)))

(defun geiser-repl--output-filter (txt)
  (when (geiser-repl--find-output-region) (geiser-repl--treat-output-region))
  (geiser-con--connection-update-debugging geiser-repl--connection txt)
  (geiser-image--replace-images geiser-repl-inline-images-p
                                geiser-repl-auto-display-images-p)
  (when (string-match-p (geiser-con--connection-prompt geiser-repl--connection)
                        txt)
    (geiser-autodoc--disinhibit-autodoc)))

(defun geiser-repl--check-version (impl)
  (when (not geiser-repl-skip-version-check-p)
    (let ((v (geiser-repl--version impl (geiser-repl--binary impl)))
          (r (geiser-repl--min-version impl)))
      (when (and v r (geiser--version< v r))
        (error "Geiser requires %s version %s but detected %s" impl r v)))))

(defvar geiser-repl--last-scm-buffer)

(defun geiser-repl--set-default-directory ()
  (when-let (root (funcall geiser-repl-current-project-function))
    (setq-local default-directory root)))

(defun geiser-repl--set-up-load-path ()
  (when geiser-repl-add-project-paths
    (when-let (root (funcall geiser-repl-current-project-function))
      (dolist (p (cond ((eq t geiser-repl-add-project-paths) '("."))
                       ((listp geiser-repl-add-project-paths)
                        geiser-repl-add-project-paths)))
        (geiser-add-to-load-path (expand-file-name p root))))))

(defvar-local geiser-repl--repl-buffer nil)

(defvar-local geiser-repl--binary nil)

(defvar-local geiser-repl--arglist nil)

(defun geiser-repl--start-repl (impl address)
  (message "Starting Geiser REPL ...")
  (when (not address) (geiser-repl--check-version impl))
  (let ((buffer (current-buffer))
        (binary (geiser-repl--binary impl))
        (arglist (geiser-repl--arglist impl)))
    (geiser-repl--to-repl-buffer impl)
    (setq geiser-repl--last-scm-buffer buffer
          geiser-repl--binary binary
          geiser-repl--arglist arglist))
  (sit-for 0)
  (goto-char (point-max))
  (geiser-repl--autodoc-mode -1)
  (let* ((prompt-rx (geiser-repl--prompt-regexp impl))
         (deb-prompt-rx (geiser-repl--debugger-prompt-regexp impl))
         (prompt (geiser-con--combined-prompt prompt-rx deb-prompt-rx)))
    (unless prompt-rx
      (error "Sorry, I don't know how to start a REPL for %s" impl))
    (geiser-repl--set-default-directory)
    (geiser-repl--save-remote-data address)
    (geiser-repl--start-scheme impl address prompt)
    (geiser-repl--quit-setup)
    (geiser-repl--history-setup)
    (add-to-list 'geiser-repl--repls (current-buffer))
    (geiser-repl--set-this-buffer-repl (current-buffer))
    (setq geiser-repl--connection
          (geiser-repl--connection-setup impl address prompt-rx deb-prompt-rx))
    (geiser-repl--startup impl address)
    (geiser-repl--autodoc-mode 1)
    (geiser-repl--set-up-load-path)
    (add-hook 'comint-output-filter-functions
              'geiser-repl--output-filter
              nil
              t)
    (set-process-query-on-exit-flag (get-buffer-process (current-buffer))
                                    geiser-repl-query-on-kill-p)
    (dolist (f geiser-repl-startup-forms)
      (geiser-log--info "Evaluating startup form %s..." f)
      (geiser-eval--send/wait `(:eval (:scm ,f))))
    (run-hooks 'geiser-repl-startup-hook)
    (message "%s up and running!" (geiser-repl--repl-name impl))))

(defvar-local geiser-repl--connection-buffer nil)

(defun geiser-repl--connection-buffer (addr)
  (when addr (get-buffer-create (format " %s  <%s>" (buffer-name) addr))))

(defun geiser-repl--connection-setup (impl address prompt deb-prompt)
  (let* ((addr (unless address (geiser-repl--connection-address impl)))
         (buff (or (geiser-repl--connection-buffer addr) (current-buffer))))
    (when addr
      (setq geiser-repl--connection-buffer buff)
      (geiser-repl--comint-local-connect buff addr))
    (geiser-con--make-connection (get-buffer-process buff) prompt deb-prompt)))

(defun geiser-repl--comint-local-connect (buff address)
  "Connect over a Unix-domain socket."
  (with-current-buffer buff
    (let ((proc (make-network-process :name (buffer-name buff)
                                      :buffer buff
                                      :family 'local
                                      :remote address)))
      ;; brittleness warning: this is stuff
      ;; make-comint-in-buffer sets up, via comint-exec, when
      ;; it creates its own process, something we're doing
      ;; here by ourselves.
      (set-process-filter proc 'comint-output-filter)
      (goto-char (point-max))
      (set-marker (process-mark proc) (point)))))

(defun geiser-repl--start-scheme (impl address prompt)
  (setq comint-prompt-regexp prompt)
  (let* ((name (geiser-repl--repl-name impl))
         (buff (current-buffer))
         (args (cond ((consp address) (list address))
                     ((stringp address) '(()))
                     (t `(,(geiser-repl--get-binary impl)
                          nil
                          ,@(geiser-repl--get-arglist impl))))))
    (condition-case err
        (if (and address (stringp address))
            (geiser-repl--comint-local-connect buff address)
          (apply 'make-comint-in-buffer `(,name ,buff ,@args)))
      (error (insert "Unable to start REPL:\n" (error-message-string err) "\n")
             (error "Couldn't start Geiser: %s" err)))
    (geiser-repl--wait-for-prompt geiser-repl-startup-time)))

(defun geiser-repl--wait-for-prompt (timeout)
  (let ((p (point)) (seen) (buffer (current-buffer)))
    (while (and (not seen)
                (> timeout 0)
                (get-buffer-process buffer))
      (sleep-for 0.1)
      (setq timeout (- timeout 100))
      (goto-char p)
      (setq seen (re-search-forward comint-prompt-regexp nil t)))
    (goto-char (point-max))
    (unless seen (error "%s" "No prompt found!"))))

(defun geiser-repl--is-debugging ()
  (let ((dp (geiser-con--connection-debug-prompt geiser-repl--connection)))
    (and dp
         (save-excursion
           (goto-char (geiser-repl--last-prompt-start))
           (re-search-forward dp (geiser-repl--last-prompt-end) t)))))

(defun geiser-repl--connection* ()
  (let ((buffer (geiser-repl--set-up-repl geiser-impl--implementation)))
    (and (buffer-live-p buffer)
         (get-buffer-process buffer)
         (with-current-buffer buffer geiser-repl--connection))))

(defun geiser-repl--connection ()
  (or (geiser-repl--connection*)
      (error "No Geiser REPL for this buffer (try M-x geiser)")))

(setq geiser-eval--default-connection-function 'geiser-repl--connection)

(defun geiser-repl--prepare-send ()
  (geiser-image--clean-cache)
  (geiser-autodoc--inhibit-autodoc)
  (geiser-con--connection-deactivate geiser-repl--connection))

(defun geiser-repl--send (cmd &optional save-history)
  "Send CMD input string to the current REPL buffer.
If SAVE-HISTORY is non-nil, save CMD in the REPL history."
  (when (and cmd (eq major-mode 'geiser-repl-mode))
    (geiser-repl--prepare-send)
    (goto-char (point-max))
    (comint-kill-input)
    (insert cmd)
    (let ((comint-input-filter (if save-history
                                   comint-input-filter
                                 'ignore)))
      (comint-send-input nil t))))

(defun geiser-repl-interrupt ()
  (interactive)
  (when (get-buffer-process (current-buffer))
    (interrupt-process nil comint-ptyp)))


;;; REPL history

(defconst geiser-repl--history-separator "\n}{\n")

(defsubst geiser-repl--history-file ()
  (format "%s.%s" geiser-repl-history-filename geiser-impl--implementation))

(defun geiser-repl--read-input-ring ()
  (let ((comint-input-ring-file-name (geiser-repl--history-file))
        (comint-input-ring-separator geiser-repl--history-separator)
        (buffer-file-coding-system 'utf-8))
    (comint-read-input-ring t)))

(defun geiser-repl--write-input-ring ()
  (let ((comint-input-ring-file-name (geiser-repl--history-file))
        (comint-input-ring-separator geiser-repl--history-separator)
        (buffer-file-coding-system 'utf-8))
    (comint-write-input-ring)))

(defun geiser-repl--history-setup ()
  (set (make-local-variable 'comint-input-ring-size) geiser-repl-history-size)
  (set (make-local-variable 'comint-input-filter) 'geiser-repl--input-filter)
  (geiser-repl--read-input-ring))


;;; Cleaning up

(defun geiser-repl--on-quit ()
  (geiser-repl--write-input-ring)
  (let ((cb (current-buffer))
        (impl geiser-impl--implementation)
        (comint-prompt-read-only nil))
    (geiser-con--connection-deactivate geiser-repl--connection t)
    (geiser-con--connection-close geiser-repl--connection)
    (setq geiser-repl--repls (remove cb geiser-repl--repls))
    (unless (eq cb geiser-repl--connection-buffer)
      (when (buffer-live-p geiser-repl--connection-buffer)
        (kill-buffer geiser-repl--connection-buffer)
        (setq geiser-repl--connection-buffer nil)
        (when-let (a (geiser-repl--connection-address
                      geiser-impl--implementation))
          (delete-file a))))
    (dolist (buffer (buffer-list))
      (when (buffer-live-p buffer)
        (with-current-buffer buffer
          (when (and (eq geiser-impl--implementation impl)
                     (equal cb geiser-repl--repl))
            (geiser-repl--set-up-repl geiser-impl--implementation)))))))

(defun geiser-repl--sentinel (proc _event)
  (let ((pb (process-buffer proc)))
    (when (buffer-live-p pb)
      (with-current-buffer pb
        (let ((comint-prompt-read-only nil)
              (comint-input-ring-file-name (geiser-repl--history-file))
              (comint-input-ring-separator geiser-repl--history-separator))
          (geiser-repl--on-quit)
          (push pb geiser-repl--closed-repls)
          (goto-char (point-max))
          (when geiser-repl-delete-last-output-on-exit-p
            (comint-kill-region comint-last-input-start (point)))
          (insert "\nIt's been nice interacting with you!\n")
          (insert
           (substitute-command-keys
            "Press \\[geiser-repl-switch] to bring me back.\n")))))))

(defun geiser-repl--on-kill ()
  (geiser-repl--on-quit)
  (setq geiser-repl--closed-repls
        (remove (current-buffer) geiser-repl--closed-repls)))

(defun geiser-repl--input-filter (str)
  (not (or (and (not geiser-repl-save-debugging-history-p)
                (geiser-repl--is-debugging))
           (string-match "^\\s *$" str)
           (string-match "^,quit *$" str))))

(defun geiser-repl--old-input ()
  (save-excursion
    (let ((end (point)))
      (backward-sexp)
      (buffer-substring (point) end))))

(defun geiser-repl--quit-setup ()
  (add-hook 'kill-buffer-hook 'geiser-repl--on-kill nil t)
  (set-process-sentinel (get-buffer-process (current-buffer))
                        'geiser-repl--sentinel))


;;; geiser-repl-autoeval-mode minor mode:

(defun geiser-repl--autoeval-paren-function ()
  (let* ((data (show-paren--default))
         (here (nth 0 data))
         (there (nth 2 data))
         (mismatch (nth 4 data)))
    (if (and here
             (eq 0 (geiser-repl--nesting-level))
             (not mismatch)
             (> here there))
        (geiser-repl--send-input))
    data))

(defvar-local geiser-repl-autoeval-mode-string " E"
  "Modeline indicator for geiser-repl-autoeval-mode")

(define-minor-mode geiser-repl-autoeval-mode
  "Toggle the Geiser REPL's Autoeval mode.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

When Autoeval mode is enabled, balanced S-expressions are automatically
evaluated without having to press ENTER.

This mode may cause issues with structural editing modes such as paredit."
  :init-value nil
  :lighter geiser-repl-autoeval-mode-string
  :group 'geiser-repl

  (if (boundp 'show-paren-data-function)
      (if geiser-repl-autoeval-mode
          (progn (show-paren-local-mode 1)
                 (setq-local show-paren-delay geiser-repl-autoeval-mode-delay)
                 (setq-local show-paren-data-function
                             'geiser-repl--autoeval-paren-function))
        (setq-local show-paren-data-function 'show-paren--default)))
  (when (called-interactively-p nil)
    (message "Geiser Autoeval %s"
             (if geiser-repl-autoeval-mode "enabled" "disabled"))))


;;; geiser-repl-superparen-mode minor mode:

(defun geiser-repl--superparen-function ()
  (when (char-equal (char-before) geiser-repl-superparen-character)
    (delete-char -1)
    (insert-char ?\) (geiser-repl--nesting-level))))

(defvar-local geiser-repl-superparen-mode-string " S"
  "Modeline indicator for geiser-repl-superparen-mode")

(define-minor-mode geiser-repl-superparen-mode
  "Toggle the Geiser REPL's Superparen mode.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

When Superparen mode is enabled, entering the
`geiser-repl-superparen-char' character, which is ']' by default,
will close all parentheses of the expression currently being
typed.

This mode may cause issues with structural editing modes such as
paredit."
  :init-value nil
  :lighter geiser-repl-superparen-mode-string
  :group 'geiser-repl

  (if geiser-repl-superparen-mode
      (add-hook 'post-self-insert-hook #'geiser-repl--superparen-function nil t)
    (remove-hook 'post-self-insert-hook #'geiser-repl--superparen-function t))
  (when (called-interactively-p nil)
    (if geiser-repl-superparen-mode
        (message "Geiser Superparen enabled, using the %c character."
                 geiser-repl-superparen-character)
      (message "Geiser Superparen disabled."))))


;;; geiser-repl mode:

(defun geiser-repl--bol ()
  (interactive)
  (when (= (point) (comint-bol)) (beginning-of-line)))

(defun geiser-repl--beginning-of-defun ()
  (save-restriction
    (narrow-to-region (geiser-repl--last-prompt-end) (point))
    (let ((beginning-of-defun-function nil))
      (beginning-of-defun))))

(defun geiser-repl--module-function (&optional module)
  (if (and module geiser-eval--get-impl-module)
      (funcall geiser-eval--get-impl-module module)
    :f))

(defun geiser-repl--doc-module ()
  (interactive)
  (let ((geiser-eval--get-module-function
         (geiser-impl--method 'find-module geiser-impl--implementation)))
    (geiser-doc-module)))

(defun geiser-repl--newline-and-indent ()
  (interactive)
  (save-restriction
    (narrow-to-region comint-last-input-start (point-max))
    (insert "\n")
    (lisp-indent-line)))

(defun geiser-repl--nesting-level ()
  (save-restriction
    (narrow-to-region (geiser-repl--last-prompt-end) (point-max))
    (geiser-syntax--nesting-level)))

(defun geiser-repl--is-input ()
  (not (eq (field-at-pos (point)) 'output)))

(defun geiser-repl--grab-input ()
  (let ((pos (comint-bol)))
    (goto-char (point-max))
    (insert (field-string-no-properties pos))))

(defun geiser-repl--send-input ()
  (set-marker geiser-repl--last-output-start (point-max))

  (let* ((proc (get-buffer-process (current-buffer)))
         (pmark (and proc (process-mark proc)))
         (intxt (and pmark (buffer-substring pmark (point)))))
    (when intxt
      (when geiser-repl-forget-old-errors-p
        (compilation-forget-errors))
      (geiser-repl--prepare-send)
      (comint-send-input)
      ;; match if `intxt' is lines of whitespace
      (when (string-match "\\`\\(\\s-\\|\n\\)*\\'" intxt)
        (comint-send-string proc (geiser-eval--scheme-str '(:ge no-values)))
        (comint-send-string proc "\n")))))

(define-obsolete-function-alias 'geiser-repl--maybe-send
  #'geiser-repl-maybe-send "0.26")

(defun geiser-repl-maybe-send ()
  "Handle the current input at the REPL's prompt.

If `geiser-repl-send-on-return-p' is t and the input is a
complete sexp, send the input to the REPL process; otherwise,
insert a new line and, if `geiser-repl-auto-indent-p' is t,
indentation."
  (interactive)
  (let ((p (point)))
    (cond ((< p (geiser-repl--last-prompt-start))
           (if (geiser-repl--is-input)
               (geiser-repl--grab-input)
             (ignore-errors (compile-goto-error))))
          ((let ((inhibit-field-text-motion t))
             (when geiser-repl-send-on-return-p
               (end-of-line))
             (<= (geiser-repl--nesting-level) 0))
           (geiser-repl--send-input))
          (t (goto-char p)
             (if geiser-repl-auto-indent-p
                 (geiser-repl--newline-and-indent)
               (insert "\n"))))))

(defun geiser-repl-tab-dwim (n)
  "If we're after the last prompt, complete symbol or indent (if
there's no symbol at point). Otherwise, go to next error in the REPL
buffer."
  (interactive "p")
  (if (>= (point) (geiser-repl--last-prompt-end))
      (or (completion-at-point)
          (lisp-indent-line))
    (compilation-next-error n)))

(defun geiser-repl--previous-error (n)
  "Go to previous error in the REPL buffer."
  (interactive "p")
  (compilation-next-error (- n)))

(defun geiser-repl-clear-buffer ()
  "Delete the output generated by the scheme process."
  (interactive)
  (let ((inhibit-read-only t))
    (delete-region (point-min) (geiser-repl--last-prompt-start))
    (when (< (point) (geiser-repl--last-prompt-end))
      (goto-char (geiser-repl--last-prompt-end)))
    (recenter t)))

(defvar geiser-repl-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map comint-mode-map)

    (define-key map "\C-d" 'delete-char)
    (define-key map "\C-m" 'geiser-repl-maybe-send)
    (define-key map "\r" 'geiser-repl-maybe-send)
    (define-key map "\C-j" 'geiser-repl--newline-and-indent)
    (define-key map (kbd "TAB") 'geiser-repl-tab-dwim)
    (define-key map [backtab] 'geiser-repl--previous-error)

    (define-key map "\C-a" 'geiser-repl--bol)
    (define-key map (kbd "<home>") 'geiser-repl--bol)

    (geiser-menu--defmenu repl map
      ("Complete symbol" ((kbd "M-TAB"))
       completion-at-point :enable (geiser--symbol-at-point))
      ("Complete module name" ((kbd "C-.") (kbd "M-`"))
       geiser-capf-complete-module :enable (geiser--symbol-at-point))
      ("Edit symbol" "\M-." geiser-edit-symbol-at-point
       :enable (geiser--symbol-at-point))
      --
      ("Load scheme file..." "\C-c\C-l" geiser-load-file)
      ("Switch to module..." "\C-c\C-m" geiser-repl-switch-to-module)
      ("Import module..." "\C-c\C-i" geiser-repl-import-module)
      ("Add to load path..." "\C-c\C-r" geiser-add-to-load-path)
      --
      ("Previous matching input" "\M-p" comint-previous-matching-input-from-input
       "Previous input matching current")
      ("Next matching input" "\M-n" comint-next-matching-input-from-input
       "Next input matching current")
      ("Previous prompt" "\C-c\C-p" geiser-repl-previous-prompt)
      ("Next prompt" "\C-c\C-n" geiser-repl-next-prompt)
      ("Previous input" "\C-c\M-p" comint-previous-input)
      ("Next input" "\C-c\M-n" comint-next-input)
      --
      ("Interrupt evaluation" ("\C-c\C-k" "\C-c\C-c")
       geiser-repl-interrupt)
      --
      (mode "Autodoc mode" ("\C-c\C-da" "\C-c\C-d\C-a") geiser-autodoc-mode)
      (mode "Autoeval mode" ("\C-c\C-de" "\C-c\C-d\C-e")
            geiser-repl-autoeval-mode)
      (mode "Superparen mode" ("\C-c\C-ds" "\C-c\C-d\C-s")
            geiser-repl-superparen-mode)
      ("Symbol documentation" ("\C-c\C-dd" "\C-c\C-d\C-d")
       geiser-doc-symbol-at-point
       "Documentation for symbol at point" :enable (geiser--symbol-at-point))
      ("Lookup symbol in manual" ("\C-c\C-di" "\C-c\C-d\C-i")
       geiser-doc-look-up-manual
       "Documentation for symbol at point" :enable (geiser--symbol-at-point))
      ("Module documentation" ("\C-c\C-dm" "\C-c\C-d\C-m") geiser-repl--doc-module
       "Documentation for module at point" :enable (geiser--symbol-at-point))
      --
      ("Clear buffer" "\C-c\M-o" geiser-repl-clear-buffer
       "Clean up REPL buffer, leaving just a lonely prompt")
      ("Toggle ()/[]" ("\C-c\C-e\C-[" "\C-c\C-e[") geiser-squarify)
      ("Insert λ" ("\C-c\\" "\C-c\C-\\") geiser-insert-lambda)
      --
      ("Kill Scheme interpreter" "\C-c\C-q" geiser-repl-exit
       :enable (geiser-repl--live-p))
      ("Restart" "\C-c\C-z" geiser-repl-switch
       :enable (not (geiser-repl--live-p)))

      --
      (custom "REPL options" geiser-repl))

    (define-key map [menu-bar completion] 'undefined)
    map))

(define-derived-mode geiser-repl-mode comint-mode "REPL"
  "Major mode for interacting with an inferior scheme repl process.
\\{geiser-repl-mode-map}"
  (scheme-mode-variables)
  (hack-dir-local-variables-non-file-buffer)
  (set (make-local-variable 'geiser-repl--last-output-start) (point-marker))
  (set (make-local-variable 'geiser-repl--last-output-end) (point-marker))
  (set (make-local-variable 'face-remapping-alist)
       '((comint-highlight-prompt geiser-font-lock-repl-prompt)
         (comint-highlight-input geiser-font-lock-repl-input)))
  (set (make-local-variable 'mode-line-process) nil)
  (set (make-local-variable 'comint-use-prompt-regexp) nil)
  (set (make-local-variable 'comint-prompt-read-only)
       geiser-repl-read-only-prompt-p)
  (setq comint-process-echoes nil)
  (set (make-local-variable 'beginning-of-defun-function)
       'geiser-repl--beginning-of-defun)
  (set (make-local-variable 'comint-input-ignoredups)
       geiser-repl-history-no-dups-p)
  (setq geiser-eval--get-module-function 'geiser-repl--module-function)
  (geiser-capf-setup t)
  (setq geiser-smart-tab-mode-string "")
  (geiser-smart-tab-mode t)

  (setq-local font-lock-fontify-region-function
              #'geiser-repl--wrap-fontify-region-function)
  (setq-local font-lock-unfontify-region-function
              #'geiser-repl--wrap-unfontify-region-function)
  (setq geiser-autodoc-mode-string "/E")
  (when geiser-repl-autoeval-mode-p
    (geiser-repl-autoeval-mode 1))
  (when geiser-repl-superparen-mode-p
    (geiser-repl-superparen-mode 1))

  ;; enabling compilation-shell-minor-mode without the annoying highlighter
  (compilation-setup t))


;;; User commands

(define-obsolete-function-alias 'run-geiser 'geiser "Geiser 0.26")

(defun geiser (impl)
  "Start a new Geiser REPL."
  (interactive
   (list (geiser-repl--get-impl "Start Geiser for scheme implementation: ")))
  (geiser-repl--start-repl impl nil))

(defun geiser-connect (impl &optional host port)
  "Start a new Geiser REPL connected to a remote Scheme process."
  (interactive
   (list (geiser-repl--get-impl "Connect to Scheme implementation: ")))
  (geiser-repl--start-repl impl (geiser-repl--read-address host port)))

(defun geiser-connect-local (impl socket)
  "Start a new Geiser REPL connected to a remote Scheme process
over a Unix-domain socket."
  (interactive
   (list (geiser-repl--get-impl "Connect to Scheme implementation: ")
         (expand-file-name (read-file-name "Socket file name: "))))
  (geiser-repl--start-repl impl socket))

(defvar-local geiser-repl--last-scm-buffer nil)

(defun geiser-repl--maybe-remember-scm-buffer (buffer)
  (when (and buffer
             (eq 'scheme-mode (with-current-buffer buffer major-mode))
             (eq major-mode 'geiser-repl-mode))
    (setq geiser-repl--last-scm-buffer buffer)))

(defun geiser-repl--get-binary (impl)
  (or geiser-repl--binary (geiser-repl--binary impl)))

(defun geiser-repl--get-arglist (impl)
  (or geiser-repl--arglist (geiser-repl--arglist impl)))

(defun geiser-repl--call-in-repl (cmd)
  (when-let (b (geiser-repl--repl/impl geiser-impl--implementation))
    (save-window-excursion
      (with-current-buffer b (funcall cmd)))))

(define-obsolete-function-alias 'switch-to-geiser 'geiser-repl-switch "0.26")

(defun geiser-repl-switch (&optional ask impl buffer)
  "Switch to running Geiser REPL.

If REPL is the current buffer, switch to the previously used
scheme buffer.

With prefix argument, ask for which one if more than one is running.
If no REPL is running, execute `geiser' to start a fresh one."
  (interactive "P")
  (let* ((impl (or impl geiser-impl--implementation))
         (in-repl (eq major-mode 'geiser-repl-mode))
         (in-live-repl (and in-repl (get-buffer-process (current-buffer))))
         (repl (unless ask
                 (if impl
                     (geiser-repl--repl/impl impl)
                   (or geiser-repl--repl (car geiser-repl--repls))))))
    (cond (in-live-repl
           (when (and (not (eq repl buffer))
                      (buffer-live-p geiser-repl--last-scm-buffer))
             (geiser-repl--switch-to-buffer geiser-repl--last-scm-buffer)))
          (repl (geiser-repl--set-this-buffer-repl repl)
                (geiser-repl--switch-to-buffer repl))
          ((geiser-repl--remote-p)
           (geiser-connect impl (geiser-repl--host) (geiser-repl--port)))
          ((geiser-repl--local-p)
           (geiser-connect-local impl geiser-repl--address))
          (impl (geiser impl))
          (t (call-interactively 'geiser)))
    (geiser-repl--maybe-remember-scm-buffer buffer)))

(define-obsolete-function-alias 'switch-to-geiser-module
  'geiser-repl-switch-to-module "0.26")

(defun geiser-repl-switch-to-module (&optional module buffer)
  "Switch to running Geiser REPL and try to enter a given module."
  (interactive)
  (let* ((module (or module
                     (geiser-completion--read-module
                      "Switch to module (default top-level): ")))
         (cmd (and module
                   (geiser-repl--enter-cmd geiser-impl--implementation
                                           module))))
    (unless (eq major-mode 'geiser-repl-mode)
      (geiser-repl-switch nil nil (or buffer (current-buffer))))
    (geiser-repl--send cmd)))

(defun geiser-repl--switch-to-repl (&optional and-module)
  (if and-module
      (geiser-repl-switch-to-module (geiser-eval--get-module) (current-buffer))
    (geiser-repl-switch nil nil (current-buffer))))

(defun geiser-repl--ensure-repl-buffer ()
  (unless (buffer-live-p geiser-repl--repl)
    (setq geiser-repl--repl
          (geiser-repl--repl/impl geiser-impl--implementation)))
  (buffer-live-p geiser-repl--repl))

(defun geiser-repl-restart-repl ()
  "Restarts the REPL associated with the current buffer."
  (interactive)
  (let ((b (current-buffer))
        (impl geiser-impl--implementation))
    (when (buffer-live-p geiser-repl--repl)
      (geiser-repl--switch-to-repl nil)
      (comint-kill-subjob)
      (sit-for 0.1)) ;; ugly hack; but i don't care enough to fix it
    (geiser impl)
    (sit-for 0.2)
    (goto-char (point-max))
    (pop-to-buffer b)))

(defun geiser-repl-import-module (&optional module)
  "Import a given module in the current namespace of the REPL."
  (interactive)
  (let* ((module (or module
                     (geiser-completion--read-module "Import module: ")))
         (cmd (and module
                   (geiser-repl--import-cmd geiser-impl--implementation
                                            module))))
    (geiser-repl--switch-to-repl)
    (geiser-repl--send cmd)))

(defun geiser-repl-exit (&optional arg)
  "Exit the current REPL.
With a prefix argument, force exit by killing the scheme process."
  (interactive "P")
  (when (or (not geiser-repl-query-on-exit-p)
            (y-or-n-p "Really quit this REPL? "))
    (geiser-con--connection-deactivate geiser-repl--connection t)
    (let ((cmd (and (not arg)
                    (geiser-repl--exit-cmd geiser-impl--implementation))))
      (if cmd
          (when (stringp cmd) (geiser-repl--send cmd))
        (comint-kill-subjob)))))

(defun geiser-repl-next-prompt (n)
  (interactive "p")
  (when (> n 0)
    (end-of-line)
    (re-search-forward comint-prompt-regexp nil 'go n)))

(defun geiser-repl-previous-prompt (n)
  (interactive "p")
  (when (> n 0)
    (end-of-line 0)
    (when (re-search-backward comint-prompt-regexp nil 'go n)
      (goto-char (match-end 0)))))

(defun geiser-add-to-load-path (path)
  "Add a new directory to running Scheme's load path.
When called interactively, this function will ask for the path to
add, defaulting to the current buffer's directory."
  (interactive "DDirectory to add: ")
  (let* ((c `(:eval (:ge add-to-load-path ,(file-local-name (expand-file-name path)))))
         (r (geiser-eval--send/result c)))
    (message "%s%s added to load path" path (if r "" " couldn't be"))))


;;; Unload:

(defun geiser-repl--repl-list ()
  (let (lst)
    (dolist (repl geiser-repl--repls lst)
      (when (buffer-live-p repl)
        (with-current-buffer repl
          (push (cons geiser-impl--implementation
                      geiser-repl--address)
                lst))))))

(defun geiser-repl--restore (impls)
  (dolist (impl impls)
    (when impl
      (condition-case err
          (geiser-repl--start-repl (car impl) (cdr impl))
        (error (message (error-message-string err)))))))

(defun geiser-repl-unload-function ()
  (dolist (repl geiser-repl--repls)
    (when (buffer-live-p repl)
      (with-current-buffer repl
        (let ((geiser-repl-query-on-exit-p nil)) (geiser-repl-exit))
        (sit-for 0.05)
        (kill-buffer)))))


(provide 'geiser-repl)


;;; Initialization:
;; After providing 'geiser-repl, so that impls can use us.
(mapc 'geiser-impl--load-impl geiser-active-implementations)
