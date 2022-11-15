;;; org.el --- Description -*- lexical-binding: t; -*-

(after! org
  (setq org-startup-folded 'showeverything)
  )

;; TODO setup org download: this setup work ?
(after! org-download
  (setq org-download-method 'directory)
  (setq-default org-download-image-dir "."))

;; TODO make this function open un chromuim broser orgmode hyperlink
(defun browse-url-at-point-chromium (&optional ARG)
  (interactive)
  (let ((url (browse-url-url-at-point)))
    (if url
    (browse-url-chromium url ARG)
      (error "No URL found"))))
