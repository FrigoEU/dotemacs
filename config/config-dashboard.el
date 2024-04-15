;; -*- lexical-binding: t -*-

(use-package dashboard
  :straight t
  :config
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  ;; (setq dashboard-items '((projects . 5)))
  ;; (setq dashboard-projects-switch-function 'projectile-persp-switch-project)
  (setq dashboard-startup-banner "~/dotfiles/xemacs_color.svg")
  (setq dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    ))
  (dashboard-setup-startup-hook)
  )
