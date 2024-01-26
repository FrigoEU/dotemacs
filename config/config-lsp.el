;; -*- lexical-binding: t -*-

(use-package lsp-mode
  :straight t
  ;; :hook (typescript-mode-hook . /lsp/activate)
  ;; :hook (typescript-tsx-mode-hook . /lsp/activate)
  :hook (rust-mode-hook . /lsp/activate)
  :config
  (setq lsp-session-file (concat dotemacs-cache-directory ".lsp-session-v1"))
  (setq lsp-keep-workspace-alive nil)
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-headerline-breadcrumb-enable nil)

  :bind (
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

  :bind (:map lsp-ui-peek-mode-map
              ("k" . lsp-ui-peek--select-prev)
              ("j" . lsp-ui-peek--select-next)
              )
  )

(setq /lsp/inhibit_paths '("node_modules"))
(defun /lsp/activate ()
  (interactive)
  (unless (seq-filter
           (lambda (path)
             (string-match-p path (buffer-file-name)))
           /lsp/inhibit_paths)
    (progn
      (lsp-deferred)
      (bind-keys
       :map evil-normal-state-map
       (", r" . lsp-rename)
       (", s r" . lsp-restart-workspace)

       (", o" . lsp-organize-imports)

       (", a" . lsp-execute-code-action)

       (", d" . lsp-ui-peek-find-definitions)
       (", D" . lsp-ui-peek-find-references)

       (", h" . lsp-ui-doc-glance)

       ("g d" . lsp-ui-peek-find-definitions)
       ("g D" . lsp-ui-peek-find-references)
       )
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

(provide 'config-lsp)
