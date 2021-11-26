;; C-mode abbrevs
(setq skeleton-end-newline nil)
(define-skeleton sp00ky-skeleton/c-if-statement
  "Insert an if statement" nil
  "if (" _ ")" > \n
  "{" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/c-hal-ret-fun
  "Insert a function skeleton that returns HalStatus" nil
  "HalStatus " _ " ()" > \n
  "{" > \n
  "}" >)
(define-skeleton sp00ky-skeleton/skeleton-test
  "Prompt user for input"
  t
  ("Enter test input: " "test: " str \n))

(define-skeleton sp00ky-skeleton/HER-expansion
  "Insert a function skeleton that returns HalStatus" nil
  "HAL_ERR_RET(status, " _ ");")

;(clear-abbrev-table c-mode-abbrev-table)
(define-abbrev-table 'c-mode-abbrev-table
  '(
    ("cif" "" sp00ky-skeleton/c-if-statement)
    ("chf" "" sp00ky-skeleton/c-hal-ret-fun)
    ("cst" "" sp00ky-skeleton/skeleton-test)
    ("hs" "HalStatus")
    ("hso" "HalStatus_Ok")
    ("hse" "HalStatus_Error")
    ("hsi" "HalStatus_InvalidParameter")
    ("hli" "HAL_LOG_INFO")
    ("hle" "HAL_LOG_ERR")
    ("hld" "HAL_LOG_DEBUG")
    ("HER" "" sp00ky-skeleton/HER-expansion)
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
