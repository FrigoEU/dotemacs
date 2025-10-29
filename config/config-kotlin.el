;; -*- lexical-binding: t -*-

;; (use-package kotlin-mode
;;   :straight t
;;   )

(use-package kotlin-ts-mode
  :straight (:host gitlab :repo "bricka/emacs-kotlin-ts-mode")
  :mode "\\.kt\\'" ; if you want this mode to be auto-enabled
  )
