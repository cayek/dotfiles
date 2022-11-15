(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((org-image-actual-width)
     (eval add-hook 'after-save-hook
      (lambda nil
        (org-babel-tangle))
      nil t)
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")
     (org-use-tag-inheritance . t)
     (ispell-dictionary . "fr")
     (org-attach-use-inheritance . t)
     (org-attach-use-inheritance)
     (org-roam-db-update-on-save)))
 '(warning-suppress-log-types '((org-element-cache) (org-element-cache) (defvaralias)))
 '(warning-suppress-types '((org-element-cache) (defvaralias))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
