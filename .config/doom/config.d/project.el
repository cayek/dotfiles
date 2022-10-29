;;; ../../dotfiles2/.config/doom/config.d/project.el -*- lexical-binding: t; -*-

;; see https://docs.projectile.mx/projectile/usage.html
(after! projectile
  (setq projectile-project-search-path '("~/dotfiles2/" ("~/plain" . 4) ("~/projects" . 3)))
  (projectile-discover-projects-in-search-path)
  )
