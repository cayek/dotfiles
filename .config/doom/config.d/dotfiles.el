
;; TODO to remove, i do not do lake that anymore
(defun my/dot-update ()
  (interactive)

  (let* ((output-buffer (generate-new-buffer "*my/dot-update output*")))
    (+popup-buffer output-buffer)
    (async-shell-command
     "sudo apt updade; sudo apt upgrade -y; guix pull; ~/.emacs.d/bin/doom sync -u"
     output-buffer)
    )
  )

(defun my/dot-pull ()
  (interactive)
  (let* ((output-buffer (generate-new-buffer "*my/dot-pull output*")))
    (+popup-buffer output-buffer)
    (async-shell-command "cd ~/.tmux/; git pull --no-edit; cd ~/.emacs.d/; git pull upstream develop --no-edit; cd ~/dotfiles/elisp/org-roam/; git pull upstream master --no-edit"
                         output-buffer)
    )
  )
