;; -*- lexical-binding: t -*-

(defgroup dotemacs-misc nil
  "Configuration options for miscellaneous."
  :group 'dotemacs
  :prefix 'dotemacs-misc)

(use-package dumb-jump
  :straight t
  :hook (xref-backend-functions . dumb-jump-xref-activate)
  :hook (dumb-jump-after-jump-hook . evil-set-jump)
  )

(use-package wgrep
  :straight t
  )

(use-package aggressive-indent
  :straight t
  :hook (emacs-lisp-mode-hook . aggressive-indent-mode)
  :hook (lisp-mode-hook . aggressive-indent-mode)
  )

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode-hook . rainbow-delimiters-mode)
  )

(use-package vlf
  :straight t
  :init
  (setq vlf-application 'dont-ask)
  )

(use-package shackle
  :straight t
  :init
  (shackle-mode)
  :config
  (setq shackle-rules
        '((help-mode :align right :size 80)
          (compilation-mode :align bottom :size 0.2)
          (diff-mode :align right :size 0.5)
          (magit-diff-mode :align right :size 0.5)
          (magit-revision-mode :align right :size 0.5)
          (ibuffer-mode :align right :size 0.5)
          (ag-mode :align right :size 0.5)
          (compilation-mode :align bottom :size 0.3)
          ("^\\*helm.*\\*$" :regexp t :align bottom)
          ))
  )

;; Formatting
(when (not (eq system-type 'windows-nt))
  (use-package apheleia
    :straight t
    :init
    (apheleia-global-mode +1)
    :config
    (setf (alist-get 'rustfmt apheleia-formatters)
          '("rustfmt" "--quiet" "--emit" "stdout" "--edition" "2021")
          )
    ;; (add-to-list 'apheleia-formatters
    ;;              '(prettier-sql "apheleia-npx" "prettier" "--stdin-filepath" filepath
    ;;                             (apheleia-formatters-js-indent "--use-tabs" "--tab-width"))
    ;;              )
    ;; (add-to-list 'apheleia-mode-alist '(sql-mode . prettier-sql))
    )
  )

;; Not necessary on linux as there apheleia works...
(when (eq system-type 'windows-nt)
  (use-package prettier-js
    :straight t
    :config
    (add-hook 'js-mode-hook 'prettier-js-mode)
    (add-hook 'web-mode-hook 'prettier-js-mode)
    )
  )

(setq css-indent-offset 2)


(use-package restart-emacs
  :straight t
  )


(provide 'config-misc)
