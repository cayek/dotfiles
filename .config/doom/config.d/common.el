;;; common.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Kevin caye
;;
;; Author: Kevin caye <kevin@caye.fr>
;; Maintainer: Kevin caye <kevin@caye.fr>
;; Created: juin 30, 2022
;; Modified: juin 30, 2022
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

;; (use-package eaf
;;   :load-path "~/.config/emacs/.local/straight/repos/emacs-application-framework/"
;;   :custom
;;   ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
;;   (eaf-browser-continue-where-left-off t)
;;   (eaf-browser-enable-adblocker t)
;;   (browse-url-browser-function 'eaf-open-browser)
;;   :config
;;   (defalias 'browse-web #'eaf-open-browser)
;;   (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;   (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki
;; (require 'eaf)
;; (require 'eaf-browser)

(after! org-src
  (require 'ob-jupyter)
  (defalias 'org-babel-execute:my 'org-babel-execute:jupyter-python)
  (defalias 'org-babel-load-session:my 'org-babel-load-session:jupyter-python)
  (defalias 'org-babel-edit-prep:my 'org-babel-edit-prep:jupyter-python)
  (defalias 'org-babel-expand-body:my 'org-babel-expand-body:jupyter-python)
  (defalias 'org-babel-my-initiate-session
    'org-babel-jupyter-python-initiate-session)
  (add-to-list 'org-src-lang-modes '("my" . python))
  (setq org-babel-default-header-args:my '((:async . "yes")
                                           (:session . "my")
                                           (:kernel . "my")
                                           ))
  )

(defun run-in-vterm-kill (process event)
  "A process sentinel. Kills PROCESS's buffer if it is live."
  (let ((b (process-buffer process)))
    (and (buffer-live-p b)
         (kill-buffer b))))

(defun run-in-vterm (command)
  "Execute string COMMAND in a new vterm.

Interactively, prompt for COMMAND with the current buffer's file
name supplied. When called from Dired, supply the name of the
file at point.

Like `async-shell-command`, but run in a vterm for full terminal features.

The new vterm buffer is named in the form `*foo bar.baz*`, the
command and its arguments in earmuffs.

When the command terminates, the shell remains open, but when the
shell exits, the buffer is killed."
  (interactive
   (list
    (let* ((f (cond (buffer-file-name)
                    ((eq major-mode 'dired-mode)
                     (dired-get-filename nil t))))
           (filename (concat " " (shell-quote-argument (and f (file-relative-name f))))))
      (read-shell-command "Terminal command: "
                          (cons filename 0)
                          (cons 'shell-command-history 1)
                          (list filename)))))
  (with-current-buffer (vterm (concat "*" command "*"))
    (set-process-sentinel vterm--process #'run-in-vterm-kill)
    (vterm-send-string command)
    (vterm-send-return)))

(after! vterm
  (setq vterm-buffer-name "*vterm*")
  )

(use-package ob-tmux
  ;; Install package automatically (optional)
  :ensure t
  :custom
  (org-babel-default-header-args:tmux
   '((:results . "silent")	;
     (:session . "default")	; The default tmux session to send code to
     (:socket  . nil)))		; The default tmux socket to communicate with
  ;; The tmux sessions are prefixed with the following string.
  ;; You can customize this if you like.
  (org-babel-tmux-session-prefix "ob-")
  ;; The terminal that will be used.
  ;; You can also customize the options passed to the terminal.
  ;; The default terminal is "gnome-terminal" with options "--".
  (org-babel-tmux-terminal nil)
  (org-babel-tmux-terminal-opts '("-T" "ob-tmux" "-e"))
  ;; Finally, if your tmux is not in your $PATH for whatever reason, you
  ;; may set the path to the tmux binary as follows:
  (org-babel-tmux-location "/usr/bin/tmux"))

;; (set-popup-rules!
;;   `(("^\\*sh-" :size 0.3 :ttl 0)))

;; (use-package! detached
;;   :hook (after-init . detached-setup)
;;   :bind (([remap async-shell-command] . detached-shell-command)))

;; (use-package! detached-consult
;;   :after detached
;;   :bind ([remap detached-open-session] . detached-consult-session)
;;   )

;; (after! detached
;;   (global-set-key (kbd "C-c d") detached-action-map)
;;   ;; (setq detached-env "~/.emacs.d/.local/straight/repos/detached/detached-env")
;;   (connection-local-set-profile-variables
;;    'remote-detached
;;    '(
;;      (detached-env . "~/bin/detached-env")
;;      (detached-shell-program . "/bin/bash")
;;      (detached-shell-history-file . "~/.bash_history")
;;      (detached-session-directory . "~/tmp")
;;      ;; (detached-dtach-program . "/home/user/.local/bin/dtach")
;;      )
;;    )
;;   )

;; (after! embark
;;   (defvar embark-detached-map (make-composed-keymap detached-action-map embark-general-map))
;;   (add-to-list 'embark-keymap-alist '(detached . embark-detached-map))
;;   )

;; (use-package detached
;;   :init
;;   (detached-init)
;;   :bind (;; Replace `async-shell-command' with `detached-shell-command'
;;          ([remap async-shell-command] . detached-shell-command)
;;          ;; Replace `compile' with `detached-compile'
;;          ;; ([remap compile] . detached-compile)
;;          ;; ([remap recompile] . detached-compile-recompile)
;;          ;; Replace built in completion of sessions with `consult'
;;          ([remap detached-open-session] . detached-consult-session))
;;   :custom ((detached-show-output-on-attach nil)
;;            (detached-notification-function (lambda (session)))))

;; (after! detached
;;   (setq detached-annotation-format
;;         `(
;;           (:width 2 :function detached--duration-str :face detached-duration-face)
;;           (:width 2 :function detached--size-str :face detached-size-face)
;;           (:width 10 :function detached--metadata-str :face detached-metadata-face)
;;           (:width 3 :function detached--state-str :face detached-state-face)
;;           (:width 10 :function detached--host-str :face detached-host-face)
;;           (:width 10 :function detached--working-dir-str :face detached-working-dir-face)
;;           (:width 3 :function detached--status-str :face detached-failure-face)
;;           (:width 12 :function detached--creation-str :face detached-creation-face))
;;   detached-max-command-length 10)

;;   (defun my/detached--session-git-branch ()
;;     "Return current git branch."
;;     (let ((git-directory (locate-dominating-file "." ".git")))
;;       (when git-directory
;;         (let ((args '("name-rev" "--name-only" "HEAD")))
;;           (with-temp-buffer
;;             (apply #'process-file `("git" nil t nil ,@args))
;;             (string-trim (buffer-string)))))))
;;   (setq detached-metadata-annotators-alist '((branch . my/detached--session-git-branch)))
;;   )

(after! org
  (setq org-crypt-key "49604D37526164335E8B1E389ED95088FAEFB05E")
  )

;; from doom config.el
(defmacro doom--if-compile (command on-success &optional on-failure)
  (declare (indent 2))
  `(let ((default-directory doom-emacs-dir))
     (with-current-buffer (compile ,command t)
       (let ((w (get-buffer-window (current-buffer))))
         (select-window w)
         (add-hook
          'compilation-finish-functions
          (lambda (_buf status)
            (if (equal status "finished\n")
                (progn
                  (delete-window w)
                  ,on-success)
              ,on-failure))
          nil 'local)))))

;;;###autoload
(defun my/private-notes-search (query)
  "Perform a text search on `private directory'."
  (interactive
   (list (if (doom-region-active-p)
             (buffer-substring-no-properties
              (doom-region-beginning)
              (doom-region-end))
           "")))
  (let* ((consult-preview-key (kbd "M-RET")))
    (+vertico-file-search :query "" :in "~/plain" :args '("--type" "org"))))


(map! :leader
      "P s" #'my/private-notes-search
      )


(defun my/org-refile-to-datetree (file &optional d)
  (let ((d (or d (calendar-current-date)))
        (p)
        (h))
    (save-excursion
      (with-current-buffer (get-file-buffer file)
        (org-datetree-find-date-create d nil)
        (setq p (point))
        (setq h (nth 4 (org-heading-components)))
        ))
    (org-refile nil nil (list h file nil p) "refile to datetree"))
  )

(defun my/org-refile-to-datetree--from-created (file)
  (if (assoc "CREATED" (org-entry-properties))
     (let* ((d-str (org-entry-get (point) "CREATED"))
            (date-time (if d-str (parse-time-string d-str)))
            (d (list (nth 4 date-time) (nth 3 date-time) (nth 5 date-time)))
           )
       (if d (my/org-refile-to-datetree file d))
     )))

(defun my/org-refile-to-file (file)
  (org-refile nil nil (list nil file nil nil) "refile to datetree")
  )

(after! org-ql
  (setq org-ql-view-display-buffer-action
        '((display-buffer-no-window) (allow-no-window . t))))


(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode)
  )


(defun my/org-roam-files-from-tag (tag)
  (--map (car it) (org-roam-db-query
                   [:select [nodes:file]
                    :from tags
                    :left-join nodes
                    :on (= tags:node-id nodes:id)
                    :where (= tags:tag $s1)]  tag)))

(defun my/org-tags-view-ql ()
  (interactive)
  (require 's)
  (require 'org-ql)
  (require 'org-ql-view)
  (require 'org-roam)
  (require 'dash)
  (let* ((tags (org-roam-tag-completions))
         (tag (completing-read "Tag: " tags))
         (m-tag (--filter (s-contains? tag it) tags))
         (files (-distinct (-concat (my/org-roam-files-from-tag tag) org-agenda-files)))
         (buffer (org-ql-view--buffer (format "*org-ql: %s*" tag)))
         )
    (org-ql-search files (list 'and (push 'tags m-tag) '(not (tags "ARCHIVE")) '(ts))
      :sort '(date)
      :title (format "project: %s" tag)
      :super-groups '((:name "meeting"
                       :auto-ts t)
                      )
      :buffer buffer
      )
    (pop-to-buffer-same-window buffer)
    (goto-char (point-max))
    ))

(defun my/org-tags-view ()
  (interactive)
  (let ((org-super-agenda-groups '((
                                    :auto-ts t)
                                   ))
        )
    (org-tags-view)))

;; from https://emacs.stackexchange.com/questions/14025/how-to-get-todays-total-logged-time-programatically
(defun my/org-clock-sum-today (&optional HEADLINE-FILTER)
  "Visit each file in `org-agenda-files' and return the total time of today's
clocked tasks in minutes."
  (let ((files (org-agenda-files))
        (total 0))
    (org-agenda-prepare-buffers files)
    (dolist (file files)
      (with-current-buffer (find-buffer-visiting file)
        (setq total (+ total (org-clock-sum-today)))))
    total))

;;
;;; <leader>
(map! :leader
      (:when (featurep! :lang org )
       (:prefix-map ("n" . "notes")
        :desc "Search with org ql" "q" #'my/org-tags-view-ql
        :desc "Tags search"                    "m" #'my/org-tags-view
       )))

(after! org-duration
  (setq org-duration-units
        `(("min" . 1)
          ("h" . 60)
          ;; seven-hour days
          ("d" . ,(* 60 7))
          ;; five-day work week
          ("w" . ,(* 60 8 5))
          ;; four weeks in a month
          ("m" . ,(* 60 8 5 4))
          ;; work a total of 12 months a year --
          ;; this is independent of holiday and sick time taken
          ("y" . ,(* 60 8 5 4 12))))
)

;; clocking Functions and i3-indicator
(defvar i3-clock-indicator-signal 7)

(defun i3-org-clock-indicator ()
  (if (org-clocking-p) ; check if org-clock is active
      (substring-no-properties (org-clock-get-clock-string))
    (format "🕶 chilling")))

(defun i3-org-clock-today-total ()
  (let* ((total (my/org-clock-sum-today))
         (h (/ total 60))
         (m (mod total 60))
         )
    (s-lex-format "🧐 ${h}:${m}")
    ))

(defun i3-org-clock-indicator-update ()
  (save-buffer)
  (shell-command (format "pkill -SIGRTMIN+%d i3blocks"
                         i3-clock-indicator-signal)))

(after! org-clock
  (add-hook 'org-clock-in-hook 'i3-org-clock-indicator-update)
  (add-hook 'org-clock-out-hook 'i3-org-clock-indicator-update)
  )

(defun my/org-clock-goto ()
  (+workspace-switch "capture" t)
  (org-clock-goto)
  (doom/window-maximize-buffer)
  (org-tree-to-indirect-buffer)
  )


(defun my/org-goto-last-capture ()
  (+workspace-switch "capture" t)
  (org-capture-goto-last-stored)
  (doom/window-maximize-buffer)
  (org-tree-to-indirect-buffer)
  )

(defun my/org-datetree-goto-today ()
    (interactive)
    (org-datetree-find-date-create (calendar-current-date))
    )

(map! :map org-mode-map
      :leader
      :desc "Go to named src block"     "m v g"    #'org-babel-goto-named-src-block
      :desc "Go to today datetree"     "m ;"    #'my/org-datetree-goto-today
      )

(after! ox-latex
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted)

  (setq org-latex-pdf-process
        '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
)

(after! pyvenv
  (defun my/restart-python ()
    (interactive)
    (let ((bw (get-buffer-window)))
      (pyvenv-restart-python)
      (+eval/open-repl-other-window)
      (select-window bw)))

  )


(after! lsp-mode
  (setq lsp-pylsp-plugins-flake8-enabled t
        lsp-pylsp-plugins-autopep8-enabled t
        lsp-diagnostics--flycheck-enabled t
        lsp-ui-doc-enable nil
        lsp-ui-sideline-show-diagnostics nil
        lsp-ui-peek-enable nil
        lsp-signature-render-documentation nil
        ))

(use-package! sphinx-doc
  :hook (python-mode . sphinx-doc-mode))

(setq-default flycheck-disabled-checkers '(c/c++-gcc ))

(after! elfeed
  ;; (require 'feed-setup)
  (setq elfeed-goodies/tag-column-width 25)


  ;; Custom faces

  (defface elfeed-podcast
    '((t :foreground "#3E65EC"))
    "Marks podcasts in Elfeed."
    :group 'elfeed)

  (push '(podcast elfeed-podcast)
        elfeed-search-face-alist)

  (defface elfeed-youtube
    '((t :foreground "#DE166D"))
    "Marks youtube in Elfeed."
    :group 'elfeed)

  (push '(youtube elfeed-youtube)
        elfeed-search-face-alist)

  (defface elfeed-blog
    '((t :foreground "#1AAE2C"))
    "Marks blog in Elfeed."
    :group 'elfeed)

  (push '(blog elfeed-blog)
        elfeed-search-face-alist)

  (defface elfeed-important
    '((t :foreground "#FC0F00"))
    "Marks important entries in Elfeed."
    :group 'elfeed)

  (push '(important elfeed-important)
        elfeed-search-face-alist)

  ;; probably temporary: hack for elfeed-goodies date column:
  (defun elfeed-goodies/search-header-draw ()
    "Returns the string to be used as the Elfeed header."
    (if (zerop (elfeed-db-last-update))
        (elfeed-search--intro-header)
      (let* ((separator-left (intern (format "powerline-%s-%s"
                                             elfeed-goodies/powerline-default-separator
                                             (car powerline-default-separator-dir))))
             (separator-right (intern (format "powerline-%s-%s"
                                              elfeed-goodies/powerline-default-separator
                                              (cdr powerline-default-separator-dir))))
             (db-time (seconds-to-time (elfeed-db-last-update)))
             (stats (-elfeed/feed-stats))
             (search-filter (cond
                             (elfeed-search-filter-active
                              "")
                             (elfeed-search-filter
                              elfeed-search-filter)
                             (""))))
        (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
            (search-header/draw-wide separator-left separator-right search-filter stats db-time)
          (search-header/draw-tight separator-left separator-right search-filter stats db-time)))))

  (defun elfeed-goodies/entry-line-draw (entry)
    "Print ENTRY to the buffer."

    (let* ((title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
           (date (elfeed-search-format-date (elfeed-entry-date entry)))
           (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
           (feed (elfeed-entry-feed entry))
           (feed-title
            (when feed
              (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
           (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
           (tags-str (concat "[" (mapconcat 'identity tags ",") "]"))
           (title-width (- (window-width) elfeed-goodies/feed-source-column-width
                           elfeed-goodies/tag-column-width 4))
           (title-column (elfeed-format-column
                          title (elfeed-clamp
                                 elfeed-search-title-min-width
                                 title-width
                                 title-width)
                          :left))
           (tag-column (elfeed-format-column
                        tags-str (elfeed-clamp (length tags-str)
                                               elfeed-goodies/tag-column-width
                                               elfeed-goodies/tag-column-width)
                        :left))
           (feed-column (elfeed-format-column
                         feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
                                                  elfeed-goodies/feed-source-column-width
                                                  elfeed-goodies/feed-source-column-width)
                         :left)))

      (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
          (progn
            (insert (propertize date 'face 'elfeed-search-date-face) " ")
            (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
            (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
            (insert (propertize title 'face title-faces 'kbd-help title)))
        (insert (propertize title 'face title-faces 'kbd-help title)))))

  (defun my/elfeed-v-mpv (url)
    "Watch a video from URL in MPV"
    (doom--if-compile
     (format "mpv  --ytdl-format=\"bestvideo[height<=360]+bestaudio/best[height<=360]\" \"%s\"; echo \"Done\"" url)
        (message "done")
        )
    )

  (defun my/elfeed-view-mpv (&optional use-generic-p)
    "Youtube-feed link"
    (interactive "P")
    (let ((entries (elfeed-search-selected)))
      (cl-loop for entry in entries
               do (elfeed-untag entry 'unread)
               when (elfeed-entry-link entry)
               do (my/elfeed-v-mpv it))
      (mapc #'elfeed-search-update-entry entries)
      (unless (use-region-p) (forward-line))))

  (when (featurep! :editor evil +everywhere)
    (evil-define-key 'normal elfeed-search-mode-map
      (kbd "o") #'my/elfeed-view-mpv))
  )


(defun my/rss-open ()
  (interactive)
  (require 'elfeed)
  (elfeed)
  )



(map! :leader
      :desc "rss"     "o s"    #'my/rss-open
      )


;; (elfeed-db-size)
;; (elfeed-search--count-unread)
;; (with-elfeed-db-visit (entry _)
;;   (let ((title (elfeed-entry-title entry)))
;;     (print title)
;;     ))

;; (elfeed-entry-title tt)

;; (elfeed-db-get-all-tags)
;; (elfeed-df-)

(after! notmuch
  (setq send-mail-function 'sendmail-send-it
        sendmail-program "/usr/bin/msmtp"
        mail-specify-envelope-from t
        message-sendmail-envelope-from 'header
        mail-envelope-from 'header
        notmuch-fcc-dirs '(("kevin@caye.fr" . "caye/Sent")
                           (".*" . "Sent"))
        notmuch-message-headers-visible t
        +notmuch-home-function (lambda () (notmuch-search "tag:inbox"))
        )

  )

(defun my/mail-open ()
  (interactive)
  (require 'notmuch)
  (notmuch-search "tag:inbox")
  )


(defun my/new-mail ()
  (interactive)
  (notmuch-mua-new-mail t)
  )


(map! :leader
      :desc "mail"     "o m"    #'my/mail-open
      :desc "new mail"     "o c"    #'my/new-mail
      :desc "search mail"     "s m"    #'consult-notmuch
      )
