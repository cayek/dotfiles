(after! org
  (require 'mpv)
  (org-link-set-parameters "mpv" :follow #'mpv-play)
  (defun org-mpv-complete-link (&optional arg)
    (replace-regexp-in-string
     "file:" "mpv:"
     (org-link-complete-file arg)
     t t))
        )
