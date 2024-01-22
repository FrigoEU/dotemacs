;; -*- lexical-binding: t -*-

(use-package tree-sitter
  :straight t
  :hook (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  :init (global-tree-sitter-mode t)
  )

(use-package tree-sitter-langs
  :straight t
  )

