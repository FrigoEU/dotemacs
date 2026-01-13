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

(defun workspace-switcher ()
  (interactive)
  (progn
    (persp-switch-last)
    )
  )

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

(defun my-pad-right (string width)
  "Pad STRING on the right with blank spaces to reach WIDTH.
If STRING is already WIDTH or longer, return STRING unchanged.
Added spaces will not inherit text properties from STRING."
  (let ((current-length (length string)))
    (if (>= current-length width)
        string
      (let ((padding-needed (- width current-length)))
        (concat string (make-string padding-needed ? )))))) ; Concatenate string with new spaces

(defun workspace-build-name (name j)
  (let* ((is-active-persp (string= name (persp-current-name)))
         (str (if is-active-persp
                  (concat "(" (number-to-string j) " " name ")")
                (concat " " (number-to-string j) " " name " "))
              )
         (colored (propertize
                   str
                   'face (list
                          ;; Coloring the text based on the "link" face (see describe-face)
                          :foreground (face-attribute (if is-active-persp 'hydra-face-blue 'hydra-face-pink) :foreground nil t)
                          ;; Cursive if active
                          :underline (if is-active-persp t nil)
                          ;; :bold (if is-active-persp t nil)
                          )
                   ))
         (padded (my-pad-right colored 25))
         )
    padded
    )
  )

;; (defun frigo-jump-persp (num)
;;   (let* ((active-persp-index (+ 1 (-find-index (lambda (name) (string= name (persp-current-name))) (reverse (persp-names)))))
;;          (max-persp-index (length (persp-names)))
;;          (naive (+ active-persp-index num))
;;          (bounded1 (if (> naive max-persp-index) 1 naive))
;;          (bounded2 (if (<= bounded1 0) max-persp-index bounded1)))
;;     (go-to-workspace-number bounded2)
;;     ))

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
  ("q" nil :exit t)
  ("p" projectile-persp-switch-project)
  ;; ("h" (frigo-jump-persp -1))
  ;; ("l" (frigo-jump-persp 1))
  ("<f6>" urwebschool-sql)
  ("<f7>" urwebschool-logs)
  ;; ("<f8>" aperi-logs)
  ;; ("<f9>" aperi-logs)
  ("w" simon/new-worktree)
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
         (concat
          "Workspaces\n"
          "----------\n\n"
          ""
          (string-join
           (cl-mapcar
            'workspace-build-name
            (reverse (persp-names))
            '(1 2 3 4 5 6 7 8 9)
            )
           ""
           )
          "\n\n\n"
          ""
          (color-other (my-pad-right " x Delete" 27))
          ;; (my-pad-right " l Left" 28)
          (color-other (my-pad-right "<F6> School SQL" 27))
          (color-other (my-pad-right "w New worktree" 28))
          "\n"
          ""
          (my-pad-right " p Project" 27)
          ;; (my-pad-right " r Right" 28)
          (color-other (my-pad-right "<F7> School LOGS" 27))
          "\n"
          ""
          (my-pad-right " q Quit" 27)
          ;; (color-other (my-pad-right "<F8> Aperi LOGS" 27))
          )
         ))

(defun color-error (str)
  (propertize
   str
   'face (list :foreground (face-attribute 'error :foreground nil t))
   )
  )

(defun color-other (str)
  (propertize
   str
   'face (list :foreground (face-attribute 'default :foreground nil t))
   )
  )

(defun color-yellow (str)
  (propertize
   str
   'face (list :foreground (face-attribute 'diary :foreground nil t))
   )
  )

(defun simon/new-worktree ()
  "Create a new Git worktree for the current repository.

  This function prompts for a new branch name, then creates a new worktree
  in a sibling directory to the current one. The new directory's name
  will be a combination of the current directory's name and the new branch name
  (e.g., 'my-project-feature-x' if current is 'my-project').
  It uses 'magit-worktree-branch' to execute the git worktree add command.

  After creating the worktree, it will:
  1. Copy the 'node_modules' folder from the original directory to the new worktree,
     if 'node_modules' exists in the original directory.
  2. Add the new worktree directory as a known project to Projectile,
     if Projectile is loaded."
  (interactive)
  (let* ((repo-root (vc-git-root default-directory))
         branch-name
         current-dir-name
         parent-dir
         worktree-path
         original-node-modules-path)
    ;; Removed magit-current-repository variable as it's no longer needed

    ;; 1. Check if we are in a Git repository
    (unless repo-root
      (error "Not in a Git repository."))

    ;; Ensure repo-root is an absolute and canonical path, and that it exists.
    (setq repo-root (file-truename (expand-file-name repo-root)))

    ;; Explicitly check if the resolved repository root exists and is a directory.
    (unless (file-directory-p repo-root)
      (error "Git repository root '%s' does not exist or is not a directory. Please verify your Git setup and permissions." repo-root))

    ;; Debugging: Show the initial directories for clarity
    (message "Default directory: %s" default-directory)
    (message "Git repository root (resolved): %s" repo-root)

    ;; 2. Prompt for the new branch name
    (setq branch-name (read-string "New branch name for worktree: "))
    (when (string-empty-p branch-name)
      (error "Branch name cannot be empty."))

    ;; 3. Automatically determine the worktree path as a sibling directory
    ;;    If default-directory is /path/to/my-project/,
    ;;    current-dir-name will be "my-project"
    ;;    parent-dir will be /path/to/
    ;;    worktree-path will be /path/to/my-project-feature-x
    (setq current-dir-name (file-name-nondirectory (directory-file-name default-directory)))
    (setq parent-dir (file-name-directory (directory-file-name default-directory)))
    (setq current-dir-path (expand-file-name current-dir-name parent-dir))
    (setq worktree-path (expand-file-name (concat current-dir-name "-" branch-name) parent-dir))

    ;; 4. Execute the git worktree add command using magit-worktree-branch
    (message "Adding new worktree: %s with branch: %s using Magit..." worktree-path branch-name)
    (when (magit-branch-p branch-name)
      (message "Branch '%s' already exists" branch-name)
      (return))

    ;; call magit-worktree-branch
    (condition-case err
        (magit-worktree-branch worktree-path branch-name nil) ;; nil for start-point defaults to HEAD
      (error
       ;; Magit functions typically throw their own errors, so we just re-raise/augment
       (error "Magit failed to add Git worktree: %s" (cadr err))))

    (message "Worktree '%s' added successfully at '%s'." branch-name worktree-path)

    ;; 5. Copy node_modules folder if it exists
    (let* ((source-dir (expand-file-name "node_modules" current-dir-path))
           (dest-parent (expand-file-name "node_modules" worktree-path)))
      (message "Copying '%s' to '%s'" source-dir dest-parent)
      (if (file-directory-p source-dir)
          (copy-directory source-dir dest-parent t t)
        (message "'%s' is not a file directory" source-dir)
        ))

    ;; 6. Direnv allowance was removed in a previous step.

    ;; 7. Add new worktree to Projectile known projects
    (when (featurep 'projectile)
      (message "Adding '%s' to Projectile known projects..." worktree-path)
      ;; projectile-add-known-project expects a directory path
      (projectile-add-known-project worktree-path))

    ;; 8. Switch to the new project using projectile-persp-switch-project
    (message "Switching to new project '%s'..." worktree-path)
    (condition-case err
        (projectile-persp-switch-project worktree-path)
      (error
       (warn "Failed to switch to new project with Projectile Persp-mode: %s" (cadr err))))

    ;; 9. Allow direnv
    (envrc-allow)

    (message "Worktree setup complete for '%s'." branch-name)
    )
  )



