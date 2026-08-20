;; By default TRAMP redirects the remote shell's $HISTFILE to
;; ~/.tramp_history (see `tramp-histfile-override'), so commands typed in
;; these ghostel/TRAMP terminal sessions never reach the real
;; ~/.bash_history on the remote host. That's the right default for TRAMP's
;; own background file-management shells (dired, find-file, ...), but wrong
;; for these interactive terminal sessions. Disable the override just for
;; these hosts via a connection-local profile.
(connection-local-set-profile-variables
 'simon/ssh-real-history
 '((tramp-histfile-override . nil)))

(dolist (host '("classyprod" "classyacc" "192.168.1.22"))
  (connection-local-set-profiles
   `(:application tramp :protocol "ssh" :user "root" :machine ,host)
   'simon/ssh-real-history))

(defun simon/ssh-classyprod ()
  "Open a terminal on classyprod as root, via TRAMP."
  (interactive)
  (let ((default-directory "/ssh:root@classyprod:/"))
    (let ((buf (ghostel t)))
      (with-current-buffer buf
        (rename-buffer "📡 ssh classyprod" t)))))

(defun simon/ssh-classyacc ()
  "Open a terminal on classyprod as root, via TRAMP."
  (interactive)
  (let ((default-directory "/ssh:root@classyacc:/"))
    (let ((buf (ghostel t)))
      (with-current-buffer buf
        (rename-buffer "📡 ssh classyacc" t)))))

(defun simon/ssh-nobi-lamp ()
  "Open a terminal on classyprod as root, via TRAMP."
  (interactive)
  (let ((default-directory "/ssh:root@192.168.1.22:/"))
    (let ((buf (ghostel t)))
      (with-current-buffer buf
        (rename-buffer "📡 ssh nobi-lamp" t)))))

(provide 'config-ssh)
