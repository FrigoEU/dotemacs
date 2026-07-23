;; -*- lexical-binding: t -*-

(use-package magit-delta
  :straight t
  :hook (magit-mode . magit-delta-mode)
  :config
  ;; delta's own syntax highlighting clashes with the editor's; keep only
  ;; the line-level +/- coloring.
  (setq magit-delta-delta-args
        '("--max-line-distance" "0.6"
          "--syntax-theme" "none"
          "--color-only")))

(provide 'config-delta)
