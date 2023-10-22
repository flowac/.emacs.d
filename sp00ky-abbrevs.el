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
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "HalStatus f" _ "(void)" \n
  "{" > \n \n
  "return HalStatus_Ok;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-cdfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "CnCoreStatus f" _ "(void)" \n
  "{" > \n \n
  "return CnCoreStatus_Ok;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-static-hal-dfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "static HalStatus f" _ "(void)" \n
  "{" > \n \n
  "return HalStatus_Ok;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-static-cncore-dfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
  "//   DOCSTRING" \n
  "//================================================================================" \n
  "static CnCoreStatus f" _ "(void)" \n
  "{" > \n \n
  "return CnCoreStatus_Ok;" > \n
  "}" >)

(define-skeleton sp00ky-skeleton/c-sdfn
  "Insert a function" nil
  "//================================================================================" \n
  "// Description:" \n
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

(define-skeleton sp00ky-skeleton/c-do-statement
  "" nil
  "do {" > \n _ \n
  "} while(0);" >)

(define-skeleton sp00ky-skeleton/c-hal-ret-fun
  "" nil
  "HalStatus " _ "()" > \n
  "{" > \n
  "}" >)

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

(define-skeleton sp00ky-skeleton/hal-cnc-err-ret-expansion  "" nil "HAL_CNCORE_ERR_RET(status, " _ ");")
(define-skeleton sp00ky-skeleton/hal-cnc-err-retu-expansion "" nil "HAL_CNCORE_ERR_RETU(status, " _ ");")
(define-skeleton sp00ky-skeleton/hal-cnc-err-cont-expansion "" nil "HAL_CNCORE_ERR_CONT(status, " _ ");")
(define-skeleton sp00ky-skeleton/DER-expansion              "" nil "DRV_ERR_RET(drvStatus, " _ ");")
(define-skeleton sp00ky-skeleton/hli-expansion              "" nil "HAL_LOG_INFO(\"" _ "\");" >)
(define-skeleton sp00ky-skeleton/hle-expansion              "" nil "HAL_LOG_ERR(\"" _ "\");" >)
(define-skeleton sp00ky-skeleton/hld-expansion              "" nil "HAL_LOG_DEBUG(\"" _ "\");" >)
(define-skeleton sp00ky-skeleton/her-expansion              "" nil "HAL_ERR_RET(status, \"" _ "\");" >)
(define-skeleton sp00ky-skeleton/heb-expansion              "" nil "HAL_ERR_BREAK(status, \"" _ "\");" >)
(define-skeleton sp00ky-skeleton/hec-expansion              "" nil "HAL_ERR_CONT(status, \"" _ "\");" >)
(define-skeleton sp00ky-skeleton/heru-expansion             "" nil "HAL_ERR_RETU(status, \"" _ "\");" >)
(define-skeleton sp00ky-skeleton/c-include                  "" nil "#include <" _ ">" >)

(defmacro sp00ky/c-macro-abbrev-template (fn-name macro)
  `(defun ,fn-name ()
     (interactive)
     (let (function-name status-variable)
       (save-excursion
         (forward-line -1)
         (beginning-of-line-text)
         (setq status-variable (thing-at-point 'symbol))
         (re-search-forward "= +" (line-end-position))
         (setq function-name (thing-at-point 'symbol)))
       (insert (format
                "%s(%s, \"%s() failed\");"
                ,macro
                status-variable
                function-name)))
     (sp00ky/do-not-insert-space-after-abbrev)))

(sp00ky/c-macro-abbrev-template sp00ky/abbrev-heba-expand   "HAL_ERR_BREAK")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-her-expand   "HAL_ERR_RET")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-heru-expand  "HAL_ERR_RETU")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-hec-expand   "HAL_ERR_CONT")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-hceb-expand  "HAL_CNCORE_ERR_BREAK")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-hcer-expand  "HAL_CNCORE_ERR_RET")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-hceru-expand "HAL_CNCORE_ERR_RETU")
(sp00ky/c-macro-abbrev-template sp00ky/abbrev-hcec-expand  "HAL_CNCORE_ERR_CONT")

(define-abbrev-table 'c-mode-abbrev-table
  '(
    ;; Generally abbrevs ending in ; are smart abbrevs that fill in
    ;; their contents based on surrounding context.
    ("cif"   "" sp00ky-skeleton/c-if-statement)
    ("cdo"  "" sp00ky-skeleton/c-do-statement)
    ("cfor"  "" sp00ky-skeleton/c-for-statement)
    ("chf"   "" sp00ky-skeleton/c-hal-ret-fun)
    ("cst"   "" sp00ky-skeleton/skeleton-test)
    ("cstr"  "" sp00ky-skeleton/typedef-struct)
    ("cswi"   "" sp00ky-skeleton/c-swi)
    ("der"   "" sp00ky-skeleton/DER-expansion)
    ("dfn"   "" sp00ky-skeleton/c-dfn)
    ("hceb"  "" sp00ky/abbrev-hceb-expand)
    ("hcec"  "" sp00ky/abbrev-hcec-expand)
    ("hcer"  "" sp00ky/abbrev-hcer-expand)
    ("hceru" "" sp00ky/abbrev-hceru-expand)
    ("hdfn"  "" sp00ky-skeleton/c-hdfn)
    ("cdfn"  "" sp00ky-skeleton/c-cdfn)
    ("heb"   "" sp00ky-skeleton/heb-expansion)
    ("heba"  "" sp00ky/abbrev-heba-expand)
    ("hec"   "" sp00ky-skeleton/hec-expansion)
    ("heca"  "" sp00ky/abbrev-hec-expand)
    ("her"   "" sp00ky-skeleton/her-expansion)
    ("hera"  "" sp00ky/abbrev-her-expand)
    ("heru"  "" sp00ky-skeleton/heru-expansion)
    ("herua" "" sp00ky/abbrev-heru-expand)
    ("hld"   "" sp00ky-skeleton/hld-expansion)
    ("hli"   "" sp00ky-skeleton/hli-expansion)
    ("hle"   "" sp00ky-skeleton/hle-expansion)
    ("inc"   "" sp00ky-skeleton/c-include)
    ("scdfn" "" sp00ky-skeleton/c-static-cncore-dfn)
    ("sdfn"  "" sp00ky-skeleton/c-sdfn)
    ("shdfn" "" sp00ky-skeleton/c-static-hal-dfn)
    ("tenu"  "" sp00ky-skeleton/c-tenu)
    ("whi"   "" sp00ky-skeleton/c-whi)

    ("cs"    "CnCoreStatus"               sp00ky/do-not-insert-space-after-abbrev)
    ("css"   "CnCoreStatus cnStatus"      sp00ky/do-not-insert-space-after-abbrev)
    ("csg"   "CnCoreStatus_GenericError"  sp00ky/do-not-insert-space-after-abbrev)
    ("cso"   "CnCoreStatus_Ok"            sp00ky/do-not-insert-space-after-abbrev)
    ("hs"    "HalStatus"                  sp00ky/do-not-insert-space-after-abbrev)
    ("hsd"   "HalStatus_DriverError"      sp00ky/do-not-insert-space-after-abbrev)
    ("hse"   "HalStatus_Error"            sp00ky/do-not-insert-space-after-abbrev)
    ("hsf"   "HalStatus_Failure"          sp00ky/do-not-insert-space-after-abbrev)
    ("hsi"   "HalStatus_InvalidParameter" sp00ky/do-not-insert-space-after-abbrev)
    ("hsm"   "HalStatus_MemAllocError"    sp00ky/do-not-insert-space-after-abbrev)
    ("hss"   "HalStatus status"           sp00ky/do-not-insert-space-after-abbrev)
    ("hso"   "HalStatus_Ok"               sp00ky/do-not-insert-space-after-abbrev)
    ("rcs"   "return CnCoreStatus_"       sp00ky/do-not-insert-space-after-abbrev)
    ("rcso"  "return CnCoreStatus_Ok;"    sp00ky/do-not-insert-space-after-abbrev)
    ("rhs"   "return HalStatus_"          sp00ky/do-not-insert-space-after-abbrev)
    ("rhso"  "return HalStatus_Ok;"       sp00ky/do-not-insert-space-after-abbrev)
    ("rhsf"  "return HalStatus_Failure;"  sp00ky/do-not-insert-space-after-abbrev)
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
