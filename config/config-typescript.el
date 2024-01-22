;; -*- lexical-binding: t -*-

(use-package typescript-mode
  :straight t
  )

; (/boot/lazy-major-mode "\\.ts$" typescript-mode)
; (/boot/lazy-major-mode "\\.tsx$" typescript-mode)

(use-package emmet-mode
  :hook (typescript-mode typescript-tsx-mode html-mode)
  )

(setq typescript-indent-level 2)
(setq typescript-ts-mode-indent-offset 2)

(provide 'config-typescript)
