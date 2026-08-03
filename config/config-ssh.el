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

(provide 'config-ssh)
