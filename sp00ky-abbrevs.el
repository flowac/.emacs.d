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
  "//================================================================================" \n
  "// Description:" \n
  "//" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "void f" _ "(void)" \n
  "{" > \n \n
  "return;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-hdfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
  "//" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "HalStatus f" _ "(void)" \n
  "{" > \n \n
  "return HalStatus_Ok;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-static-hal-dfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
  "//" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "static HalStatus f" _ "(void)" \n
  "{" > \n \n
  "return HalStatus_Ok;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-sdfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
  "//" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "static void f" _ "(void)" \n
  "{" > \n \n
  "return;" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/c-whi
  "" nil
  "while (" _ ")" \n
  "{" > \n \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-for-statement
  "" nil
  "for (int i = 0; " _ "; i++)" > \n
  "{" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-hal-ret-fun
  "" nil
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
(define-skeleton sp00ky-skeleton/hal-cnc-err-ret-expansion
  "" nil
  "HAL_CNCORE_ERR_RET(status, " _ ");")
(define-skeleton sp00ky-skeleton/hal-cnc-err-retu-expansion
  "" nil
  "HAL_CNCORE_ERR_RETU(status, " _ ");")
(define-skeleton sp00ky-skeleton/hal-cnc-err-cont-expansion
  "" nil
  "HAL_CNCORE_ERR_CONT(status, " _ ");")
(define-skeleton sp00ky-skeleton/hec-expansion
  "" nil
  "HAL_ERR_CONT(status, " _ ");")
(define-skeleton sp00ky-skeleton/HERU-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "HAL_ERR_RETU(status, " _ ");")

(define-skeleton sp00ky-skeleton/DER-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "DRV_ERR_RET(drvStatus, " _ ");")

(define-skeleton sp00ky-skeleton/cso-expansion
  "" nil
  "CnCoreStatus_Ok");")

(define-skeleton sp00ky-skeleton/rcso-expansion
  "" nil
  "return CnCoreStatus_Ok;");")

(define-skeleton sp00ky-skeleton/cs-expansion
  "" nil
  "CnCoreStatus");")

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
(define-skeleton sp00ky-skeleton/typedef-struct
  "" nil
  "typedef struct _t" > \n
  "{" _ > \n
  "} t;" >)
(define-skeleton sp00ky-skeleton/c-include
  "" nil
  "#include <" _ ">" >)

(define-abbrev-table 'c-mode-abbrev-table
  '(
    ("inc" ""   sp00ky-skeleton/c-include)
    ("tstr" ""  sp00ky-skeleton/typedef-struct)
    ("tenu" ""  sp00ky-skeleton/c-tenu)
    ("swi" ""   sp00ky-skeleton/c-swi)
    ("whi" ""   sp00ky-skeleton/c-whi)
    ("cif" ""   sp00ky-skeleton/c-if-statement)
    ("cfor" ""  sp00ky-skeleton/c-for-statement)
    ("chf" ""   sp00ky-skeleton/c-hal-ret-fun)
    ("cst" ""   sp00ky-skeleton/skeleton-test)
    ("dfn" ""   sp00ky-skeleton/c-dfn)
    ("shdfn" "" sp00ky-skeleton/c-static-hal-dfn)
    ("hdfn" ""  sp00ky-skeleton/c-hdfn)
    ("hs" ""    sp00ky-skeleton/hs-expansion)
    ("hss" ""   sp00ky-skeleton/hss)
    ("rhso" ""  sp00ky-skeleton/rhso-expansion)
    ("hso" ""   sp00ky-skeleton/hso-expansion)
    ("cs" ""    sp00ky-skeleton/cs-expansion)
    ("cso" ""   sp00ky-skeleton/cso-expansion)
    ("rcso" ""  sp00ky-skeleton/rcso-expansion)
    ("hsf"      "HalStatus_Failure")
    ("hse"      "HalStatus_Error")
    ("hsi"      "HalStatus_InvalidParameter")
    ("hsd"      "HalStatus_DriverError")
    ("hli" ""   sp00ky-skeleton/hli-expansion)
    ("hle" ""   sp00ky-skeleton/hle-expansion)
    ("hld" ""   sp00ky-skeleton/hld-expansion)
    ("hec" ""   sp00ky-skeleton/hec-expansion)
    ("her" ""   sp00ky-skeleton/HER-expansion)
    ("hcer" ""  sp00ky-skeleton/hal-cnc-err-ret-expansion)
    ("hceru" "" sp00ky-skeleton/hal-cnc-err-retu-expansion)
    ("hcec" ""  sp00ky-skeleton/hal-cnc-err-cont-expansion)
    ("heru" ""  sp00ky-skeleton/HERU-expansion)
    ("der" ""   sp00ky-skeleton/DER-expansion)
    ("sdfn" ""  sp00ky-skeleton/c-sdfn)
    ;; END
    ))

(define-skeleton sp00ky-skeleton/elisp-dfn-expansion
  "Insert a defun statement" nil
  "(defun f" _ " ()" \n
  "\"DOCSTRING\"" \n
  ")")

(define-skeleton sp00ky-skeleton/elisp-dfni-expansion
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
    ("dfn" ""  sp00ky-skeleton/elisp-dfn-expansion)
    ("dfni" "" sp00ky-skeleton/elisp-dfni-expansion)
    ("dfk" ""  sp00ky-skeleton/elisp-dfk-expansion)
    ("dfv" ""  sp00ky-skeleton/elisp-dfv-expansion)
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
    ("cant" "can't")
    ("dont" "don't")
    ("isnt" "isn't")
    ;; END
    ))
