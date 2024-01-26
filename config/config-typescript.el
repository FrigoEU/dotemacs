;; -*- lexical-binding: t -*-

(use-package typescript-mode
  :straight t
  )

(use-package company
  :straight t
  :config
  (setq company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend))
  )

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)

  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  (corfu-mode 0)

  (bind-keys
   :map evil-visual-state-map
   (", t" . tide-refactor) 
   )

  (bind-keys
   :map evil-normal-state-map
   (", a" . tide-fix)

   (", r" . tide-rename-symbol)
   (", R" . tide-rename-file)

   (", t" . tide-refactor) 

   (", s r" . tide-restart-server)

   (", o" . tide-organize-imports)

   (", h" . tide-documentation-at-point)

   ("g d" . tide-jump-to-definition)
   ("g D" . tide-references)
   )
  )


(use-package tide
  :straight t
  :hook (typescript-mode-hook . setup-tide-mode)
  :hook (typescript-ts-mode-hook . setup-tide-mode)
  :hook (typescript-tsx-mode-hook . setup-tide-mode)
  )

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
