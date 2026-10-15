(use-package reviewer
  :straight (reviewer :type git :host github :repo "SreenivasVRao/reviewer.el")
  :hook (after-init . reviewer-global-mode))
