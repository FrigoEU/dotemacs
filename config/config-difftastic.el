;; -*- lexical-binding: t -*-

(use-package difftastic
  :straight t
  :after magit
  :config
  (eval-after-load 'magit-diff
    '(transient-append-suffix 'magit-diff '(-1 -1)
       [("D" "Difftastic diff (dwim)" difftastic-magit-diff)
        ("S" "Difftastic show" difftastic-magit-show)])))

(provide 'config-difftastic)
