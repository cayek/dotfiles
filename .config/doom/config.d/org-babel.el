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
