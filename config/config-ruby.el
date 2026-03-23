;; -*- lexical-binding: t -*-

(use-package ruby-ts-mode
  :straight t
  :mode "\\.rb\\'"
  :mode "Rakefile\\'"
  :mode "Gemfile\\'")

(use-package web-mode
  :straight t
  :mode "\\.erb\\'")

(use-package haml-mode
  :straight t
  :mode "\\.haml\\'")

(provide 'config-ruby)
