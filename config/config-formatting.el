;; -*- lexical-binding: t -*-

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

    (setf (alist-get 'ktfmt apheleia-formatters)
          '("ktfmt" "-"))

    (add-to-list 'apheleia-mode-alist '(kotlin-ts-mode . ktfmt))
    ;; (add-to-list 'apheleia-mode-alist '(kotlin-ts-mode . ktlint))

    (add-to-list 'apheleia-mode-alist '(swift-ts-mode . swift-format))
    (add-to-list 'apheleia-formatters '(swift-format "swift-format" (buffer-file-name)))

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
