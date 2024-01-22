;; -*- lexical-binding: t -*-

(use-package dashboard
  :straight t
  :init
  (dashboard-setup-startup-hook)
  :config
  (setq dashboard-center-content t)
  (setq dashboard-items '((projects . 5)))
  (setq dashboard-projects-switch-function 'projectile-persp-switch-project)
  ;; (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-startup-banner "~/dotfiles/xemacs_color.svg")
  (setq dashboard-banner-logo-title nil)
  (setq dashboard-footer-messages nil)
  (setq dashboard-set-footer nil)
  )
