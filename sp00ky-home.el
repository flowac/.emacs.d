;; Config specific to home

;; Set up bcf mode
(load (sp00ky/set-init-file-path "bcf-index.el"))
(add-to-list 'auto-mode-alist '("keywordIndex\\.txt\\'" . bcf-index-mode))
(add-to-list 'auto-mode-alist '("topicalIndex\\.txt\\'" . bcf-index-mode))
(add-to-list 'auto-mode-alist '("questionIndex\\.txt\\'" . bcf-index-mode))

;; Useful so we can easily grab the emacs frame from xdotool
(set-frame-name "emacs@sp00ky")

;; See info node for elisp `frame parameters'. Essentially will make
;; the frame take up half the window.
(add-to-list 'default-frame-alist '(width  . 0.5))
(add-to-list 'default-frame-alist '(height . 1.0))

;; Not sure why I added this. To be removed.
(setq org-format-latex-header
"\\documentclass[fleqno]{article}
\\usepackage[usenames]{color}
[PACKAGES]
[DEFAULT-PACKAGES]
\\pagestyle{empty}             % do not remove
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}")
