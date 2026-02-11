
(if (eq simon/lsp-client 'eglot)
    (use-package eglot
      :straight t

      :hook (typescript-mode-hook . eglot-ensure)
      :hook (typescript-ts-mode-hook . eglot-ensure)
      :hook (tsx-ts-mode-hook . eglot-ensure)
      :hook (rust-mode-hook . eglot-ensure)
      :hook (js-json-mode-hook . eglot-ensure)
      ;; :hook (kotlin-ts-mode-hook . eglot-ensure)
      :hook (swift-ts-mode-hook . eglot-ensure)
      :hook (go-mode-hook . eglot-ensure)

      :config
      ;; Single line so screen doesn't constantly jump
      ;; use eldoc (K) for full view
      (setq eldoc-echo-area-use-multiline-p nil)

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

      ;; (evil-define-key 'normal eglot-mode-map (kbd "-") 'eglot-momentary-inlay-hints)

      ;; (setq eglot-ignored-server-capabilities '(:inlayHintProvider))

      ;; tsgo uses VS Code-style nested settings (typescript.inlayHints.parameterNames.enabled etc.)
      ;; When tsgo requests workspace/configuration for section "typescript",
      ;; eglot responds with the plist below, serialized as nested JSON.
      ;; (setq-default eglot-workspace-configuration
      ;;               '(:typescript
      ;;                 (:inlayHints
      ;;                  (:parameterNames (:enabled "all")
      ;;                                   :parameterTypes (:enabled t)
      ;;                                   :variableTypes (:enabled t)
      ;;                                   :propertyDeclarationTypes (:enabled t)
      ;;                                   :functionLikeReturnTypes (:enabled t)
      ;;                                   :enumMemberValues (:enabled t)))))

      (put 'tsx-ts-mode 'eglot-language-id "typescriptreact")
      (put 'typescript-ts-mode 'eglot-language-id "typescript")
      (put 'typescript-mode 'eglot-language-id "typescript")

      (defun simon/tsgo-or-ts-ls (&optional interactive)
        (if (executable-find "tsgo")
            '("tsgo" "--lsp" "--stdio")
          '("typescript-language-server" "--stdio")))

      (add-to-list 'eglot-server-programs
                   '((typescript-ts-mode tsx-ts-mode typescript-mode) . simon/tsgo-or-ts-ls))

      (add-to-list 'eglot-server-programs
                   '(sql-mode . ("postgrestools" "lsp-proxy")))

      (add-to-list 'eglot-server-programs
                   '(swift-ts-mode . swift-lsp-eglot-server-contact))

      (add-to-list 'eglot-server-programs
                   '(kotlin-ts-mode . ("kotlin-language-server")))

      ))

(if (eq simon/lsp-client 'lsp-mode)

    (progn
      (use-package lsp-mode
        :straight t
        :hook (typescript-mode-hook . /lsp/activate)
        :hook (typescript-ts-mode-hook . /lsp/activate)
        :hook (tsx-ts-mode-hook . /lsp/activate)
        ;; :hook (rust-mode-hook . /lsp/activate)
        :config
        (setq lsp-session-file (concat dotemacs-cache-directory ".lsp-session-v1"))
        (setq lsp-keep-workspace-alive nil)
        (setq read-process-output-max (* 1024 1024))
        (setq lsp-headerline-breadcrumb-enable nil)

        (evil-define-key 'normal lsp-mode-map (kbd ", r") 'lsp-rename)
        (evil-define-key 'normal lsp-mode-map (kbd ", s r") 'lsp-restart-workspace)
        (evil-define-key 'normal lsp-mode-map (kbd ", o") 'remove-and-organize-imports)
        (evil-define-key 'normal lsp-mode-map (kbd ", a") 'lsp-execute-code-action)
        (evil-define-key 'visual lsp-mode-map (kbd ", a") 'lsp-execute-code-action)
        (evil-define-key 'normal lsp-mode-map (kbd ", h") 'lsp-ui-doc-glance)
        (evil-define-key 'normal lsp-mode-map (kbd "K") 'lsp-ui-doc-glance)
        (evil-define-key 'normal lsp-mode-map (kbd "g d") 'lsp-ui-peek-find-definitions)
        (evil-define-key 'normal lsp-mode-map (kbd "g D") 'lsp-ui-peek-find-references)

        ;; This code action was not working anymore (not removing unused imports, only sorting) after 4.9, so I added this
        (lsp-make-interactive-code-action organize-imports "source.organizeImports.ts")
        (lsp-make-interactive-code-action remove-unused-imports "source.removeUnusedImports")
        
        )

      (defun remove-and-organize-imports ()
        (interactive)
        (progn
          ;; Depending on typescript / lsp version this fails or not so we just ignore errors here
          (lsp-organize-imports)
          (lsp-remove-unused-imports)
          )
        )


      (use-package lsp-ui
        :straight t
        :after lsp-mode
        :config
        (setq lsp-ui-sideline-show-hover nil)
        (setq lsp-ui-sideline-delay 0.5)

        (setq lsp-ui-doc-enable t)
        (setq lsp-ui-doc-use-childframe t)
        (setq lsp-ui-doc-include-signature t)
        (setq lsp-ui-doc-header t)
        (setq lsp-ui-doc-position 'at-point)
        (setq lsp-ui-doc-delay 1)
        (setq lsp-ui-doc-show-with-cursor nil)

        (setq lsp-ui-peek-list-width 100)
        (setq lsp-ui-peek-peek-height 30)

        (setq lsp-ui-doc-show-with-mouse nil)


        (add-hook 'lsp-after-apply-edits-hook
                  (lambda (operation)
                    (when (eq operation 'rename)
                      (save-buffer))))

        :bind (:map lsp-ui-peek-mode-map
                    ("k" . lsp-ui-peek--select-prev)
                    ("j" . lsp-ui-peek--select-next)
                    )

        )

      ;; (use-package consult-lsp
      ;;   :straight t
      ;;   :after lsp-mode
      ;;   )


      (setq /lsp/inhibit_paths '("node_modules"))
      (defun /lsp/activate ()
        (interactive)
        (unless (seq-filter
                 (lambda (path)
                   (string-match-p path (buffer-file-name)))
                 /lsp/inhibit_paths)
          (progn
            (lsp-deferred)
            )
          )
        )

      (defun /lsp/suggest-project-root ()
        "Suggests the nearest project that is not a dependency."
        (or
         (locate-dominating-file
          (buffer-file-name)
          (lambda (dir)
            (if (string-match-p "node_modules" dir)
                nil
              (file-exists-p (concat dir "package.json")))))
         (projectile-project-root)))

      (after 'lsp-mode
        (advice-add #'lsp--suggest-project-root :override #'/lsp/suggest-project-root))
      )

  )
