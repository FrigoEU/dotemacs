
(use-package eglot
  :straight t

  :hook (typescript-mode-hook . eglot-ensure)
  :hook (typescript-ts-mode-hook . eglot-ensure)
  :hook (tsx-ts-mode-hook . eglot-ensure)
  :hook (rust-mode-hook . eglot-ensure)
  :hook (js-json-mode-hook . eglot-ensure)
  :hook (kotlin-mode-hook . eglot-ensure)
  :hook (swift-mode-hook . eglot-ensure)

  :config
  (eglot--code-action eglot-code-action-remove-unused-imports "source.removeUnusedImports")

  (defun remove-and-organize-imports ()
    (interactive)
    (progn
      ;; Depending on typescript / lsp version this fails or not so we just ignore errors here
      (ignore-errors (eglot-code-action-remove-unused-imports (point)))
      (eglot-code-action-organize-imports (point))
      )
    )

  (evil-define-key 'normal eglot-mode-map (kbd ", r") 'eglot-rename)
  (evil-define-key 'normal eglot-mode-map (kbd ", s r") 'eglot-reconnect)
  (evil-define-key 'normal eglot-mode-map (kbd ", o") 'remove-and-organize-imports)
  ;; (evil-define-key 'normal eglot-mode-map (kbd ", o") 'eglot-code-action-organize-imports)
  ;; (evil-define-key 'normal eglot-mode-map (kbd ", p") 'eglot-code-action-remove-unused-imports)
  (evil-define-key 'normal eglot-mode-map (kbd ", a") 'eglot-code-actions)
  (evil-define-key 'visual eglot-mode-map (kbd ", a") 'eglot-code-actions)
  (evil-define-key 'normal eglot-mode-map (kbd ", f") 'eglot-code-action-quickfix)
  (evil-define-key 'visual eglot-mode-map (kbd ", f") 'eglot-code-action-quickfix)
  (evil-define-key 'normal eglot-mode-map (kbd "K") 'eldoc)
  (evil-define-key 'normal eglot-mode-map (kbd "g d") 'xref-find-definitions)
  (evil-define-key 'normal eglot-mode-map (kbd "g D") 'xref-find-references)

  (setq eglot-ignored-server-capabilities '(:inlayHintProvider))

  (add-to-list 'eglot-server-programs
               '(sql-mode . ("postgrestools" "lsp-proxy")))

  (add-to-list 'eglot-server-programs
               '(swift-mode . ("xcrun" "sourcekit-lsp")))

  ;; (add-to-list
  ;;  'eglot-server-programs
  ;;  '((js-mode js-ts-mode tsx-ts-mode typescript-ts-mode typescript-mode)
  ;;    "typescript-language-server" "--stdio"
  ;;    :initializationOptions
  ;;    (
  ;;     :tsserver (:path "./node_modules/.bin/tsserver")
  ;;     :preferences
  ;;     (
  ;;      ;; :includeInlayParameterNameHints "all"
  ;;      ;; :includeInlayParameterNameHintsWhenArgumentMatchesName t
  ;;      ;; :includeInlayFunctionParameterTypeHints t
  ;;      ;; :includeInlayVariableTypeHints t
  ;;      ;; :includeInlayVariableTypeHintsWhenTypeMatchesName t
  ;;      ;; :includeInlayPropertyDeclarationTypeHints t
  ;;      ;; :includeInlayFunctionLikeReturnTypeHints t
  ;;      ;; :includeInlayEnumMemberValueHints t
  ;;      ))))
  )
