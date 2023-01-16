(after! org
  (require 'org-protocol-capture-html)
  (setq org-attach-use-inheritance t)
  (setq org-startup-with-inline-images 'nil)
  (setq org-image-actual-width t)
  (setq org-default-properties (append (list "ROAM_REFS" "AUTHOR" "MONTANT") org-default-properties))
  (setq org-startup-folded t)
  (setq org-log-done 'time)
  (setq org-directory "~/plain/")
  (setq org-attach-directory "~/plain/org/.attach")
  (setq org-id-locations-file "~/plain/org/.orgids")
  (setq org-refile-targets '((nil :maxlevel . 2)
                              (org-agenda-files :maxlevel . 2)))
  (setq org-use-property-inheritance t)
  (setq my/org-inbox-file "~/plain/org/00_INBOX.org")

  (setq org-archive-location "%s_archive::")
  ;; capture templates
  (setq org-capture-templates
        (quote (("j" "journal" entry (file my/org-inbox-file)
                 "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n")
                ("m" "in a Meeting" entry (file my/org-inbox-file)
                 "* meeting with %? \n:PROPERTIES:\n:CATEGORY: meeting\n:CREATED: %U\n:END:\n:LOGBOOK:\n:END:\n"
                 :clock-in t :clock-resume t)
                ("t" "TODO" entry (file+datetree my/org-inbox-file)
                 "* TODO %? \n:PROPERTIES:\n:CATEGORY: task\n:CREATED: %U\n:END:\n")
                ("k" "to clock" entry (clock)
                 "* %U %a\n %?\n\n%:initial")
                ("W" "Web site" entry
                 (file my/org-inbox-file)
                 "* %a :website:\n\n%U %?\n\n%:initial")
                )))

  ;; my org agenda files
  (setq org-agenda-files
        (directory-files "~/plain/org" t "\\.org$")
        )

  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))

  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  (setq org-log-state-notes-into-drawer t)

  (setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "MAYBE(y)")
        (sequence "WAITING(w)" "HOLD(h)" "|" "DONE(d)" "CANCELLED(c)")
        (sequence "TODO(t)" "RUNNING(r)" "|" "DONE(d)" "CANCELLED(c)")
        )
        )

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold)
                ("NOTE" :foreground "forest green" :weight bold)
                ("MAYBE" :foreground "yellow" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))

  (setq org-agenda-custom-commands
        '(
          ("n" "Agenda and all TODOs"
           ((agenda "")
            (alltodo "")))
          ("m" "30 days works review"
           agenda ""
           (
            (org-agenda-span 30)
            (org-agenda-start-day (org-today))
            (org-agenda-tag-filter-preset '("+probayes"))
            ))
          ("d" "Today review"
           agenda ""
           (
            (org-agenda-span 1)
            (org-agenda-start-day (org-today))
            (org-agenda-start-with-log-mode t)
            (org-agenda-start-with-log-mode '(clock))
            (org-agenda-start-with-clockreport-mode t)
            ))))

  )

;; for +org-capture/open-frame
(setq +org-capture-frame-parameters '((name . "i3-org-capture")
                                     (width . 100)
                                     (height . 40)
                                     (transient . t)))

;; org capture here
(defun my/org-capture-here ()
  (interactive)
  (let* ((current-file-name (buffer-file-name))
         (my/org-inbox-file (if (string-match-p
                                 ".*\\.org\\|.*org\\.gpg"
                                 current-file-name)
                                buffer-file-name
                              my/org-inbox-file
                              )))
    (org-capture)))

(map! :leader
      :desc "Go to last capature"     "n N"    #'org-capture-goto-last-stored
      :desc "Capture here"     "n h"    #'my/org-capture-here
      )


(defun my/org-open-inbox ()
  (interactive)
  (find-file my/org-inbox-file))

(map! :leader
       :desc "Open org inbox"     "n i"    #'my/org-open-inbox)

