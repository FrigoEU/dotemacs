;; -*- lexical-binding: t -*-

(use-package ghostel
  :straight t
  :config
  (setq ghostel-buffer-name-function
        (lambda (title)
          (format "👻 %s" (or title "")))))

(use-package evil-ghostel
  :straight t
  :after (ghostel evil)
  :hook (ghostel-mode-hook . evil-ghostel-mode))

(provide 'config-ghostel)
