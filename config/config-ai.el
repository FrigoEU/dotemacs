;; Use https://github.com/karthink/gptel !!

;; (use-package aidermacs
;;   :straight t
;;   ;; :bind (("C-c a" . aidermacs-transient-menu))
;;   :config
;;   ;; (setenv "GEMINI_API_KEY" (getenv "GOOGLE_CLOUD_PLATFORM_API_KEY"))  ;; See .secrets
;;   (setq aidermacs-program "/nix/store/j3jchsf49pzlik84cqjgg41sd5zrz16v-python3.12-aider-chat-0.82.1/bin/aider")
;;   ;; (setq aidermacs-default-model "gemini/gemini-2.5-flash-preview-04-17")
;;   ;; (setq aidermacs-default-model "gemini/gemini-2.5-pro-preview-03-25")
;;   ;; :custom
;;   ;; set in .env file
;;   (setq aidermacs-use-architect-mode 1)
;;   )


(use-package gptel
  :straight t
  ;; :bind (("C-c a" . aidermacs-transient-menu))
  :config
  (setq gptel-include-reasoning nil)
  ;; (setq
  ;;  gptel-model 'gemini-2.5-pro-preview-05-06
  ;;  gptel-backend (gptel-make-gemini "Gemini"
  ;;                                   :key (getenv "GOOGLE_CLOUD_PLATFORM_API_KEY")
  ;;                                   :stream t))
  (setq gptel-model 'openai/gpt-5.1
        gptel-backend
        (gptel-make-openai "OpenRouter"               ;Any name you want
          :host "openrouter.ai"
          :endpoint "/api/v1/chat/completions"
          :stream t
          :key (getenv "OPENROUTERAI_KEY")                   ;can be a function that returns the key
          :models '(openai/gpt-5.1
                    google/gemini-2.5-pro)))
  (if (eq simon/lsp-client 'eglot)
      (evil-define-key 'visual eglot-mode-map (kbd ", i") 'gptel-rewrite))
  )

(use-package agent-shell
  :straight t
  :config
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  ;; Don't set environment here - we'll advise the client maker instead
  (setq agent-shell-anthropic-claude-environment nil)
  (setq agent-shell-preferred-agent-config
        (agent-shell-anthropic-make-claude-code-config))

  ;; Advise the client maker to dynamically inherit the current buffer's environment
  ;; This ensures direnv/envrc environment variables (like PATH with tshark) are available
  (defun simon/inject-direnv-environment (orig-fun &rest args)
    "Inject current buffer's process-environment into agent-shell client."
    (let ((agent-shell-anthropic-claude-environment
           (agent-shell-make-environment-variables :inherit-env t)))
      (apply orig-fun args)))

  (advice-add 'agent-shell-anthropic-make-claude-client
              :around #'simon/inject-direnv-environment)

  (evil-define-key 'insert agent-shell-mode-map (kbd "RET") #'newline)
  (evil-define-key 'normal agent-shell-mode-map (kbd "RET") #'comint-send-input)
  (evil-define-key 'normal agent-shell-mode-map (kbd "C-<tab>") #'agent-shell-cycle-session-mode)
  (evil-define-key 'insert agent-shell-mode-map (kbd "C-<tab>") #'agent-shell-cycle-session-mode)
  ;; Configure *agent-shell-diff* buffers to start in Emacs state
  (add-hook 'diff-mode-hook
	    (lambda ()
	      (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
		(evil-emacs-state))))
  (add-hook 'agent-shell-mode-hook
            (lambda ()
              (define-key evil-normal-state-map "!" nil)))

  ;; Making icon in graphical header a bit smaller
  (advice-add
   'agent-shell--make-header :around
   (lambda (fn state &rest args)
     (let ((orig-default-font-height (symbol-function 'default-font-height)))
       (cl-letf (((symbol-function 'default-font-height)
                  (lambda (&rest fh-args)
                    (* 0.7 (apply orig-default-font-height fh-args)))))
         (apply fn state args)))))
  )
