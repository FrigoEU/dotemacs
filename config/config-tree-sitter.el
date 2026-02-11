;; -*- lexical-binding: t -*-

;; Run this manually!

;; (setq treesit-language-source-alist
;;       '(
;;         (bash "https://github.com/tree-sitter/tree-sitter-bash")
;;         (cmake "https://github.com/uyha/tree-sitter-cmake")
;;         (css "https://github.com/tree-sitter/tree-sitter-css")
;;         (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;         (html "https://github.com/tree-sitter/tree-sitter-html")
;;         (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;;         (json "https://github.com/tree-sitter/tree-sitter-json")
;;         (make "https://github.com/alemuller/tree-sitter-make")
;;         (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;         (python "https://github.com/tree-sitter/tree-sitter-python")
;;         (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;         (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;         (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;         (rust "https://github.com/tree-sitter/tree-sitter-rust")
;;         (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
;;         (swift "https://github.com/alex-pinkus/tree-sitter-swift" "with-generated-files")
;;         (yaml "https://github.com/ikatyang/tree-sitter-yaml")
;;         ))
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))

;; NOTE: The old `tree-sitter` / `tree-sitter-hl-mode` package is not needed
;; when using the built-in treesit (Emacs 29+) via treesit-auto below.

(use-package treesit-auto
  :straight t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
