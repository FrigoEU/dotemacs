;; Use https://github.com/karthink/gptel !!
(use-package aidermacs
  :straight t
  ;; :bind (("C-c a" . aidermacs-transient-menu))
  :config
  ;; (setenv "GEMINI_API_KEY" "") -- see flake.nix in school proj
  (setq aidermacs-program "/nix/store/j3jchsf49pzlik84cqjgg41sd5zrz16v-python3.12-aider-chat-0.82.1/bin/aider")
  ;; (setq aidermacs-default-model "gemini/gemini-2.5-flash-preview-04-17")
  (setq aidermacs-default-model "gemini/gemini-2.5-pro-preview-03-25")
  ;; :custom
  ;; set in .env file
  ;; (aidermacs-use-architect-mode t)
  )
