;;; org-export.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Kevin caye
;;
;; Author: Kevin caye <kevin.caye@probayes.com>
;; Maintainer: Kevin caye <kevin.caye@probayes.com>
;; Created: juillet 04, 2022
;; Modified: juillet 04, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/kcaye/org-export
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(after! org
  (setq org-export-with-toc nil
        org-export-babel-evaluate nil
        org-export-with-sub-superscripts nil)
  )

(provide 'org-export)
;;; org-export.el ends here
