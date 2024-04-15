;; -*- lexical-binding: t -*-

(use-package projectile
  :straight t
  :init
  (projectile-mode)
  :config
  (setq projectile-cache-file (concat dotemacs-cache-directory "projectile.cache"))
  (setq projectile-known-projects-file (concat dotemacs-cache-directory "projectile-bookmarks.eld"))
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t)
  (setq projectile-files-cache-expire (* 60 60 24 14)) ;; 2 weeks

  (add-to-list 'projectile-globally-ignored-directories "elpa")
  (add-to-list 'projectile-globally-ignored-directories ".cache")
  (add-to-list 'projectile-globally-ignored-directories "target")
  (add-to-list 'projectile-globally-ignored-directories "dist")
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories ".git")
  (add-to-list 'projectile-globally-ignored-directories ".idea")

  (projectile-load-known-projects)

  (setq projectile-generic-command
        (concat "rg -0 --hidden --files --color never "
                (mapconcat (lambda (dir) (concat "--glob " "'!" dir "'")) projectile-globally-ignored-directories " ")))

  )

(provide 'config-projectile)
