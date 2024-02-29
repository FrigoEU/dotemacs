;; -*- lexical-binding: t -*-

(use-package doom-themes
  :straight t
  )

(use-package modus-themes
  :straight t
  )

(defun load-theme-and-color-modeline ()
  (progn
    (load-theme 'doom-one)
    ;; (load-theme 'modus-operandi-tinted) ;; light
    ;; (load-theme 'modus-vivendi-tinted)

    ;; Color modeline according to Normal / Insert / Visual mode
    (defvar dotemacs--original-mode-line-bg (face-background 'mode-line))
    (defadvice evil-set-cursor-color (after dotemacs activate)
      (cond ((evil-emacs-state-p)
             (set-face-background 'mode-line "#002244"))
            ((evil-insert-state-p)
             (set-face-background 'mode-line "#666600"))
            ((evil-visual-state-p)
             (set-face-background 'mode-line "#440044"))
            (t
             (set-face-background 'mode-line dotemacs--original-mode-line-bg))))
    )
  )

(use-package emacs
  :hook
  (after-init-hook . load-theme-and-color-modeline)
  )

(set-frame-font "Pragmatapro 16" nil t)


(line-number-mode t)
(column-number-mode t)

;; !!!
;; M-x nerd-icons-install-fonts 
;;
(use-package doom-modeline
  :straight t
  :init
  (doom-modeline-mode t)
  :config
  (setq doom-modeline-time nil)
  (setq doom-modeline-time-icon nil)
  (setq doom-modeline-icon t)
  (setq doom-modeline-unicode-fallback nil)
  (setq doom-modeline-percent-position nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-modal nil)
  (setq doom-modeline-buffer-file-name-style 'file-name)
  )


;; Color Identifiers is a minor mode for Emacs that highlights each source code identifier uniquely based on its name
;; -> Interessant maar ook zot
;; (/boot/delayed-init
;;  (require-package 'color-identifiers-mode)
;;  (global-color-identifiers-mode)
;;  (diminish 'color-identifiers-mode))


;; lags like hell
;; (require-package 'highlight-symbol)
;; (setq highlight-symbol-idle-delay 0.3)
;; (add-hook 'prog-mode-hook 'highlight-symbol-mode)


;; (require-package 'highlight-numbers)
;; (add-hook 'prog-mode-hook 'highlight-numbers-mode)


;; (require-package 'highlight-quoted)
;; (add-hook 'prog-mode-hook 'highlight-quoted-mode)


;; This Emacs library provides a global mode which displays ugly form feed characters as tidy horizontal rules.
(use-package page-break-lines
  :straight t
  :init
  (global-page-break-lines-mode))

(add-hook 'find-file-hook #'hl-line-mode)

;; (if (fboundp #'display-line-numbers-mode)
;;     (add-hook 'find-file-hook #'display-line-numbers-mode)
;;   (add-hook 'find-file-hook 'linum-mode))

(provide 'config-eyecandy)
