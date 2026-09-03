;; -*- lexical-binding: t -*-

(setq vc-make-backup-files t)

(defun /vcs/magit-post-display-buffer-hook()
  (if (string-match "*magit:" (buffer-name))
      (delete-other-windows)))

(use-package magit
  :straight t
  :hook (git-commit-mode-hook . evil-insert-state)
  :hook (magit-post-display-buffer-hook . /vcs/magit-post-display-buffer-hook)
  :config
  (setq magit-section-show-child-count t)
  (setq magit-display-buffer-function #'magit-display-buffer-fullcolumn-most-v1)
  (setq magit-ediff-dwim-show-on-hunks t)
  ;; Third-party hooks (tsgo, eslint, etc.) often colorize their output even
  ;; though Magit tells Git itself not to; render those escapes as faces
  ;; instead of leaving the raw ^[[96m junk in the process buffer.
  (setq magit-process-apply-ansi-colors t)
  ;; `magit-run-git-with-editor' (commit, rebase --continue, etc.) always
  ;; rebinds `magit-process-popup-time' to -1 internally, so no popup-time
  ;; setting can make its process buffer show up automatically. Force it
  ;; open immediately instead, so slow hooks are visible from the start
  ;; rather than silent until they fail.
  ;; (advice-add 'magit-run-git-with-editor :after
  ;;             (lambda (&rest _) (magit-process-buffer)))
  :custom-face
  (magit-section-highlight ((t (:background unspecified))))
  :after transient
  :bind (:map magit-mode-map
              ("SPC" . nil) ;; So we still get out usual leader menu
              )
  )

(use-package git-timemachine
  :straight t
  :bind (:map evil-normal-state-map
              ("C-p" . git-timemachine-show-previous-revision)
              ("C-n" . git-timemachine-show-next-revision)
              )
  )

;; no idea what this does
(autoload 'magit-blame "magit-blame" nil t)
(autoload 'magit-diff "magit-diff" nil t)
(autoload 'magit-log "magit-log" nil t)


;; (require-package 'with-editor)
;; (autoload 'with-editor-export-editor "with-editor")
;; (defun /vcs/with-editor-export ()
;;   (unless (equal (buffer-name) "*fzf*")
;;     (with-editor-export-editor)
;;     (message "")))
;; (add-hook 'shell-mode-hook #'/vcs/with-editor-export)
;; (add-hook 'term-exec-hook #'/vcs/with-editor-export)
;; (add-hook 'eshell-mode-hook #'/vcs/with-editor-export)

                                        ; (/boot/lazy-major-mode "^\\.gitignore$" gitignore-mode)
                                        ; (/boot/lazy-major-mode "^\\.gitattributes$" gitattributes-mode)



(provide 'config-vcs)
