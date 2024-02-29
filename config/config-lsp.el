;; -*- lexical-binding: t -*-

(use-package lsp-mode
  :straight t
  :hook (typescript-mode-hook . /lsp/activate)
  :hook (typescript-ts-mode-hook . /lsp/activate)
  :hook (tsx-ts-mode-hook . /lsp/activate)
  :hook (rust-mode-hook . /lsp/activate)
  :config
  (setq lsp-session-file (concat dotemacs-cache-directory ".lsp-session-v1"))
  (setq lsp-keep-workspace-alive nil)
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-headerline-breadcrumb-enable nil)
  
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

  (evil-define-key 'normal lsp-mode-map (kbd ", r") 'lsp-rename)
  (evil-define-key 'normal lsp-mode-map (kbd ", s r") 'lsp-restart-workspace)
  (evil-define-key 'normal lsp-mode-map (kbd ", o") 'lsp-organize-imports)
  (evil-define-key 'normal lsp-mode-map (kbd ", a") 'lsp-execute-code-action)
  (evil-define-key 'visual lsp-mode-map (kbd ", a") 'lsp-execute-code-action)
  (evil-define-key 'normal lsp-mode-map (kbd ", h") 'lsp-ui-doc-glance)
  (evil-define-key 'normal lsp-mode-map (kbd "K") 'lsp-ui-doc-glance)
  (evil-define-key 'normal lsp-mode-map (kbd "g d") 'lsp-ui-peek-find-definitions)
  (evil-define-key 'normal lsp-mode-map (kbd "g D") 'lsp-ui-peek-find-references)

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
