;;; org.el --- Description -*- lexical-binding: t; -*-

(after! org
  (setq org-startup-folded 'showeverything)
  )

;; TODO setup org download: this setup work ?
(setq-default org-download-image-dir "~/plain/data/s/")
(setq-default org-download-method 'directory)
(after! org-download
  (setq org-download-method 'directory)
  (setq org-download-image-dir "~/plain/data/s/")
  (setq org-download-link-format "[[file:s/%s]]\n")
  )

;; TODO make this function open un chromuim broser orgmode hyperlink
(defun browse-url-at-point-chromium (&optional ARG)
  (interactive)
  (let ((url (browse-url-url-at-point)))
    (if url
    (browse-url-chromium url ARG)
      (error "No URL found"))))
