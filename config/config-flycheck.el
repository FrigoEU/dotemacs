;; -*- lexical-binding: t -*-

(use-package flycheck
  :straight t
  :hook
  (after-init-hook . global-flycheck-mode)
  :config
  (setq flycheck-standard-error-navigation t)
  (setq flycheck-temp-prefix (concat dotemacs-cache-directory "flycheck/"))
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc html-tidy))

  :bind (:map flycheck-error-list-mode-map
              ("j" . flycheck-error-list-next-error)
              ("k" . flycheck-error-list-previous-error)
              )
  )

(use-package flycheck-pos-tip
  :straight t
  :init
  (setq flycheck-pos-tip-timeout -1)
  (flycheck-pos-tip-mode)
  )

(defun /flycheck/advice/next-error-find-buffer (orig-func &rest args)
  (let* ((special-buffers
          (cl-loop for buffer in (mapcar #'window-buffer (window-list))
                   when (with-current-buffer buffer
                          (and
                           (eq (get major-mode 'mode-class) 'special)
                           (boundp 'next-error-function)))
                   collect buffer))
         (first-special-buffer (car special-buffers)))
    (if first-special-buffer
        first-special-buffer
      (apply orig-func args))))

(advice-add #'next-error-find-buffer :around #'/flycheck/advice/next-error-find-buffer)
(setq-default flycheck-indication-mode 'left-margin)

(use-package flycheck-eglot
  :straight t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(provide 'config-flycheck)
