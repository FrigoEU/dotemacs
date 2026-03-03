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
          '("ktfmt" "--do-not-remove-unused-imports" "-"))

    (add-to-list 'apheleia-mode-alist '(kotlin-ts-mode . ktfmt))
    ;; (add-to-list 'apheleia-mode-alist '(kotlin-ts-mode . ktlint))

    (add-to-list 'apheleia-mode-alist '(swift-ts-mode . swift-format))
    (add-to-list 'apheleia-formatters '(swift-format "swift-format" (buffer-file-name)))

    ;; Use oxfmt instead of prettier for JS/TS when available in PATH
    (setf (alist-get 'oxfmt apheleia-formatters)
          '("oxfmt" "--stdin-filepath" filepath))

    (defun my/apheleia-use-oxfmt-maybe ()
      "Set `apheleia-formatter' to oxfmt if available, else leave default."
      (when (executable-find "oxfmt")
        (setq-local apheleia-formatter 'oxfmt)))

    (dolist (hook '(js-mode-hook js-ts-mode-hook
                                 typescript-mode-hook typescript-ts-mode-hook
                                 tsx-ts-mode-hook))
      (add-hook hook #'my/apheleia-use-oxfmt-maybe))

    ;; Re-check after envrc updates the buffer environment, since
    ;; envrc-mode activates after major-mode hooks have already run.
    (advice-add 'envrc--apply :after
                (lambda (buf &rest _)
                  (with-current-buffer buf
                    (when (apply #'derived-mode-p
                                 '(js-mode js-ts-mode
                                           typescript-mode typescript-ts-mode
                                           tsx-ts-mode))
                      (my/apheleia-use-oxfmt-maybe)))))

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
