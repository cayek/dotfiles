(after! org-roam

  (setq org-roam-db-node-include-function
      (lambda ()
        (and
         (not (member "ATTACH" (org-get-tags)))
         (not (member "EXPE" (org-get-tags)))
         (not (member "NOROAM" (org-get-tags)))
         )))
  (setq roam-user "cayek"
        roam-email "kc@caye.fr"
        org-roam-directory "~/plain/"
        org-roam-capture-ref-templates
        '(("r" "ref" plain "%?" :if-new
           (file+head "org/torefile/${slug}.org" "#+title: ${title}\n\n* Links")
           :unnarrowed t))
        org-roam-capture-templates '(("d" "default" plain "%?" :target
                                      (file+head "org/torefile/${slug}.org" "#+title: ${title}\n\n* Links")
                                      :unnarrowed t))

        org-roam-node-display-template "${title:*} ${tags:20}"
        +org-roam-open-buffer-on-find-file nil
        org-roam-file-exclude-regexp ".*stversions.*"
        org-roam-list-files-commands '(fd fdfind rg)
        )

  ;; from https://babbagefiles.xyz/org-roam-auto-propertise/
  (defun my/add-other-auto-props-to-org-roam-properties ()
    ;; if the file already exists, don't do anything, otherwise...
    (unless (file-exists-p (buffer-file-name))
      ;; if there's also a CREATION_TIME property, don't modify it
      (unless (org-find-property "CREATED")
              (org-set-property "CREATED" (format-time-string "[%Y-%m-%d %H:%M]")))
      ))

  ;; Hook to be run whenever an org-roam capture completes
  (add-hook 'org-roam-capture-new-node-hook #'my/add-other-auto-props-to-org-roam-properties)

  ;; add category to org roam nodes
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (let ((cat (cdr (assoc "CATEGORY"  (org-roam-node-properties node)))))
      (if cat
          (upcase cat)
        (upcase "node")
        )
      ))
  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

  )

