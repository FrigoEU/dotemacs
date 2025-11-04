;; -*- lexical-binding: t -*-
(setq vterm-max-scrollback 5000)

(if (eq system-type 'darwin)
    (use-package vterm
      :straight t)
  )

(defun vterm-new ()
  (interactive)
  (projectile-run-vterm t)
  )

