(after! org
  (require 'org-protocol-capture-html)
  (setq org-attach-use-inheritance t)
  (setq org-startup-with-inline-images 'nil)
  (setq org-image-actual-width 400)
  (setq org-default-properties (append (list "ROAM_REFS" "AUTHOR" "MONTANT") org-default-properties))
  (setq org-startup-folded t)
  (setq org-log-done 'time)
  (setq org-directory "~/plain/org")
  (setq org-attach-directory "~/plain/org/.attach")
  (setq org-id-locations-file "~/plain/.orgids")
  (setq org-refile-targets '((nil :maxlevel . 2)
                              (org-agenda-files :maxlevel . 2)))
  (setq org-use-property-inheritance t)
  (setq my/org-inbox-file (concat org-directory "/inbox/inbox.org"))
  (setq my/orgzly-inbox-file (concat org-directory "/inbox/orgzly_inbox.org"))
  (setq my/org-pocket-file (concat org-directory "/inbox/pocket.org"))
  (setq my/org-timmi-file (concat org-directory "/pro/timmi/2022_timmi.org"))

  (setq org-archive-location "%s_archive::")
  ;; capture templates
  (setq org-capture-templates
        (quote (("j" "journal" entry (file+datetree my/org-inbox-file)
                 "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n")
                ("g" "messsage" entry (file+datetree my/org-inbox-file)
                 "* %? \n:PROPERTIES:\n:CATEGORY: msg\n:CREATED: %U\n:END:\n\n\n")
                ("n" "note" entry (file+datetree my/org-inbox-file)
                 "* %? \n:PROPERTIES:\n:CATEGORY: note \n:CREATED: %U\n:END:\n\n\n")
                ("m" "in a Meeting" entry (file+datetree my/org-inbox-file)
                 "* meeting with %? \n:PROPERTIES:\n:CATEGORY: meeting\n:CREATED: %U\n:END:\n:LOGBOOK:\n:END:\n"
                 :clock-in t :clock-resume t)
                ("z" "task" entry (file+datetree my/org-inbox-file)
                 "* %? \n:PROPERTIES:\n:CATEGORY: task\n:CREATED: %U\n:END:\n"
                 :clock-in t :clock-resume t)
                ("t" "TODO" entry (file+datetree my/org-inbox-file)
                 "* TODO %? \n:PROPERTIES:\n:CATEGORY: task\n:CREATED: %U\n:END:\n")
                ("T" "Timmi" entry (file+datetree my/org-timmi-file)
                 "* %u \n:PROPERTIES:\n:TIME_SPENT: %? \n:END:\n")
                ("k" "to clock" entry (clock)
                 "* %U %a\n %?\n\n%:initial")
                ("w" "At work" entry (file+datetree my/org-inbox-file)
                 "* %? :probayes: \n:PROPERTIES:\n:s: velotaf\n:k: 32\n:t: 90\n:DATE: %u\n:END:\n"
                 :clock-in t :clock-resume t)
                ("b" "bookmark" entry (file+datetree my/org-inbox-file)
                 "* %a\n:PROPERTIES:\n:CREATED: %U\n:CATEGORY: bookmark\n:END:\n%?")
                ("p" "pocket" entry (file+datetree my/org-pocket-file)
                 "* TODO %a\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")
                ("s" "sport" entry (file+datetree my/org-inbox-file)
                 "* %? :sport: \n:PROPERTIES:\n:s: 0\n:k: 0\n:t: 0\n:i: 0\n:d: 0\n:DATE: %u\n:END:\n")
                ("W" "Web site" entry
                 (file+datetree my/org-inbox-file)
                 "* %a :website:\n\n%U %?\n\n%:initial")
                )))

  ;; my org agenda files
  (setq org-agenda-files
        (list
          "~/plain/inbox/mobile_inbox.org"
          "~/plain/inbox/orgzly_inbox.org"
          "~/plain/inbox/web.org"
          my/org-inbox-file
          "~/plain/inbox/2021_inbox.org"
          )
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

