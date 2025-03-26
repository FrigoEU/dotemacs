;; -*- lexical-binding: t -*-

;; (use-package typescript-mode
;;   :straight t
;;   )
(use-package typescript-ts-mode
  :straight t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))


(use-package company
  :straight t
  :config
  (setq company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend))
  )

;; (defun setup-tide-mode ()
;;   (interactive)
;;   (tide-setup)

;;   (flycheck-mode +1)
;;   (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;   (eldoc-mode +1)
;;   (tide-hl-identifier-mode +1)
;;   (company-mode +1)
;;   (corfu-mode 0)

;;   (evil-define-key 'visual tide-mode-map (kbd ", t") 'tide-refactor)
;;   (evil-define-key 'normal tide-mode-map (kbd ", t") 'tide-refactor)
;;   (evil-define-key 'normal tide-mode-map (kbd ", a") 'tide-fix)
;;   (evil-define-key 'normal tide-mode-map (kbd ", r") 'tide-rename-symbol)
;;   (evil-define-key 'normal tide-mode-map (kbd ", R") 'tide-rename-file)
;;   (evil-define-key 'normal tide-mode-map (kbd ", s r") 'tide-restart-server)
;;   (evil-define-key 'normal tide-mode-map (kbd ", o") 'tide-organize-imports)
;;   (evil-define-key 'normal tide-mode-map (kbd ", h") 'tide-documentation-at-point)
;;   (evil-define-key 'normal tide-mode-map (kbd "g d") 'tide-jump-to-definition)
;;   (evil-define-key 'normal tide-mode-map (kbd "g D") 'tide-references)
;;   )


;; (use-package tide
;;   :straight t
;;   :hook (typescript-mode-hook . setup-tide-mode)
;;   :hook (typescript-ts-mode-hook . setup-tide-mode)
;;   :hook (typescript-tsx-mode-hook . setup-tide-mode)
;;   :bind (:map evil-normal-state-map

;;               ("g d" . tide-jump-to-definition)
;;               ("g D" . tide-references))
;;   )

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

;; (use-package flymake-eslint
;;   :straight '(flymake-eslint :type git :host github :repo "orzechowskid/flymake-eslint")
;;   :config
;;   ;; https://github.com/orzechowskid/flymake-eslint/issues/23
;;   (add-hook 'eglot-managed-mode-hook
;;             '(lambda ()
;;                (if (or (derived-mode-p 'typescript-ts-mode)
;;                        (derived-mode-p 'tsx-ts-mode))
;;                    (if (executable-find "eslint_d")
;;                        (flymake-eslint-enable)
;;                      (run-with-timer
;;                       1
;;                       nil
;;                       (lambda ()
;;                         (if (executable-find "eslint_d")
;;                             (flymake-eslint-enable)
;;                           (print "eslint_d not found")))
;;                       )
;;                      )
;;                  )))
;;   :custom
;;   (flymake-eslint-prefer-json-diagnostics t)
;;   (flymake-eslint-executable-args nil)
;;   (flymake-eslint-defer-binary-check t)
;;   (flymake-eslint-executable-name "eslint_d")
;;   )

(provide 'config-typescript)
