;; -*- lexical-binding: t -*-

(use-package yasnippet
  :straight t
  )

(use-package markdown-mode
  :straight t
  )

(use-package lsp-bridge
  :straight '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
                         :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
                         :build (:not compile))
  :init
  (global-lsp-bridge-mode))
