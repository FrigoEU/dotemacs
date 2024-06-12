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

(defun workspace-switcher ()
  (interactive)
  (progn
    (persp-switch-last)
    (show-workspace-switcher)
    )
  )

(defun show-transient-below (l)
  (progn
    ;; Temporary change to how we want transient to show up
    ;; We always want this to go full length over the bottom
    ;; This option applies to all transient menus (including eg: magit)
    ;; So we roll it back after our own
    (setq transient-display-buffer-action
          '(display-buffer-in-side-window
            (side . bottom)
            (inhibit-same-window . nil)
            (window-parameters (no-other-window . t)))
          )
    (funcall l)
    (setq transient-display-buffer-action
          '(display-buffer-below-selected)
          )
    )
  )

(defun show-workspace-switcher ()
  (interactive)
  (show-transient-below 'workspace-transient)
  )

(transient-define-prefix workspace-transient ()
  "test"
  :transient-non-suffix 'transient--do-quit-all ;; close transient state and popup buffer immediately when we use any other keybind
  ["Existing Workspaces"
   :class transient-row
   :setup-children
   (lambda (_els)
     (transient-parse-suffixes
      'workspace-transient
      (let ((i 0))
        (mapcar
         (lambda (name)
           (progn
             (cl-incf i)
             (let ((j i))
               (list
                (if (string= name (persp-current-name))
                    (concat "(" (number-to-string j) ")")
                  (concat " " (number-to-string j) " "))
                name
                (lambda () (interactive)
                  (progn
                    (persp-switch name)
                    (show-workspace-switcher)
                    ))
                )
               )
             ))
         (reverse (persp-names))
         )))
     )
   ]
  [
   ;; :class transient-row
   ["Modify"
    ("n" "New" persp-switch ;; :transient transient--do-stay
     )
    ("x" "Delete" (lambda ()
                    (interactive)
                    (progn
                      (persp-kill (persp-current-name))
                      (persp-switch-by-number 0)
                      (show-workspace-switcher)
                      )))
    ]
   ["Premade"
    ("<f6>" "School sql" urwebschool-sql)
    ("<f7>" "School logs" urwebschool-logs)
    ("<f8>" "Aperi sql" aperi-sql)
    ("<f9>" "Aperi logs" aperi-logs)
    ]
   ]
  )

(setq sql-postgres-login-params nil)
(setq sql-connection-alist
      '((aperi       (sql-product 'postgres) (sql-database "aperi" (sql-user "aperi") (sql-password "aperi") (sql-server "localhost")))
        (urwebschool (sql-product 'postgres) (sql-database "urwebschool") (sql-user "simon") (sql-server "localhost"))
        ))

(defun urwebschool-sql ()
  (interactive)
  (progn
    (persp-switch "school-sql")
    (find-file "/home/simon/ur-proj/school/sqlscratchpad.sql")
    (sql-connect "urwebschool")
    )
  )

;; (defun urwebschool-sql-hamaril ()
;;   (interactive)
;;   (progn
;;     (+workspace/new-named "school-sql-hamaril")
;;     (find-file "/home/simon/ur-proj/school/sqlscratchpad.sql")
;;     (let ((default-directory "/ssh:root@classyprod|sudo:postgres@classyprod:"))
;;       (sql-connect "hamaril"))
;;     )
;;   )


(defun urwebschool-logs ()
  (interactive)
  (let ((default-directory "/home/simon/ur-proj/school"))
    (persp-switch "school-logs")
    (vterm-new)
    (rename-buffer "*vterm* proxy")
    (vterm-insert "npm run proxy")
    (vterm-send-return)

    (evil-window-vsplit)

    (vterm-new)
    (rename-buffer "*vterm* URWEB")
    (vterm-insert "./school.exe")
    (vterm-send-return)

    (evil-window-vsplit)

    (vterm-new)
    (rename-buffer "*vterm* TypeScript")
    (vterm-insert "nodemon")
    (vterm-send-return)
    )
  )

(defun aperi-sql ()
  (interactive)
  (progn
    (persp-switch "aperi-sql")
    (find-file "/home/simon/projects/aperi-new/sqlscratchpad.sql")
    (sql-connect "aperi")
    )
  )


(defun aperi-logs ()
  (interactive)
  (let ((default-directory "/home/simon/projects/aperi-new"))
    (persp-switch "aperi-logs")
    (vterm-new)
    (rename-buffer "*vterm* engine")
    (vterm-insert "npm run engine")
    (vterm-send-return)

    (evil-window-vsplit)

    (vterm-new)
    (rename-buffer "*vterm* device")
    (vterm-insert "npm run device_ssl")
    (vterm-send-return)
    )
  )
