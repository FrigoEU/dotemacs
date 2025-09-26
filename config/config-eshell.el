;; -*- lexical-binding: t -*-

(use-package eshell
  :straight t
  :hook (eshell-mode-hook . /eshell/eshell-mode-hook)
  :config
  (evil-set-initial-state 'eshell-mode 'insert)
  (setq eshell-directory-name (concat dotemacs-cache-directory "eshell"))
  (setq eshell-buffer-maximum-lines 20000)
  (setq eshell-scroll-to-bottom-on-input 'this)
  (setq eshell-aliases-file (concat user-emacs-directory ".eshell-aliases"))
  (setq eshell-glob-case-insensitive t)
  (setq eshell-error-if-no-glob t)
  (setq eshell-history-size (* 10 1024))
  (setq eshell-hist-ignoredups t)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-prompt-function
        (lambda ()
          (concat (propertize (abbreviate-file-name (eshell/pwd)) 'face 'eshell-prompt)
                  (propertize " λ " 'face 'font-lock-constant-face))))
  (setq eshell-prompt-regexp "^[^#$\n]* [#λ ] ")
  :bind ("C-h" . nil)
  )


(when (not (eq system-type 'windows-nt))
  (use-package eat
    :straight (:type git
                     :host codeberg
                     :repo "akib/emacs-eat"
                     :files ("*.el" ("term" "term/*.el") "*.texi"
                             "*.ti" ("terminfo/e" "terminfo/e/*")
                             ("terminfo/65" "terminfo/65/*")
                             ("integration" "integration/*")
                             (:exclude ".dir-locals.el" "*-tests.el")))
    :hook (eshell-load-hook . eat-eshell-mode)
    :config
    ))

;; (defun eshell/ff (&rest args)
;;   "Opens a file in emacs."
;;   (when (not (null args))
;;     (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))


;; (defun eshell/h ()
;;   "Quickly run a previous command."
;;   (insert (completing-read
;;            "Run previous command: "
;;            (delete-dups (ring-elements eshell-history-ring))
;;            nil
;;            t)))


;; (defun eshell/ssh-tramp (&rest args)
;;   (insert (apply #'format "cd /ssh:%s:\\~" args))
;;   (eshell-send-input))


(defun /eshell/color-filter (string)
  (let ((case-fold-search nil)
        (lines (split-string string "\n")))
    (cl-loop for line in lines
             do (progn
                  (cond ((string-match "\\[DEBUG\\]" line)
                         (put-text-property 0 (length line) 'font-lock-face font-lock-comment-face line))
                        ((string-match "\\[INFO\\]" line)
                         (put-text-property 0 (length line) 'font-lock-face compilation-info-face line))
                        ((string-match "\\[WARN\\]" line)
                         (put-text-property 0 (length line) 'font-lock-face compilation-warning-face line))
                        ((string-match "\\[ERROR\\]" line)
                         (put-text-property 0 (length line) 'font-lock-face compilation-error-face line)))))
    (mapconcat 'identity lines "\n")))

(after 'em-term
  (setq eshell-visual-commands (list "htop" "nix-shell")))

(defun /eshell/eshell-mode-hook ()
  (add-to-list 'eshell-output-filter-functions #'eshell-truncate-buffer)
  (add-to-list 'eshell-preoutput-filter-functions #'/eshell/color-filter)
  (buffer-disable-undo)

  ;; get rid of annoying 'terminal is not fully functional' warning
  (when (executable-find "cat")
    (setenv "PAGER" "cat"))

  (setenv "NODE_NO_READLINE" "1"))

(use-package xterm-color
  :straight t
  :hook (comint-preoutput-filter-functions . xterm-color-filter)
  :config
  )
(setq comint-output-filter-functions (remove #'ansi-color-process-output comint-output-filter-functions))

(after 'esh-mode
  (add-to-list 'eshell-preoutput-filter-functions #'xterm-color-filter)
  (add-hook 'eshell-mode-hook
            (lambda ()
              (setenv "TERM" "xterm-256color")
              (setq xterm-color-preserve-properties t))))

(defun pcomplete/npm ()
  "Completion for `npm'."
  ;; Completion for the command argument.
  (pcomplete-here* '("install" "run" "start" "publish" "update"))

  ;; complete files/dirs forever if the command is `add' or `rm'.
  (when (pcomplete-match (regexp-opt '("run")) 1)
    (pcomplete-here
     (let* ((file (json-read-file "./package.json")))
       (if file
           (let* (
                  (scripts-1 (cdr (assoc 'scripts file)))
                  (scripts (cl-loop for (key . value) in scripts-1
                                    collect (cons (symbol-name key) value)))
                  (sorted-scripts (sort scripts (lambda (a b) (string< (car a) (car b)))))
                  )
             sorted-scripts
             )
         )
       )
     )))

(provide 'config-eshell)
