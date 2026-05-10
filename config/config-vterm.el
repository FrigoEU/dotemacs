;; -*- lexical-binding: t -*-
(setq vterm-max-scrollback 5000)

(if (eq system-type 'darwin)
    (use-package vterm
      :straight t)
  (use-package vterm)
  )

(defun vterm-new ()
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (projectile-run-vterm t)))

