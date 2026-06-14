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
  (setq
   gptel-model 'gemini-3-flash-preview
   gptel-backend (gptel-make-gemini "Gemini"
                   :key (getenv "GOOGLE_CLOUD_PLATFORM_API_KEY")
                   :stream t))
  ;; (setq ;; gptel-model 'openai/gpt-5.1
  ;;  gptel-api-key (getenv "OPENAI_KEY")
  ;;  ;; (gptel-make-openai "OpenRouter"               ;Any name you want
  ;;  ;;   :host "openrouter.ai"
  ;;  ;;   :endpoint "/api/v1/chat/completions"
  ;;  ;;   :stream t
  ;;  ;;   :key (getenv "OPENROUTERAI_KEY")                   ;can be a function that returns the key
  ;;  ;;   :models '(openai/gpt-5.1
  ;;  ;;             google/gemini-2.5-pro))
  ;;  )
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

  ;; Switch between Anthropic subscriptions by pointing Claude Code at different
  ;; config dirs (each holds its own OAuth credentials). One-time setup for a
  ;; non-default account:
  ;;   CLAUDE_CONFIG_DIR=~/.claude-company claude   then run /login in it.
  (defvar simon/claude-accounts
    '(("personal" . "~/.claude")
      ("company"  . "~/.claude-company"))
    "Alist of account name -> CLAUDE_CONFIG_DIR for agent-shell.")

  (defvar simon/claude-account "personal"
    "Currently selected account name (a key in `simon/claude-accounts').")

  (defun simon/claude-config-dir ()
    "Return CLAUDE_CONFIG_DIR for the currently selected account."
    (expand-file-name
     (or (cdr (assoc simon/claude-account simon/claude-accounts)) "~/.claude")))

  (defun simon/claude-switch-account (account)
    "Select which Anthropic subscription ACCOUNT agent-shell uses.
Affects newly started shells; existing shells keep their account."
    (interactive
     (list (completing-read
            (format "Claude account (current: %s): " simon/claude-account)
            (mapcar #'car simon/claude-accounts) nil t)))
    (setq simon/claude-account account)
    (message "Claude account: %s (%s)" account (simon/claude-config-dir)))

  ;; Advise the client maker to dynamically inherit the current buffer's environment
  ;; This ensures direnv/envrc environment variables (like PATH with tshark) are available
  (defun simon/inject-direnv-environment (orig-fun &rest args)
    "Inject current buffer's process-environment into agent-shell client."
    (let ((agent-shell-anthropic-claude-environment
           (agent-shell-make-environment-variables
            "CLAUDE_CONFIG_DIR" (simon/claude-config-dir)
            :inherit-env t)))
      (apply orig-fun args)))

  (advice-add 'agent-shell-anthropic-make-claude-client
              :around #'simon/inject-direnv-environment)

  (defun simon/inject-direnv-environment-pi (orig-fun &rest args)
    "Inject current buffer's process-environment into the Pi agent-shell client."
    (let ((agent-shell-pi-environment
           (agent-shell-make-environment-variables :inherit-env t)))
      (apply orig-fun args)))

  (advice-add 'agent-shell-pi-make-client
              :around #'simon/inject-direnv-environment-pi)

  ;; oh-my-pi (omp): a Pi fork that speaks ACP via `omp acp'.
  ;; https://github.com/can1357/oh-my-pi
  ;; No built-in agent-shell adapter, so we define our own config mirroring Pi.
  (defvar simon/omp-acp-command '("omp" "acp")
    "Command and parameters for the oh-my-pi (omp) ACP server.")

  (defvar simon/omp-environment nil
    "Environment variables for the omp client.")

  (cl-defun simon/omp-make-client (&key buffer)
    "Create an omp ACP client using BUFFER as context.

omp uses OAuth login, so no API key environment variables are
required by default."
    (unless buffer
      (error "Missing required argument: :buffer"))
    (agent-shell--make-acp-client
     :command (car simon/omp-acp-command)
     :command-params (cdr simon/omp-acp-command)
     :environment-variables simon/omp-environment
     :context-buffer buffer))

  (defun simon/omp-make-agent-config ()
    "Create an oh-my-pi (omp) agent configuration."
    (agent-shell-make-agent-config
     :identifier 'omp
     :mode-line-name "omp"
     :buffer-name "omp"
     :shell-prompt "omp> "
     :shell-prompt-regexp "omp> "
     :client-maker (lambda (buffer)
                     (simon/omp-make-client :buffer buffer))
     :install-instructions "Install omp from https://github.com/can1357/oh-my-pi
  curl -fsSL https://omp.sh/install | sh"))

  (defun simon/inject-direnv-environment-omp (orig-fun &rest args)
    "Inject current buffer's process-environment into the omp agent-shell client."
    (let ((simon/omp-environment
           (agent-shell-make-environment-variables :inherit-env t)))
      (apply orig-fun args)))

  (advice-add 'simon/omp-make-client
              :around #'simon/inject-direnv-environment-omp)

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

  (defun simon/agent-shell-review ()
    "Start a new agent-shell buffer named 'review' and submit a review prompt."
    (interactive)
    (let ((buf (agent-shell-start :config (agent-shell--resolve-preferred-config))))
      (with-current-buffer buf
        (shell-maker-set-buffer-name buf "🤖 review"))
      (agent-shell-insert :text "please review my changes"
                          :submit t
                          :shell-buffer buf)))

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

(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el"
                   :files ("*.el" (:exclude "demo.gif")))
  :after eat
  :config
  (setq claude-code-terminal-backend 'vterm)
  (claude-code-mode)

  ;; Major-mode-style bindings inside the Claude buffer (under `,`).
  (defun simon/claude-code-submit-from-normal ()
    "Submit the current Claude Code prompt by sending Alt+Enter (ESC CR)."
    (interactive)
    (vterm-send-string "\e[12~"))

  (defun simon/claude-code-buffer-bindings ()
    (evil-local-set-key 'normal (kbd "RET") #'simon/claude-code-submit-from-normal)
    (evil-local-set-key 'normal (kbd ", m") #'claude-code-cycle-mode)
    (evil-local-set-key 'normal (kbd ", t") #'claude-code-toggle)
    (evil-local-set-key 'normal (kbd ", k") #'claude-code-kill)
    (evil-local-set-key 'normal (kbd ", f") #'claude-code-fork)
    (evil-local-set-key 'normal (kbd ", b") #'claude-code-switch-to-buffer)
    (evil-local-set-key 'normal (kbd ", s") #'claude-code-send-command)
    (evil-local-set-key 'normal (kbd ", n") #'claude-code-send-escape)
    (evil-local-set-key 'normal (kbd ", T") #'claude-code-transient)
    (evil-local-set-key 'normal (kbd "?") #'claude-code-transient))
  (add-hook 'claude-code-start-hook #'simon/claude-code-buffer-bindings))

(use-package agent-shell-manager
  :straight (:host github :repo "jethrokuan/agent-shell-manager")
  :config
  (defvar simon/agent-shell-configs
    '(("Claude" . agent-shell-anthropic-make-claude-code-config)
      ("Pi"     . agent-shell-pi-make-agent-config)
      ("omp"    . simon/omp-make-agent-config))
    "Alist of agent name -> config-maker function for new agent-shells.")

  (defun simon/agent-shell-read-config ()
    "Prompt for which agent to use and return its config.
RET accepts the first entry (Claude); type \"Pi\" RET for Pi."
    (let* ((names (mapcar #'car simon/agent-shell-configs))
           (name (completing-read "Agent: " names nil t nil nil (car names)))
           (maker (cdr (assoc name simon/agent-shell-configs))))
      (funcall maker)))

  (defun consult-agent-shell--format-buffer (buffer)
    "Format BUFFER for display in consult-agent-shell."
    (let* ((name (buffer-name buffer))
           (project (abbreviate-file-name
                     (with-current-buffer buffer default-directory)))
           (status (with-current-buffer buffer
                     (agent-shell-manager--get-status buffer)))
           (status-face (agent-shell-manager--status-face status))
           (display (format "%-50s %-12s %s"
                            name
                            (propertize status 'face status-face)
                            (propertize project 'face 'font-lock-comment-face))))
      (cons display buffer)))

  (defun consult-agent-shell--live-buffers ()
    "Return all live agent-shell buffers."
    (let* ((buffers (agent-shell-buffers))
           (buffers (if (listp buffers) buffers (list buffers))))
      (seq-filter #'buffer-live-p buffers)))

  (defvar consult--source-agent-shell
    `(:name "Perspective"
            :category buffer
            :items
            ,(lambda ()
               (let* ((buffers (consult-agent-shell--live-buffers))
                      (current (seq-filter #'persp-is-current-buffer buffers)))
                 (mapcar #'consult-agent-shell--format-buffer current)))
            :action ,(lambda (buffer)
                       (when buffer
                         (switch-to-buffer buffer)))
            :new ,(lambda (name)
                    (let ((buf (agent-shell-start
                                :config (simon/agent-shell-read-config))))
                      (with-current-buffer buf
                        (shell-maker-set-buffer-name
                         buf (concat "🤖 " name))))))
    "Consult source for agent-shell buffers in the current perspective.")

  (defvar consult--source-agent-shell-new
    `(:name "Perspective"
            :items
            ,(lambda ()
               (let* ((buffers (consult-agent-shell--live-buffers))
                      (current (seq-filter #'persp-is-current-buffer buffers)))
                 (unless current
                   (list (propertize "+ new shell" 'face 'italic)))))
            :action ,(lambda (_item)
                       (let ((buf (agent-shell-start
                                   :config (simon/agent-shell-read-config))))
                         (with-current-buffer buf
                           (shell-maker-set-buffer-name buf "🤖")))))
    "Placeholder source shown when no agent-shell buffers exist in the current perspective.")

  (defvar consult--source-agent-shell-other
    `(:name "Other"
            :category buffer
            :items
            ,(lambda ()
               (let ((buffers (consult-agent-shell--live-buffers)))
                 (mapcar #'consult-agent-shell--format-buffer
                         (seq-remove #'persp-is-current-buffer buffers))))
            :action ,(lambda (buffer)
                       (when buffer
                         (let ((other-persp (persp-buffer-in-other-p buffer)))
                           (when other-persp
                             (persp-switch (cdr other-persp))))
                         (switch-to-buffer buffer)))
            :new ,(lambda (_) (agent-shell-new-shell)))
    "Consult source for agent-shell buffers in other perspectives.")

  (defun consult-agent-shell ()
    "Select an agent-shell buffer using consult with project and status annotations.
Buffers are grouped by current perspective vs. other perspectives.
Type a new name and press RET to create a new agent-shell."
    (interactive)
    (consult--multi (list consult--source-agent-shell
                          consult--source-agent-shell-new
                          consult--source-agent-shell-other)
                    :sort nil)))
