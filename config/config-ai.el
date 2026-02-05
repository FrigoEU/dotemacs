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
  ;; Disable save prompt since we auto-save transcripts
  (setq shell-maker-prompt-before-killing-buffer nil)
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))

  ;; Save transcripts to ~/Documents/claude_transcripts/<date-time>.txt
  (setq agent-shell-transcript-file-path-function
        (lambda ()
          (let* ((dir (expand-file-name "~/Documents/claude_transcripts"))
                 (filename (format-time-string "%Y-%m-%d-%H-%M-%S.txt")))
            (unless (file-directory-p dir)
              (make-directory dir t))
            (expand-file-name filename dir))))

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
  (evil-define-key 'normal agent-shell-mode-map (kbd "<tab>") #'agent-shell-next-item)
  ;; Configure *agent-shell-diff* buffers to start in Emacs state
  (add-hook 'diff-mode-hook
	          (lambda ()
	            (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
		            (evil-emacs-state))))

  (add-hook 'agent-shell-mode-hook
            (lambda ()
              (evil-local-set-key 'normal "!" nil)))

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

(use-package agent-shell-manager
  :straight (:host github :repo "jethrokuan/agent-shell-manager")
  :config
  (defvar consult--source-agent-shell
    `(:name ""
            :category buffer
            :items
            ,(lambda ()
               (let* ((buffers (agent-shell-buffers))
                      (buffers (if (listp buffers) buffers (list buffers)))
                      (buffers (seq-filter #'buffer-live-p buffers)))
                 (mapcar
                  (lambda (buffer)
                    (let* ((name (buffer-name buffer))
                           (project (if (string-match " @ \\(.+\\)$" name)
                                        (abbreviate-file-name (match-string 1 name))
                                      ""))
                           (status (with-current-buffer buffer
                                     (agent-shell-manager--get-status buffer)))
                           (status-face (agent-shell-manager--status-face status))
                           (display (format "%-50s %-12s %s"
                                            name
                                            (propertize status 'face status-face)
                                            (propertize project 'face 'font-lock-comment-face))))
                      (cons display buffer)))
                  buffers)))
            :action ,(lambda (buffer)
                       (when buffer
                         (let ((other-persp (persp-buffer-in-other-p buffer)))
                           (when other-persp
                             (persp-switch (cdr other-persp))))
                         (switch-to-buffer buffer)))
            :new ,(lambda (_) (agent-shell t)))
    "Consult source for agent-shell buffers.")

  (defun consult-agent-shell ()
    "Select an agent-shell buffer using consult with project and status annotations.
Type a non-matching name and press RET to create a new agent-shell."
    (interactive)
    (let* ((buffers (agent-shell-buffers))
           (buffers (if (listp buffers) buffers (list buffers)))
           (buffers (seq-filter #'buffer-live-p buffers)))
      (if (null buffers)
          (agent-shell t)
        (consult--multi (list consult--source-agent-shell))))))
