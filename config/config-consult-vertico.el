;; -*- lexical-binding: t -*-

(use-package consult
  :straight t
  :config
  (setq consult-preview-key "<right>") ;; Don't show preview
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))

  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  )


(use-package vertico
  :straight t
  :hook (minibuffer-setup-hook . vertico-repeat-save)
  :init
  (vertico-mode)
  :config
  (setq vertico-count 20)
  (vertico-multiform-mode) ;; So we can have different placements of the frame for different consult functions

  )

;; A few more useful configurations...
(use-package emacs
  :straight t
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t)
  )

(use-package savehist
  :straight t
  :init
  (savehist-mode))


(use-package orderless
  :straight t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode t)
  )

;; No icons? Run manually:
;;   M-x nerd-icons-install-fonts
(use-package nerd-icons
  :straight t
  )

(use-package nerd-icons-completion
  :straight t
  :after (marginalia nerd-icons)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :init
  (nerd-icons-completion-mode))

;; (use-package prescient
;;   :straight t
;;   :config
;;   (setq prescient-save-file (concat dotemacs-cache-directory "prescient-save.el"))
;;   (setq prescient-persist-mode t)
;;   (setq prescient-filter-method '(literal anchored fuzzy))
;;   )

;; (use-package vertico-prescient
;;   :straight t
;;   :config
;;   (setq vertico-prescient-override-sorting t)
;;   :after (vertico prescient)
;;   )

(use-package embark-consult
  :straight t
  :after (embark consult)
  )

(use-package embark
  :straight t
  )

(use-package consult-projectile
  :straight t
  :after projectile
  :config
  (add-to-list 'consult-projectile-sources 'consult-projectile--source-projectile-recentf)
  )

;; (use-package consult-lsp
;;   :straight t
;;   :after lsp-mode
;;   )

(defun consult-ripgrep-root ()
  (interactive)
  (consult-ripgrep (projectile-project-root) "")
  )

(defun consult-ripgrep-root-at-point ()
  (interactive)
  (consult-ripgrep (projectile-project-root) (thing-at-point 'symbol))
  )

(defun consult-project-commands ()
  (interactive)
  (completing-read
   ())
  )

(provide 'config-consult-vertico)

(defun add-metadata-completions-are-presorted (completions)
  (lambda (string pred action)
    (if (eq action 'metadata)
        `(metadata (display-sort-function . ,#'identity))
      (complete-with-action action completions string pred))))


(defun simon-async-shell-command-with-make()
  "Run `async-shell-command` with a choice from its command history."
  (interactive)
  (let* ((command
          (completing-read
           "$ "
           (let* ((filename (projectile-expand-root "Makefile"))
                  (command-list (if (file-exists-p filename)
                                    (parse-makefile-into-completing-read-collection filename)
                                  '()
                                  ))
                  (command-list-with-ordering
                   ;; Use sorting in Makefile
                   (add-metadata-completions-are-presorted command-list))
                  )
             command-list-with-ordering
             )
           )))
    (projectile-run-async-shell-command-in-root command (concat (concat "*OUT: " command) "*"))))

(defun parse-makefile-into-completing-read-collection (makefilepath)
  "Return the target list for MAKEFILE by parsing it."
  (let (targets)
    (with-temp-buffer
      (insert-file-contents makefilepath)
      (goto-char (point-min))
      (while (re-search-forward "^\\([^: \n]+\\) *:\\(?: \\|$\\)" nil t)
        (let ((str (match-string 1)))
          (unless (string-match "^\\." str)
            (push (concat "make " str) targets)))))
    (nreverse targets)))

