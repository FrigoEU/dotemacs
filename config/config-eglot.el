(use-package eglot
  :straight t

  :hook (typescript-mode-hook . eglot-ensure)
  :hook (typescript-ts-mode-hook . eglot-ensure)
  :hook (tsx-ts-mode-hook . eglot-ensure)
  :hook (rust-mode-hook . eglot-ensure)

  :config
  (evil-define-key 'normal eglot-mode-map (kbd ", r") 'eglot-rename)
  (evil-define-key 'normal eglot-mode-map (kbd ", s r") 'eglot-reconnect)
  (evil-define-key 'normal eglot-mode-map (kbd ", o") 'eglot-code-action-organize-imports)
  (evil-define-key 'normal eglot-mode-map (kbd ", a") 'eglot-code-actions)
  (evil-define-key 'visual eglot-mode-map (kbd ", a") 'eglot-code-actions)
  (evil-define-key 'normal eglot-mode-map (kbd "K") 'eldoc)
  (evil-define-key 'normal eglot-mode-map (kbd "g d") 'xref-find-definitions)
  (evil-define-key 'normal eglot-mode-map (kbd "g D") 'xref-find-references)
  )

(use-package flycheck-eglot
  :straight t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))
