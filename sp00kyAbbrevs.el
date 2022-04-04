;; C-mode abbrevs
(setq save-abbrevs nil)
(setq skeleton-end-newline nil)
(define-skeleton sp00ky-skeleton/hss
  "Declare HalStatus variable" nil
  "HalStatus status;" \n)
(define-skeleton sp00ky-skeleton/c-if-statement
  "Insert an if statement" nil
  "if (" _ ")" > \n
  "{" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/c-for-statement
  "Insert an if statement" nil
  "for (" _ ")" > \n
  "{" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/c-hal-ret-fun
  "Insert a function skeleton that returns HalStatus" nil
  "HalStatus " _ "()" > \n
  "{" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/skeleton-test
  "Prompt user for input"
  t
  ("Enter test input: " "test: " str \n))
(define-skeleton sp00ky-skeleton/HER-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "HAL_ERR_RET(status, " _ ");")

(define-skeleton sp00ky-skeleton/DER-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "DRV_ERR_RET(drvStatus, " _ ");")

(define-skeleton sp00ky-skeleton/hso-expansion
  "Insert HalStatus_Ok" nil
  "HalStatus_Ok");")

;(clear-abbrev-table c-mode-abbrev-table)
(define-abbrev-table 'c-mode-abbrev-table
  '(
    ("cif" "" sp00ky-skeleton/c-if-statement)
    ("cfor" "" sp00ky-skeleton/c-for-statement)
    ("chf" "" sp00ky-skeleton/c-hal-ret-fun)
    ("cst" "" sp00ky-skeleton/skeleton-test)
    ("hs" "HalStatus")
    ("hss" "" sp00ky-skeleton/hss)
    ("hso" "" sp00ky-skeleton/hso-expansion)
    ("hse" "HalStatus_Error")
    ("hsi" "HalStatus_InvalidParameter")
    ("hsd" "HalStatus_DriverError")
    ("hli" "HAL_LOG_INFO")
    ("hle" "HAL_LOG_ERR")
    ("hld" "HAL_LOG_DEBUG")
    ("HER" "" sp00ky-skeleton/HER-expansion)
    ("DER" "" sp00ky-skeleton/DER-expansion)
    ;; END
    ))

(define-skeleton sp00ky-skeleton/elisp-edf-expansion
  "Insert a defun statement" nil
  "(defun f" _ " ()" \n
  "\"DOCSTRING\"" \n
  "(interactive)" \n
  ")")

;; (clear-abbrev-table emacs-lisp-mode-abbrev-table)
(define-abbrev-table 'emacs-lisp-mode-abbrev-table
  '(
    ("edf" "" sp00ky-skeleton/elisp-edf-expansion)
    ;; END
    ))

;; Global abbrevs. The abbrevs in this table mainly handle typos
(clear-abbrev-table global-abbrev-table)
(define-abbrev-table 'global-abbrev-table
  '(
    ("teh" "the")
    ("thsi" "this")
    ;; END
    ))
