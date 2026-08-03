;; -*- lexical-binding: t -*-

(use-package ghostel
  :straight t
  :config
  (setq ghostel-buffer-name-function
        (lambda (title)
          (format "👻 %s" (or title ""))))
  ;; `auto' only enables the outbound-ssh terminfo auto-install wrapper when
  ;; `ghostel-tramp-shell-integration' is also on (it isn't, by default).
  ;; Force it on so a plain `ssh host' from inside a ghostel buffer probes
  ;; and installs xterm-ghostty terminfo instead of leaking an
  ;; unrecognized TERM to hosts that don't have it (breaks readline/psql).
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

(provide 'config-ghostel)
