;;;  -*- lexical-binding: t; -*-

(use-package perspective
  :straight t
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (persp-mode)
  :config
  (setq persp-sort 'created)
  (persp-turn-off-modestring)


  )

;; provides 'projectile-persp-switch-project
(use-package persp-projectile
  :straight t
  :after perspective
  :config

  ;; Close "main" perspective = dashboard after selecting a project
  (defun kill-main-persp (proj)
    (progn (persp-kill "main") proj))
  (advice-add
   'projectile-persp-switch-project
   :after
   #'kill-main-persp
   )
  )



(after [consult perspective]
  (consult-customize consult--source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  )

(setq sql-postgres-login-params nil)
(setq sql-connection-alist
      '((aperi       (sql-product 'postgres) (sql-database "aperi" (sql-user "aperi") (sql-password "aperi") (sql-server "localhost")))
        (urwebschool (sql-product 'postgres) (sql-database "urwebschool") (sql-user "simon") (sql-server "localhost"))
        ))

(defun new-shell (i)
  (if (eq simon/eshell-or-vterm 'eshell)
      (eshell i)
    (vterm-new)))

(defun rename-shell-buffer (s)
  (if (eq simon/eshell-or-vterm 'eshell)
      (rename-buffer (concat "*eshell* " s))
    (rename-buffer (concat "*vterm* " s))
    ))

(defun shell-insert (s)
  (if (eq simon/eshell-or-vterm 'eshell)
      (insert s)
    (vterm-insert s)
    ))

(defun shell-send-input ()
  (if (eq simon/eshell-or-vterm 'eshell)
      (eshell-send-input)
    (vterm-send-return)
    ))

(defun urwebschool-logs ()
  (interactive)
  (let ((default-directory "/home/simon/projects/school"))
    (persp-switch "school-logs")

    ;; (new-shell 900)
    ;; (rename-shell-buffer "proxy")
    ;; (shell-insert "npm run proxy")
    ;; (shell-send-input)

    ;; (evil-window-vsplit)

    (new-shell 902)
    (rename-shell-buffer "TypeScript")
    (shell-insert "nodemon")
    (shell-send-input)
    )
  )

(defun urwebschool-sql ()
  (interactive)
  (progn
    (persp-switch "school-sql")
    (find-file "/home/simon/projects/school/sqlscratchpad.sql")
    (sql-connect "urwebschool")
    )
  )

(defun aperi-sql ()
  (interactive)
  (progn
    (persp-switch "aperi-sql")
    (find-file "/home/simon/projects/yunction/sqlscratchpad.sql")
    (sql-connect "aperi")
    )
  )


(defun aperi-logs ()
  (interactive)
  (let ((default-directory "/home/simon/projects/yunction"))
    (persp-switch "aperi-logs")
    (new-shell 800)
    (rename-shell-buffer "engine")
    (shell-insert "npm run engine")
    (shell-send-input)

    (evil-window-vsplit)

    (new-shell 801)
    (rename-shell-buffer "device")
    (shell-insert "npm run cas")
    (shell-send-input)
    )
  )

(use-package hydra :straight t)

(defun show-workspace-switcher ()
  (interactive)
  (/hydras/workspaces/body)
  )

(defun go-to-workspace-number (num) 
  (let ((name (nth (- num 1) (reverse (persp-names)))))
    (progn
      (hydra-pause-resume)
      (persp-switch name)
      (/hydras/workspaces/body)
      )
    ))

(defun go-to-workspace-1 () (interactive) (go-to-workspace-number 1))
(defun go-to-workspace-2 () (interactive) (go-to-workspace-number 2))
(defun go-to-workspace-3 () (interactive) (go-to-workspace-number 3))
(defun go-to-workspace-4 () (interactive) (go-to-workspace-number 4))
(defun go-to-workspace-5 () (interactive) (go-to-workspace-number 5))
(defun go-to-workspace-6 () (interactive) (go-to-workspace-number 6))
(defun go-to-workspace-7 () (interactive) (go-to-workspace-number 7))
(defun go-to-workspace-8 () (interactive) (go-to-workspace-number 8))
(defun go-to-workspace-9 () (interactive) (go-to-workspace-number 9))

(defun persp-kill-current ()
  (interactive)
  (progn
    (hydra-pause-resume)
    (persp-kill (persp-current-name))
    (persp-switch-by-number 0)
    (/hydras/workspaces/body)
    )
  )

(defun workspace-build-name (name j)
  (concat (if (string= name (persp-current-name))
              (concat "(" (number-to-string j) ")")
            (concat " " (number-to-string j) " "))
          name))

(defhydra /hydras/workspaces (:hint nil)
  "workspaces"
  ("1" (go-to-workspace "1"))
  ("2" (go-to-workspace "2"))
  ("3" (go-to-workspace "3"))
  ("4" (go-to-workspace "4"))
  ("5" (go-to-workspace "5"))
  ("6" (go-to-workspace "6"))
  ("7" (go-to-workspace "7"))
  ("8" (go-to-workspace "8"))
  ("9" (go-to-workspace "9"))
  ("x" persp-kill-current)
  ("p" projectile-persp-switch-project)
  ("<f6>" urwebschool-sql)
  ("<f7>" urwebschool-logs)
  )

;; Can't make real dynamic hydras, so we use the /hint callback to preprocess the predefined hydra
;; Works just as well as transient and is wayyy simpler
(setq /hydras/workspaces/hint
      '(progn
         (define-key /hydras/workspaces/keymap "1" nil)
         (define-key /hydras/workspaces/keymap "2" nil)
         (define-key /hydras/workspaces/keymap "3" nil)
         (define-key /hydras/workspaces/keymap "4" nil)
         (define-key /hydras/workspaces/keymap "5" nil)
         (define-key /hydras/workspaces/keymap "6" nil)
         (define-key /hydras/workspaces/keymap "7" nil)
         (define-key /hydras/workspaces/keymap "8" nil)
         (define-key /hydras/workspaces/keymap "9" nil)
         (cl-mapcar
          (lambda (name cb i)
            (define-key /hydras/workspaces/keymap (number-to-string i) cb)
            )
          (reverse (persp-names))
          '(go-to-workspace-1
            go-to-workspace-2
            go-to-workspace-3
            go-to-workspace-4
            go-to-workspace-5
            go-to-workspace-6
            go-to-workspace-7
            go-to-workspace-8
            go-to-workspace-9
            )
          '(1 2 3 4 5 6 7 8 9)
          )  
         (s-concat
          (string-join
           (cl-mapcar
            'workspace-build-name
            (reverse (persp-names))
            '(1 2 3 4 5 6 7 8 9)
            )
           "  "
           )
          "\n\n"
          " x Delete       <F6> urwebschool-sql \n"
          " p Project      <F7> urwebschool-logs"
          )
         ))

