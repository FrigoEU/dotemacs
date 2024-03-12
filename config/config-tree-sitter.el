;; -*- lexical-binding: t -*-

;; (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(typescript-tsx-mode . tsx-ts-mode))

;; (use-package treesit
;;   ;; :straight t
;;   ;; :hook (tree-sitter-after-on-hook . tree-sitter-hl-mode)
;;   ;; :init (global-tree-sitter-mode t)
;;   :config
;;   (setq treesit-language-source-alist
;;         '((bash "https://github.com/tree-sitter/tree-sitter-bash")
;;           (cmake "https://github.com/uyha/tree-sitter-cmake")
;;           (css "https://github.com/tree-sitter/tree-sitter-css")
;;           (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;           (html "https://github.com/tree-sitter/tree-sitter-html")
;;           (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;;           (json "https://github.com/tree-sitter/tree-sitter-json")
;;           (make "https://github.com/alemuller/tree-sitter-make")
;;           (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;           (python "https://github.com/tree-sitter/tree-sitter-python")
;;           (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;           (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;           (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;           (rust "https://github.com/tree-sitter/tree-sitter-rust")
;;           (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;;   (setq treesit-font-lock-level 4)
;;   ;; Run this manually!
;;   ;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))
;;   )

(use-package tree-sitter
  :straight t
  :hook (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  :init (global-tree-sitter-mode t)
  :config
  (add-to-list 'tree-sitter-major-mode-language-alist '(tsx-ts-mode . tsx))
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-ts-mode . tsx))
  )

(use-package tree-sitter-langs
  :straight t
  :after tree-sitter
  )

