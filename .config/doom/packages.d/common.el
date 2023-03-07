(package! sxiv)
(package! mpv)
(package! google-translate)
(package! org-web-tools)
(package! youtube-dl :recipe (:host github :repo "skeeto/youtube-dl-emacs"))
(package! realgud-lldb)
(package! ob-tmux)
(package! detached)

;; TODO: clearn not use anymore packages
(package! org-protocol-capture-html :recipe
  (:host github
   :repo "alphapapa/org-protocol-capture-html"
   :files ("*.el")))
(package! org-super-agenda)
(package! org-ql)
(package! org-web-tools)
(package! ol-notmuch)
(package! orgtbl-aggregate :recipe (:host github :repo "tbanel/orgaggregate"))
(package! sphinx-doc)
(package! elgantt :recipe (:host github :repo "legalnonsense/elgantt"))

;; (package! lsp-ltex :recipe (:host github
;;    :repo "emacs-languagetool/lsp-ltex"
;;    :files ("*.el")))

(package! ox-gfm)
