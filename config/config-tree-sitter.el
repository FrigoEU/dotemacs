;; -*- lexical-binding: t -*-

(use-package tree-sitter
  :straight t
  :hook (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  :init (global-tree-sitter-mode t)
  :config
  (add-to-list 'tree-sitter-major-mode-language-alist '(tsx-ts-mode . tsx))
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-ts-mode . typescript))
  
  )

(use-package tree-sitter-langs
  :straight t
  :after tree-sitter
  )

