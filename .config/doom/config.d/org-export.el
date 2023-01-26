;;; org-export.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Kevin caye
;;
;; Author: Kevin caye <kevin@caye.fr>
;; Maintainer: Kevin caye <kevin@caye.fr>
;; Created: juillet 04, 2022
;; Modified: juillet 04, 2022
;; Version: 0.0.1
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
