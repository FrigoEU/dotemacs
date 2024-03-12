;; -*- lexical-binding: t -*-

(defun my-select-project (proj)
  (interactive)
  (progn
    (projectile-persp-switch-project proj)
    (persp-kill "main")
    )
  )

(use-package dashboard
  :straight t
  :init
  (dashboard-setup-startup-hook)
  :config
  (setq dashboard-center-content t)
  (setq dashboard-items '((projects . 5)))
  (setq dashboard-projects-switch-function 'my-select-project)
  ;; (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-startup-banner "~/dotfiles/xemacs_color.svg")
  (setq dashboard-banner-logo-title nil)
  (setq dashboard-footer-messages nil)
  (setq dashboard-set-footer nil)
  )
