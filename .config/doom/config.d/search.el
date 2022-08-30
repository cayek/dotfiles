;; TODO why it does work in :config ?
(setq google-translate-translation-directions-alist
      '(("en" . "fr") ("fr" . "en"))
      google-translate-backend-method 'curl
      google-translate-default-source-language "en"
      google-translate-default-source-language "fr")

(use-package! google-translate
  :bind ("C-c t" . google-translate-smooth-translate)
  :config
  (require 'google-translate-smooth-ui)
  )

(after! google-translate-tk
  ;; NOTE: https://github.com/syl20bnr/spacemacs/commit/236eb94320748e6232317c1bd10a92c35008966d
  (defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
  )

;; (use-package! emacs-devdocs-browser
;;   :custom
;;   (devdocs-browser-cache-directory "~/.emacs.d/.local/cache/emacs-devdocs-browser")
;;   :bind ("C-c v" . devdocs-browser-open))

;; (use-package! engine-mode
;;   :config
;;   (engine/set-keymap-prefix (kbd "C-c s"))
;;   ;; (setq engine/browser-function 'eww-browse-url)
;;   (defengine amazon
;;     "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=%s"
;;     :keybinding "a")
;;   (defengine duckduckgo
;;     "https://duckduckgo.com/?q=%s"
;;     :keybinding "k")
;;   (defengine github
;;     "https://github.com/search?ref=simplesearch&q=%s"
;;     :keybinding "g")
;;   (defengine qwant
;;     "https://www.qwant.com/?q=%s"
;;     :docstring "😍😍"
;;     :keybinding "q")
;;   (defengine rfcs
;;     "http://pretty-rfc.herokuapp.com/search?q=%s"
;;     :keybinding "r")
;;   (defengine stack-overflow
;;     "https://stackoverflow.com/search?q=%s"
;;     :keybinding "s")
;;   (defengine twitter
;;     "https://twitter.com/search?q=%s"
;;     :keybinding "t")
;;   (defengine wolfram-alpha
;;     "http://www.wolframalpha.com/input/?i=%s"
;;     :keybinding "w")
;;   (defengine youtube
;;     "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
;;     :keybinding "y")

;;   (defengine google-images
;;     "http://www.google.com/images?hl=en&source=hp&biw=1440&bih=795&gbv=2&aq=f&aqi=&aql=&oq=&q=%s"
;;     :keybinding "/i")
;;   (defengine google-maps
;;     "http://maps.google.com/maps?q=%s"
;;     :docstring "Mappin' it up."
;;     :keybinding "/m")
;;   (defengine google
;;     "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
;;     :keybinding "//")

;;   (defengine devdocs
;;     "https://devdocs.io/#q=%s"
;;     :keybinding "dd")


;;   (engine-mode 1))



;; (after! hydra
;;   (defhydra hydra-search-menu (:color pink
;;                                :hint nil

;;                                )

;;     "
;; ^Online Search^
;; ^^^^^^^^-------------                     (__)
;; _//_: google                              (oo)
;; _/i_: google image                    /------\\/
;; _/m_: google map                     / |    ||
;; _dd_: DevDocs.io                    *  /\\---/\\
;; _g_: github                           ~~   ~~
;; "
;;     ("//" (lambda () (interactive)
;;             (call-interactively #'engine/search-google)
;;             ) :exit t)
;;     ("/i" (lambda () (interactive)
;;             (call-interactively #'engine/search-google-images)
;;             ) :exit t)
;;     ("/m" (lambda () (interactive)
;;             (call-interactively #'engine/search-google-maps)
;;             ) :exit t)
;;     ("dd" (lambda ()
;;             (interactive)
;;             (call-interactively #'engine/search-devdocs)
;;             ) :exit t)
;;    ("g" (lambda ()
;;             (interactive)
;;             (call-interactively #'engine/search-github)
;;             ) :exit t)
;;     ("q" nil "quit hydra")
;;     )
;;   )

;; (defun my/online-search ()
;;   (+workspace-switch "search" t)
;;   (eww "https://google.com")
;;   (doom/window-maximize-buffer)
;;   (hydra-search-menu/body)
;;   ;; (call-interactively (doom-lookup-key (kbd "C-c s")))
;;   ;; (delete-frame)
;;   )

;; (defun my/search ()
;;   (interactive)

;;   (with-current-buffer (get-buffer-create "*alfred*")
;;   (let ((frame (make-frame '((name . "search")
;;                              (window-system . x)
;;                              (auto-raise . t) ; focus on this frame
;;                              (height . 10)
;;                              (internal-border-width . 20)
;;                              (left . 0.33)
;;                              (left-fringe . 0)
;;                              (line-spacing . 3)
;;                              (menu-bar-lines . 0)
;;                              (right-fringe . 0)
;;                              (tool-bar-lines . 0)
;;                              (top . 48)
;;                              (undecorated . nil) ; enable to remove frame border
;;                              (unsplittable . t)
;;                              (vertical-scroll-bars . nil)
;;                              ;; (minibuffer . only)
;;                              (width . 110))))
;;         ;; (alert-hide-all-notifications t)
;;         ;; (inhibit-message t)
;;         ;; (mode-line-format nil)
;;         (search-engine (completing-read "Search-engine: " '("google" "github"))))
;;     (delete-frame frame)
;;     ;; If we don't kill the buffer it messes up future state.
;;     (kill-buffer "*search*")
;;     ;; I don't want this to cause the main frame to flash
;;     (x-urgency-hint (selected-frame) nil))))

;; (defun md/alfred ()
;;   (interactive)
;;   (with-current-buffer (get-buffer-create "*alfred*")
;;     (let ((frame (make-frame '((name . "alfred")
;;                                (window-system . x)
;;                                (auto-raise . t) ; focus on this frame
;;                                (height . 10)
;;                                (internal-border-width . 20)
;;                                (left . 0.33)
;;                                (left-fringe . 0)
;;                                (line-spacing . 3)
;;                                (menu-bar-lines . 0)
;;                                (right-fringe . 0)
;;                                (tool-bar-lines . 0)
;;                                (top . 48)
;;                                (undecorated . nil) ; enable to remove frame border
;;                                (unsplittable . t)
;;                                (vertical-scroll-bars . nil)
;;                                (width . 110))))
;;           (alert-hide-all-notifications t)
;;           (inhibit-message t)
;;           (mode-line-format nil)
;;           (helm-mode-line-string nil)
;;           (helm-full-frame t)
;;           (helm-display-header-line nil)
;;           (helm-use-undecorated-frame-option nil))
;;       (helm :sources (list (md/alfred-source-system)
;;                            (md/alfred-source-apps)
;;                            (md/alfred-source-search))
;;             :prompt ""
;;             :buffer "*alfred*")
;;       (delete-frame frame)
;;       ;; If we don't kill the buffer it messes up future state.
;;       (kill-buffer "*alfred*")
;;       ;; I don't want this to cause the main frame to flash
;;       (x-urgency-hint (selected-frame) nil))))
