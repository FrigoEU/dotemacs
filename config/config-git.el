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

(use-package diff-hl
  :straight t
  :demand t
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; Borders are drawn in the face's foreground, which our theme leaves unset
  ;; (falling back to the near-white `fringe' foreground).  Use the theme's
  ;; colour for a bright border around a dimmed fill instead, in derived faces
  ;; so re-deriving after a theme change never compounds.
  (defun /git/diff-hl-faces (&rest _)
    (dolist (type '(insert change delete))
      (let* ((base (intern (format "diff-hl-%s" type)))
             (face (intern (format "/git/diff-hl-%s" type)))
             (bright (face-attribute base :background nil t))
             (bg (face-attribute 'default :background)))
        (unless (facep face) (make-empty-face face))
        (when (and (color-defined-p bright) (color-defined-p bg))
          (set-face-attribute face nil
                              :foreground bright
                              :background (apply #'color-rgb-to-hex
                                                 (append (color-blend (color-name-to-rgb bright)
                                                                      (color-name-to-rgb bg)
                                                                      0.35)
                                                         '(2))))))))
  (/git/diff-hl-faces)
  (add-hook 'enable-theme-functions #'/git/diff-hl-faces)
  (setq diff-hl-fringe-face-function
        (lambda (type pos)
          (let ((face (intern (format "/git/diff-hl-%s" type))))
            (if (facep face) face (diff-hl-fringe-face-from-type type pos)))))
  (global-diff-hl-mode +1)
  ;; Update the gutter as you type, not only on save.
  (diff-hl-flydiff-mode +1))

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
