;; -*- lexical-binding: t -*-

(use-package ivy
  :straight t
  :init
  (ivy-mode)
  )

(use-package counsel
  :straight t
  :init
  (counsel-mode)
  )

(use-package ivy-posframe
  :straight t
  :init
  (ivy-posframe-mode 1)
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
  (setq ivy-height 20)
  (setq ivy-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)))
  ;; display at `ivy-posframe-style'
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-bottom-left)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
  )
