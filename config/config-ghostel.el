;; -*- lexical-binding: t -*-

(use-package ghostel
  :straight t
  :config
  (setq ghostel-buffer-name-function
        (lambda (title)
          (format "👻 %s" (or title ""))))
  ;; TRAMP-launched buffers (`M-x ghostel' from a /ssh:host:/ default-directory,
  ;; e.g. `simon/ssh-classyprod') only push the bundled xterm-ghostty terminfo
  ;; and shell-integration scripts to the remote when
  ;; `ghostel-tramp-shell-integration' is on — `ghostel-ssh-install-terminfo'
  ;; alone is a no-op for that path (it only governs a plain `ssh host' typed
  ;; inside an already-local ghostel buffer). Without the push, hosts lacking
  ;; the xterm-ghostty terminfo entry fall back to a TERM ncurses can't fully
  ;; resolve, which is what breaks `less'/readline in things like `psql'
  ;; ("terminal not fully functional").
  (setq ghostel-tramp-shell-integration t)
  ;; `auto' only enables the outbound-ssh terminfo auto-install wrapper when
  ;; `ghostel-tramp-shell-integration' is also on. Force it on so both a plain
  ;; `ssh host' from inside a ghostel buffer AND TRAMP-launched buffers probe
  ;; and install xterm-ghostty terminfo instead of leaking an unrecognized
  ;; TERM to hosts that don't have it (breaks readline/psql).
  (setq ghostel-ssh-install-terminfo t))

(use-package evil-ghostel
  :straight t
  :after (ghostel evil)
  :hook (ghostel-mode-hook . evil-ghostel-mode))

(defun list-ghostel-buffers ()
  "Return a list of all buffers whose major mode is derived from `ghostel-mode' in the current perspective."
  (interactive)
  (let (ghostel-buffers)
    (dolist (buf (persp-current-buffer-names))
      (with-current-buffer buf
        (when (derived-mode-p 'ghostel-mode)
          (push (get-buffer buf) ghostel-buffers))))
    ghostel-buffers))

(defvar consult--source-ghostel
  '(
    :name ""
    :category 'buffer
    :items (lambda ()
             (mapcar (lambda (buf) (cons (buffer-name buf) buf))
                     (list-ghostel-buffers)))
    :action (lambda (buf)
              (switch-to-buffer buf))
    :prompt "Switch to Ghostel: "
    :require-match nil
    :new (lambda (n)
           (let ((buf (ghostel-project t)))
             (with-current-buffer buf
               (rename-buffer (funcall ghostel-buffer-name-function n) t))
             buf))
    :consult-preview-buffer t)
  "Consult source for ghostel buffers.")

(defun simon-completing-read-ghostel-buffers ()
  "Ghostel buffers."
  (interactive)
  (let ((ghostel-buffers (list-ghostel-buffers)))
    (if (= (length ghostel-buffers) 0)
        (let ((buf (ghostel-project t)))
          (with-current-buffer buf
            (rename-buffer (funcall ghostel-buffer-name-function "first") t))
          buf)
      (consult--multi (list consult--source-ghostel)))))

(defvar simon-game-terminal-buffer-name "👻 game"
  "Fixed name for the ghostel buffer that runs the game via `make go'.")

(defun simon-restart-game ()
  "Interrupt and re-run `make go' in `simon-game-terminal-buffer-name'.
Creates that buffer on first use if it doesn't exist yet, rooted at
the current buffer's project root."
  (interactive)
  (let* ((existing (get-buffer simon-game-terminal-buffer-name))
         (buf (let ((ghostel-buffer-name simon-game-terminal-buffer-name)
                    (default-directory (or (projectile-project-root) default-directory)))
                (ghostel))))
    (with-current-buffer buf
      (if existing
          (progn
            (ghostel-send-C-c)
            (sit-for 0.3))
        ;; Freeze the name: otherwise the shell's OSC title report
        ;; (via `ghostel-buffer-name-function') renames it away from
        ;; `simon-game-terminal-buffer-name' on the next run.
        (setq-local ghostel-buffer-name-function nil))
      (ghostel-send-string "make go\n"))))

(provide 'config-ghostel)
