;; -*- lexical-binding: t -*-

(use-package difftastic
  :straight t
  :after magit
  :config
  (eval-after-load 'magit-diff
    '(transient-append-suffix 'magit-diff '(-1 -1)
       [("D" "Difftastic diff (dwim)" difftastic-magit-diff)
        ("S" "Difftastic show" difftastic-magit-show)])))

(use-package magit-difftastic
  :straight (:host github :repo "rschmukler/magit-difftastic")
  :after magit
  :config
  ;; (setq magit-difftastic-syntax-highlight nil)
  (magit-difftastic-mode +1)

  ;; magit-refresh called synchronously after git apply causes a freeze; delay it.
  (advice-add 'magit-difftastic--apply-chunk-patch :around
              (lambda (orig patch &rest apply-args)
                (cl-letf (((symbol-function 'magit-refresh) #'ignore))
                  (apply orig patch apply-args))
                (add-timeout 0.1 (lambda (_) (magit-refresh)) nil)))

  ;; difft renders tabs as 4 spaces (--tab-width default), and syntax faces are
  ;; only copied onto lines whose displayed text matches the source exactly, so
  ;; tab-indented code (Go) got no highlighting.  Expand tabs the same way.
  (advice-add 'magit-difftastic--source-text :filter-return
              (lambda (text) (and text (string-replace "\t" "    " text)))))

;; Both difftastic and magit-difftastic render difft output through
;; `difftastic--ansi-color-apply', which maps difft's 8 ANSI colors onto the
;; faces in these vectors. Slots 1/2 are removed/added (our red/green, see
;; `magit-diff-removed'/`magit-diff-added' in config-eyecandy); collapse the
;; rest (heading/comment/string/warning) to `default' so nothing else is
;; colored. Affects both the D/S buffers and the inline magit chunks.
;; (with-eval-after-load 'difftastic
;;   (let ((v (vector
;;             (aref ansi-color-normal-colors-vector 0) ; black
;;             'magit-diff-removed                       ; red
;;             'magit-diff-added                         ; green
;;             'default                                  ; heading
;;             'default                                  ; comment
;;             'default                                  ; string
;;             'default                                  ; warning
;;             (aref ansi-color-normal-colors-vector 7)))) ; white
;;     (setq difftastic-normal-colors-vector v
;;           difftastic-bright-colors-vector v)))

;; Jump from a file buffer to the magit-status difftastic chunk row matching
;; the current line.  Chunks render lazily (async), so after expanding the file
;; section we poll until its chunks exist before positioning point.
(defun /git/difftastic--chunks (file-section)
  (seq-filter (lambda (c) (eq (oref c type) 'magit-difftastic-hunk))
              (oref file-section children)))

(defun /git/difftastic--closest-row (file-section line)
  "Return (CHUNK . POS) for the chunk row in FILE-SECTION nearest worktree LINE."
  (let (best best-dist)
    (dolist (chunk (/git/difftastic--chunks file-section))
      (dolist (row (magit-difftastic--parse-chunk-lines chunk))
        (pcase-let ((`((,beg ,_) ,_ ,right) row))
          (when-let* ((n (car right))
                      (d (abs (- n line)))
                      ((or (null best-dist) (< d best-dist))))
            (setq best (cons chunk (or (cadr right) beg)) best-dist d)))))
    (or best
        (when-let* ((chunk (car (/git/difftastic--chunks file-section))))
          (cons chunk (oref chunk start))))))

(defun /git/difftastic--goto (buffer file-section line tries)
  (when (buffer-live-p buffer)
    (with-current-buffer buffer
      (cond
       ((/git/difftastic--chunks file-section)
        (when-let* ((hit (/git/difftastic--closest-row file-section line))
                    (win (get-buffer-window buffer t)))
          (magit-section-show (car hit))
          (with-selected-window win
            (goto-char (cdr hit))
            (recenter))))
       ;; Stock (non-difftastic) rendering: magit's own hunks.
       ((seq-some (lambda (c) (eq (oref c type) 'hunk)) (oref file-section children))
        (when-let* ((win (get-buffer-window buffer t)))
          (with-selected-window win
            (goto-char (oref file-section start))
            (magit-diff--goto-file-position (oref file-section value) line 0
                                       (oref file-section parent))
            (recenter))))
       ((> tries 0)
        (run-with-timer 0.1 nil #'/git/difftastic--goto
                        buffer file-section line (1- tries)))
       (t (message "Difftastic chunks did not render in time"))))))

(defun /git/difftastic-jump ()
  "Open magit-status at the difftastic chunk for the current file and line.
Prefers the unstaged diff (whose new side is the worktree), else staged."
  (interactive)
  (let* ((file (or buffer-file-name (user-error "Buffer is not visiting a file")))
         (line (line-number-at-pos))
         (rel (file-relative-name file (or (magit-toplevel) (user-error "Not in a git repo")))))
    (when (buffer-modified-p) (save-buffer))
    (magit-status-setup-buffer)
    (let ((section (or (magit-get-section `((file . ,rel) (unstaged) (status)))
                       (magit-get-section `((file . ,rel) (staged) (status)))
                       (user-error "No unstaged or staged changes in %s" rel))))
      (magit-section-show section)
      (goto-char (oref section start))
      (/git/difftastic--goto (current-buffer) section line 50))))

(provide 'config-difftastic)
