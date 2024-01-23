;; -*- lexical-binding: t -*-

(use-package helm
  :straight t
  :init
  (helm-mode)
  :config
  ;; escape minibuffer
  (define-key minibuffer-local-map [escape] 'helm-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'helm-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'helm-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'helm-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'helm-keyboard-quit)
  (setq helm-display-function 'helm-display-buffer-in-own-frame
        helm-display-buffer-reuse-frame t
        helm-use-undecorated-frame-option t
        )
  (setq helm-display-header-line nil)

  :bind (:map helm-map
              ("ESC" . helm-keyboard-quit)
              ("C-h" . backward-kill-word)
              )
  )

