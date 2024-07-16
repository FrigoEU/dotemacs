;; -*- lexical-binding: t -*-
(setq vterm-max-scrollback 5000)

(defun vterm-new ()
  (interactive)
  (projectile-run-vterm t)
  )

