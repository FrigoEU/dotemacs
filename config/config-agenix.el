(use-package agenix
  :straight t
  ;; envrc-global-mode is NOT enough: it's a minor mode, so it activates *after*
  ;; agenix-mode has already run its decrypt during major-mode init and failed to
  ;; find `age'. This puts the direnv PATH in place first.
  :hook (agenix-pre-mode-hook . envrc-mode))
