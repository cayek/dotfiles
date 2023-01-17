;;; org.el --- Description -*- lexical-binding: t; -*-

(after! org
  (setq org-startup-folded 'showeverything)
  ;; use `firefox` to open PDF file: link
  (add-to-list 'org-file-apps '("\\.djvu\\'" . "okular %s"))
  (add-to-list 'org-file-apps '("\\.epub\\'" . "okular %s"))
  )

;; TODO setup org download: this setup work ?
(setq-default org-download-image-dir "~/plain/data/s/")
(setq-default org-download-method 'directory)
(setq-default org-download-heading-lvl nil)
(after! org-download
  (setq org-download-method 'directory)
  (setq org-download-image-dir "~/plain/data/s/")
  (setq org-download-heading-lvl nil)
  (setq org-download-link-format "[[file:s/%s]]\n")
  )

;; TODO make this function open un chromuim broser orgmode hyperlink
(defun browse-url-at-point-chromium (&optional ARG)
  (interactive)
  (let ((url (browse-url-url-at-point)))
    (if url
    (browse-url-chromium url ARG)
      (error "No URL found"))))
