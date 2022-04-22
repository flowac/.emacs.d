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
(define-skeleton sp00ky-skeleton/c-dfn
  "Insert a function" nil
  "//======================================================================" \n
  "// Description:" \n
  "//   DOCSTRING" \n
  "//======================================================================" \n
  "void f" _ "(void)" \n
  "{" > \n \n
  "return;" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/c-sdfn
  "Insert a function" nil
  "//======================================================================" \n
  "// Description:" \n
  "//   DOCSTRING" \n
  "//======================================================================" \n
  "static void f" _ "(void)" \n
  "{" > \n \n
  "return;" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/c-whi
  "Insert a function" nil
  "while (" _ ")" \n
  "{" > \n \n
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
(define-skeleton sp00ky-skeleton/hec-expansion
  "" nil
  "HAL_ERR_CONT(status, " _ ");")
(define-skeleton sp00ky-skeleton/HERU-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "HAL_ERR_RETU(status, " _ ");")

(define-skeleton sp00ky-skeleton/DER-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "DRV_ERR_RET(drvStatus, " _ ");")

(define-skeleton sp00ky-skeleton/hso-expansion
  "Insert HalStatus_Ok" nil
  "HalStatus_Ok");")

(define-skeleton sp00ky-skeleton/rhso-expansion
  "DOCSTRING" nil
  "return HalStatus_Ok;");")

(define-skeleton sp00ky-skeleton/hli-expansion
  "" nil
  "HAL_LOG_INFO(\"" _ "\");" >)

(define-skeleton sp00ky-skeleton/hle-expansion
  "" nil
  "HAL_LOG_ERR(\"" _ "\");" >)
(define-skeleton sp00ky-skeleton/hs-expansion
  "" nil
  "HalStatus" >)
(define-skeleton sp00ky-skeleton/hld-expansion
  "" nil
  "HAL_LOG_DEBUG(\"" _ "\");" >)
(define-skeleton sp00ky-skeleton/c-swi
  "" nil
  "switch (" _ ")" > \n
  "{" > \n
  "case x:" > \n
  "break;" > \n
  "default:" > \n
  "break;" > \n
  "}" > )
(define-skeleton sp00ky-skeleton/c-tenu
  "" nil
  "typedef enum" > \n
  "{" _ > \n
  "} enumName;" >)

(define-abbrev-table 'c-mode-abbrev-table
  '(
    ("tenu" "" sp00ky-skeleton/c-tenu)
    ("swi" "" sp00ky-skeleton/c-swi)
    ("whi" "" sp00ky-skeleton/c-whi)
    ("dfn" "" sp00ky-skeleton/c-dfn)
    ("cif" "" sp00ky-skeleton/c-if-statement)
    ("cfor" "" sp00ky-skeleton/c-for-statement)
    ("chf" "" sp00ky-skeleton/c-hal-ret-fun)
    ("cst" "" sp00ky-skeleton/skeleton-test)
    ("hs" "" sp00ky-skeleton/hs-expansion)
    ("hss" "" sp00ky-skeleton/hss)
    ("rhso" "" sp00ky-skeleton/rhso-expansion)
    ("hso" "" sp00ky-skeleton/hso-expansion)
    ("hse" "HalStatus_Error")
    ("hsi" "HalStatus_InvalidParameter")
    ("hsd" "HalStatus_DriverError")
    ("hli" "" sp00ky-skeleton/hli-expansion)
    ("hle" "" sp00ky-skeleton/hle-expansion)
    ("hld" "" sp00ky-skeleton/hld-expansion)
    ("hec" "" sp00ky-skeleton/hec-expansion)
    ("cher" "" sp00ky-skeleton/HER-expansion)
    ("cheru" "" sp00ky-skeleton/HERU-expansion)
    ("der" "" sp00ky-skeleton/DER-expansion)
    ("sdfn" "" sp00ky-skeleton/c-sdfn)
    ;; END
    ))

(define-skeleton sp00ky-skeleton/elisp-dfn-expansion
  "Insert a defun statement" nil
  "(defun f" _ " ()" \n
  "\"DOCSTRING\"" \n
  "(interactive)" \n
  ")")

(define-skeleton sp00ky-skeleton/elisp-dfk-expansion
  "Insert a define-key statement" nil
  "(define-key m" _ " (kbd \"k\") 'function)" >)

(define-skeleton sp00ky-skeleton/elisp-dfv-expansion
  "Insert a defvar statement" nil
  "(defvar v" _ " nil \"DOCSTRING\")" >)

;; (clear-abbrev-table emacs-lisp-mode-abbrev-table)
(define-abbrev-table 'emacs-lisp-mode-abbrev-table
  '(
    ("dfn" "" sp00ky-skeleton/elisp-dfn-expansion)
    ("dfk" "" sp00ky-skeleton/elisp-dfk-expansion)
    ("dfv" "" sp00ky-skeleton/elisp-dfv-expansion)
    ;; END
    ))

(define-skeleton sp00ky-skeleton/sh-dfn-expansion
  "Insert a defun statement" nil
  "function f" _ " () {" \n \n
  "}" >)

(define-abbrev-table 'sh-mode-abbrev-table
  '(
    ("dfn" "" sp00ky-skeleton/sh-dfn-expansion)
    ))

(define-abbrev-table 'shell-mode-abbrev-table
  '(
    ("dfn" "" sp00ky-skeleton/sh-dfn-expansion)
    ))

;; Global abbrevs. The abbrevs in this table mainly handle typos
(clear-abbrev-table global-abbrev-table)
(define-abbrev-table 'global-abbrev-table
  '(
    ("teh" "the")
    ("thsi" "this")
    ;; END
    ))
