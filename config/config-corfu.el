;; -*- lexical-binding: t -*-

(use-package corfu
  :straight t
  :init
  (global-corfu-mode t)
  :config
  (setq corfu-auto-prefix 2)
  (setq corfu-auto t)
  (setq corfu-cycle t)

  (setq corfu-popupinfo-delay '(1.0 . 0.2))
  (corfu-popupinfo-mode t)

  (defun /corfu/move-to-minibuffer ()
    (interactive)
    (let ((completion-extra-properties corfu--extra)
          completion-cycle-threshold completion-cycling)
      (apply #'consult-completion-in-region completion-in-region--data)))


  (after [lsp-completion]
    (setq lsp-completion-provider :none)
    (defun /corfu/lsp-setup-completion ()
      (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
            '(flex)))
    (add-hook 'lsp-completion-mode #'/corfu/lsp-setup-completion))

  (add-hook
   'eshell-mode-hook
   (defun /corfu/eshell-mode-hook ()
     (setq-local corfu-auto nil)))

  (advice-add
   #'corfu-insert
   :after
   (defun /corfu/corfu-insert-for-shell (&rest _)
     "Send completion candidate when insude comint/eshell."
     (cond
      ((derived-mode-p 'eshell-mode) (eshell-send-input))
      ((derived-mode-p 'comint-mode) (comint-send-input)))))

  (use-package cape
    :straight t
    :init
    (add-to-list 'completion-at-point-functions #'cape-dabbrev)
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-keyword)
    :config
    (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-silent)
    (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-purify)
    (define-key corfu-map (kbd "<tab>") #'corfu-next)
    (define-key corfu-map (kbd "<backtab>") #'corfu-previous))
  )


(use-package corfu-prescient
  :straight t
  :init
  (corfu-prescient-mode t)
  :config
  (setq corfu-prescient-override-sorting t)
  :after prescient
  )
