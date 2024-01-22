;; -*- lexical-binding: t -*-

(use-package smartparens
  :straight t
  :hook (prog-mode-hook text-mode-hook markdown-mode-hook)
  :config
  ;; load default config
  (require 'smartparens-config)
  )

(provide 'config-pairs)
