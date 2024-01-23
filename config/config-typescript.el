;; -*- lexical-binding: t -*-

(use-package typescript-mode
  :straight t
  )

                                        ; (/boot/lazy-major-mode "\\.ts$" typescript-mode)
                                        ; (/boot/lazy-major-mode "\\.tsx$" typescript-mode)

(use-package emmet-mode
  :straight t
  :hook (typescript-mode-hook typescript-tsx-mode-hook html-mode-hook)
  :config
  (add-to-list 'emmet-jsx-major-modes 'typescript-mode)
  (add-to-list 'emmet-jsx-major-modes 'typescript-tsx-mode)
  :bind (:map evil-insert-state-map
              ("<C-return>" . emmet-expand-line)
              )
  )

(setq typescript-indent-level 2)
(setq typescript-ts-mode-indent-offset 2)

(provide 'config-typescript)
