;; -*- lexical-binding: t -*-

(use-package ghostel
  :straight t
  :config
  (setq ghostel-buffer-name-function
        (lambda (title)
          (format "👻 %s" (or title ""))))
  ;; `auto' only enables the outbound-ssh terminfo auto-install wrapper when
  ;; `ghostel-tramp-shell-integration' is also on (it isn't, by default).
  ;; Force it on so a plain `ssh host' from inside a ghostel buffer probes
  ;; and installs xterm-ghostty terminfo instead of leaking an
  ;; unrecognized TERM to hosts that don't have it (breaks readline/psql).
  (setq ghostel-ssh-install-terminfo t))

(use-package evil-ghostel
  :straight t
  :after (ghostel evil)
  :hook (ghostel-mode-hook . evil-ghostel-mode))

(provide 'config-ghostel)
