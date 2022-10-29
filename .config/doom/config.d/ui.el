(after! persp-mode
  (remove-hook 'persp-add-buffer-on-after-change-major-mode-filter-functions #'doom-unreal-buffer-p) ;; include temporary buffers in the current workspace
  (setq persp-emacsclient-init-frame-behaviour-override "main") ;; avoid create anonymous workspace when create new frame
  ;; (setq persp-mode nil) ;; TODO do not save workspace on exit
  (setq persp-auto-save-opt 0) ;; do not save workspace on exit
)

(map! (:when (featurep! :ui popup)
       "C-<"   #'+popup/toggle
       "C-é"   #'+popup/raise
       "C-x p" #'+popup/other)

      (:when (featurep! :ui workspaces)

        :leader
        (:prefix-map ("TAB" . "workspace")
        :desc "Display tab bar"           "TAB" #'+workspace/display
        :desc "Switch to last workspace"          "a"   #'+workspace/other
        :desc "Search workspace"          "z"   #'+workspace/switch-to
        ;; for azerty keyboard
        :desc "Switch to worspace 0"          "&"   #'+workspace/switch-to-0
        :desc "Switch to workspace 1"          "é"   #'+workspace/switch-to-1
        :desc "Switch to worspace 2"          "\""   #'+workspace/switch-to-2
        :desc "Switch to worspace 3"          "'"   #'+workspace/switch-to-3
        :desc "Switch to worspace 4"          "("   #'+workspace/switch-to-4
        :desc "Switch to worspace 5"          "-"   #'+workspace/switch-to-5
        :desc "Switch to worspace 6"          "è"   #'+workspace/switch-to-6
        :desc "Switch to worspace 7"          "_"   #'+workspace/switch-to-7

        )

        ))

;;
;;; <leader>
(map! :leader
      (:when (featurep! :ui popup)
       :desc "Toggle last popup"     "é"    #'+popup/toggle)
      (:when (featurep! :ui workspaces)
      :desc "Switch to last buffer" "&"    #'evil-switch-to-windows-last-buffer))

;; windows
(define-key evil-window-map (kbd "<right>") 'evil-window-right)
(define-key evil-window-map (kbd  "<left>") 'evil-window-left)
(define-key evil-window-map (kbd "<up>") 'evil-window-up)
(define-key evil-window-map (kbd "<down>") 'evil-window-down)

;; frame
(global-set-key (kbd "s-!") 'delete-frame)
(global-set-key [remap delete-frame] #'delete-frame)

;; change default projectile spc p p to search to project without create workspace
;; keep spc p P seach project and create workspace
(defun my/projectile-switch-project (&optional arg)
  (interactive "P")
  (let ((projectile-switch-project-action #'projectile-find-file))
    (projectile-switch-project arg)
    )
  )
(map! :leader
       :desc "swith to project here"     "p P"    #'my/projectile-switch-project)

(set-popup-rules!
 '(("^\\*Completions" :ignore t)
   ("^\\*Local variables\\*$"
    :vslot -1 :slot 1 :size +popup-shrink-to-fit)
   ("^\\*\\(?:[Cc]ompil\\(?:ation\\|e-Log\\)\\|Messages\\)"
    :vslot -2 :size 0.3  :autosave t :quit t :ttl nil)
   ("^\\*\\(?:doom \\|Pp E\\)"  ; transient buffers (no interaction required)
    :vslot -3 :size +popup-shrink-to-fit :autosave t :select ignore :quit t :ttl 0)
   ("^\\*doom:"  ; editing buffers (interaction required)
    :vslot -4 :size 0.35 :autosave t :select t :modeline t :quit nil :ttl t)
   ("^\\*doom:\\(?:v?term\\|e?shell\\)-popup"  ; editing buffers (interaction required)
    :vslot -5 :size 0.35 :select t :modeline nil :quit nil :ttl nil)
   ("^\\*\\(?:Wo\\)?Man "
    :vslot -6 :size 0.45 :select t :quit t :ttl 0)
   ("^\\*Calc"
    :vslot -7 :side bottom :size 0.4 :select t :quit nil :ttl 0)
   ("^\\*Customize"
    :slot 2 :side right :size 0.5 :select t :quit nil)
   ("^ \\*undo-tree\\*"
    :slot 2 :side left :size 20 :select t :quit t)
   ;; `help-mode', `helpful-mode'
   ("^\\*\\([Hh]elp\\|Apropos\\)"
    :slot 2 :vslot -8 :size 0.42 :select t)
   ("^\\*eww\\*"  ; `eww' (and used by dash docsets)
    :vslot -11 :size 0.35 :select t)
   ("^\\*xwidget"
    :vslot -11 :size 0.35 :select nil)
   ("^\\*info\\*$"  ; `Info-mode'
    :slot 2 :vslot 2 :size 0.45 :select t))

 '(("^\\*Warnings" :vslot 99 :size 0.25)
   ("^\\*Backtrace" :vslot 99 :size 0.4 :quit nil)
   ("^\\*CPU-Profiler-Report "    :side bottom :vslot 100 :slot 1 :height 0.4 :width 0.5 :quit nil)
   ("^\\*Memory-Profiler-Report " :side bottom :vslot 100 :slot 2 :height 0.4 :width 0.5 :quit nil)
   ("^\\*Process List\\*" :side bottom :vslot 101 :size 0.25 :select t :quit t)
   ("^\\*\\(?:Proced\\|timer-list\\|Abbrevs\\|Output\\|Occur\\)\\*" :ignore t)))
