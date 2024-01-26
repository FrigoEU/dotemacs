;; -*- lexical-binding: t -*-


(defun vterm-new ()
  (interactive)
  (projectile-run-vterm t)
  )

(add-hook 'vterm-mode-hook 'set-no-process-query-on-exit)

