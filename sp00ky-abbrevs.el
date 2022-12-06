;; C-mode abbrevs
(setq save-abbrevs nil)
(setq skeleton-end-newline nil)

(define-skeleton sp00ky-skeleton/skeleton-test
  "Prompt user for input"
  t
  ("Enter test input: " "test: " str \n))

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

(define-skeleton sp00ky-skeleton/hli-expansion
  "" nil
  "HAL_LOG_INFO(\"" _ "\");" >)

(define-skeleton sp00ky-skeleton/hle-expansion
  "" nil
  "HAL_LOG_ERR(\"" _ "\");" >)

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
    ("cif"   "" sp00ky-skeleton/c-if-statement)
    ("cfor"  "" sp00ky-skeleton/c-for-statement)
    ("chf"   "" sp00ky-skeleton/c-hal-ret-fun)
    ("cst"   "" sp00ky-skeleton/skeleton-test)
    ("der"   "" sp00ky-skeleton/DER-expansion)
    ("dfn"   "" sp00ky-skeleton/c-dfn)
    ("hcer"  "" sp00ky-skeleton/hal-cnc-err-ret-expansion)
    ("hceru" "" sp00ky-skeleton/hal-cnc-err-retu-expansion)
    ("hcec"  "" sp00ky-skeleton/hal-cnc-err-cont-expansion)
    ("hdfn"  "" sp00ky-skeleton/c-hdfn)
    ("hec"   "" sp00ky-skeleton/hec-expansion)
    ("her"   "" sp00ky-skeleton/HER-expansion)
    ("heru"  "" sp00ky-skeleton/HERU-expansion)
    ("hld"   "" sp00ky-skeleton/hld-expansion)
    ("hli"   "" sp00ky-skeleton/hli-expansion)
    ("hle"   "" sp00ky-skeleton/hle-expansion)
    ("inc"   "" sp00ky-skeleton/c-include)
    ("sdfn"  "" sp00ky-skeleton/c-sdfn)
    ("shdfn" "" sp00ky-skeleton/c-static-hal-dfn)
    ("swi"   "" sp00ky-skeleton/c-swi)
    ("tenu"  "" sp00ky-skeleton/c-tenu)
    ("tstr"  "" sp00ky-skeleton/typedef-struct)
    ("whi"   "" sp00ky-skeleton/c-whi)

    ("cs"    "CnCoreStatus"               sp00ky/do-not-insert-space-after-abbrev)
    ("css"   "CnCoreStatus status"        sp00ky/do-not-insert-space-after-abbrev)
    ("csg"   "CnCoreStatus_GenericError"  sp00ky/do-not-insert-space-after-abbrev)
    ("cso"   "CnCoreStatus_Ok"            sp00ky/do-not-insert-space-after-abbrev)
    ("hs"    "HalStatus"                  sp00ky/do-not-insert-space-after-abbrev)
    ("hsd"   "HalStatus_DriverError"      sp00ky/do-not-insert-space-after-abbrev)
    ("hse"   "HalStatus_Error"            sp00ky/do-not-insert-space-after-abbrev)
    ("hsf"   "HalStatus_Failure"          sp00ky/do-not-insert-space-after-abbrev)
    ("hsi"   "HalStatus_InvalidParameter" sp00ky/do-not-insert-space-after-abbrev)
    ("hss"   "HalStatus status"           sp00ky/do-not-insert-space-after-abbrev)
    ("hso"   "HalStatus_Ok"               sp00ky/do-not-insert-space-after-abbrev)
    ("rcs"   "return CnCoreStatus_"       sp00ky/do-not-insert-space-after-abbrev)
    ("rcso"  "return CnCoreStatus_Ok;"    sp00ky/do-not-insert-space-after-abbrev)
    ("rhs"   "return HalStatus_"          sp00ky/do-not-insert-space-after-abbrev)
    ("rhso"  "return HalStatus_Ok;"       sp00ky/do-not-insert-space-after-abbrev)
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
    ("dfn"  ""  sp00ky-skeleton/elisp-dfn-expansion)
    ("dfni" ""  sp00ky-skeleton/elisp-dfni-expansion)
    ("dfk"  ""  sp00ky-skeleton/elisp-dfk-expansion)
    ("dfv"  ""  sp00ky-skeleton/elisp-dfv-expansion)
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

(define-skeleton sp00ky-skeleton/scm-dfn-expansion
  "Insert a defun statement" nil
  "(define (" _ ")" \n
  "\"DOCSTRING\"" \n
  ")">)

(define-abbrev-table 'scheme-mode-abbrev-table
  '(
    ("dfn" ""  sp00ky-skeleton/scm-dfn-expansion)
    ;; END
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
