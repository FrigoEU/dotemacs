;; -*- lexical-binding: t -*-

;; Email setup. mbsync (isync) syncs Gmail INBOX to ~/Mail/gmail/, then mu
;; indexes it into ~/.cache/mu/xapian. mbsync config lives in
;; ~/dotfiles/.mbsyncrc (symlinked to ~/.mbsyncrc). Authentication uses
;; $GOOGLE_APP_PASSWORD from ~/.secrets — emacs must inherit it (launch from
;; a shell that has sourced .secrets).
;;
;; One-time setup commands (do NOT add bindings — destructive / one-shot):
;;
;;   mu init --maildir=~/Mail --my-address=simon.van.casteren@gmail.com
;;
;; Re-running requires --reinit (wipes the database).

(setq user-mail-address "simon.van.casteren@gmail.com"
      user-full-name    "Simon Van Casteren")

;; Per-address full-name / signature / sent-folder is supported via
;; `mu4e-contexts': each context overrides `user-mail-address',
;; `user-full-name', `mu4e-sent-folder', etc., and gets selected by a
;; `:match-func' (typically based on the maildir or the To: header).
;; Wire that up when a second account appears; one address = no point.

;; Sending: msmtp reads ~/.msmtprc (symlinked from ~/dotfiles/.msmtprc).
;; The password comes from $GOOGLE_APP_PASSWORD via `passwordeval' there,
;; so emacs must inherit that env var (same caveat as mbsync).
(setq sendmail-program        (executable-find "msmtp")
      send-mail-function      'sendmail-send-it
      message-send-mail-function 'sendmail-send-it
      ;; Tell msmtp which account by reading the From: header.
      message-sendmail-extra-arguments '("--read-envelope-from")
      message-sendmail-f-is-evil nil
      ;; Don't add an extra Sent copy — Gmail's SMTP server stores one
      ;; under [Gmail]/Sent Mail automatically when you send via your
      ;; own credentials. Local copy would dupe after the next mbsync.
      mu4e-sent-messages-behavior 'delete)

(defun simon/mail-perspective ()
  "Switch to (creating if needed) the dedicated `mail' perspective.
Keeps mail buffers (compilation output, mu4e) out of project perspectives."
  (persp-switch "mail"))

(defun simon/mail-get ()
  "Fetch new mail with mbsync, then update the mu index."
  (interactive)
  (simon/mail-perspective)
  (compile "mbsync gmail && mu index"))

(defun simon/mail-index ()
  "Re-index the maildir with mu."
  (interactive)
  (simon/mail-perspective)
  (compile "mu index"))

(defun simon/mail-mu4e ()
  "Open mu4e in the mail perspective."
  (interactive)
  (simon/mail-perspective)
  (mu4e))

(defun simon/mail-search ()
  "Run mu4e-search in the mail perspective."
  (interactive)
  (simon/mail-perspective)
  (call-interactively #'mu4e-search))

;; Installed with nixos config
(use-package mu4e
  ;; :load-path "/run/current-system/sw/share/emacs/site-lisp/mu4e"
  :config
  (setq mu4e-maildir "~/Mail"
        mu4e-get-mail-command "mbsync gmail"
        mu4e-update-interval 300
        mu4e-change-filenames-when-moving t  ;; required for mbsync
        ;; Gmail labels mapped to maildirs (mbsync SubFolders Verbatim
        ;; preserves the literal `[Gmail]/' prefix).
        mu4e-sent-folder   "/gmail/[Gmail]/Sent Mail"
        mu4e-drafts-folder "/gmail/[Gmail]/Drafts"
        mu4e-trash-folder  "/gmail/[Gmail]/Trash"
        mu4e-maildir-shortcuts '((:maildir "/gmail/Inbox"            :key ?i)
                                 (:maildir "/gmail/[Gmail]/Sent Mail" :key ?s)
                                 (:maildir "/gmail/[Gmail]/Drafts"   :key ?d)
                                 (:maildir "/gmail/[Gmail]/Trash"    :key ?t))))

;; Triage classy.school support mail by handing each unread message to a
;; fresh agent-shell. `mu view' renders the .eml to decoded text — works on
;; any path without needing the mu index. Unread messages live in
;; ~/Mail/gmail/Inbox/new/ per mbsync's Maildir layout.

(defconst simon/-classy-inbox "~/Mail/gmail/Inbox/new/")
(defconst simon/-classy-project (expand-file-name "~/projects/school/"))
(defconst simon/-classy-triage-prompt
  "The following is a support email for my SaaS for music schools.
Read the full email and situate it in the codebase.
If code changes are needed, propose a plan.

```
%s
```")

(defun simon/-mail-headers-classy-p (path)
  "Non-nil if message at PATH has simon@classy.school in a recipient header."
  (with-temp-buffer
    (insert-file-contents path nil 0 32768)
    (let ((end (or (and (re-search-forward "^$" nil t) (point)) (point-max))))
      (narrow-to-region (point-min) end))
    (goto-char (point-min))
    (while (re-search-forward "\n[ \t]+" nil t)
      (replace-match " "))
    (goto-char (point-min))
    (let ((case-fold-search t))
      (re-search-forward
       "^\\(?:to\\|cc\\|bcc\\|delivered-to\\|x-original-to\\):[^\n]*simon@classy\\.school"
       nil t))))

(defun simon/-mail-view-text (path)
  "Return the `mu view' rendering (headers + decoded body) of message at PATH."
  (with-temp-buffer
    (unless (zerop (call-process "mu" nil t nil "view" path))
      (error "mu view failed for %s" path))
    (buffer-substring-no-properties (point-min) (point-max))))

(defun simon/-mail-date (path)
  "Return the parsed Date header at PATH as a Lisp time value, or nil.
File mtime is unreliable here — mbsync stamps everything to the moment of
the initial sync, not the email's actual send time."
  (with-temp-buffer
    (insert-file-contents path nil 0 8192)
    (let ((end (or (and (re-search-forward "^$" nil t) (point)) (point-max))))
      (narrow-to-region (point-min) end))
    (goto-char (point-min))
    (while (re-search-forward "\n[ \t]+" nil t)
      (replace-match " "))
    (goto-char (point-min))
    (when (re-search-forward "^Date:[ \t]*\\(.*\\)$" nil t)
      (condition-case nil
          (date-to-time (match-string 1))
        (error nil)))))

(defun simon/-mail-subject (rendered fallback)
  "Pull a one-line subject out of `mu view' output RENDERED, else FALLBACK."
  (if (string-match "^Subject:[ \t]*\\(.*\\)$" rendered)
      (let ((s (string-trim (match-string 1 rendered))))
        (substring s 0 (min (length s) 60)))
    fallback))

(defun simon/-triage-open-email (path)
  "Open an agent-shell seeded with the support-triage prompt for the email at PATH."
  (let* ((rendered (simon/-mail-view-text path))
         (subject (simon/-mail-subject rendered (file-name-base path)))
         (prompt (format simon/-classy-triage-prompt rendered))
         ;; Skip the new/resume/load picker for this flow only — triage always
         ;; wants a fresh session per email.
         (agent-shell-session-strategy 'new)
         (buf (agent-shell-start :config (agent-shell--resolve-preferred-config))))
    (with-current-buffer buf
      (shell-maker-set-buffer-name buf (format "🤖 mail: %s" subject)))
    (agent-shell-insert :text prompt :submit t :shell-buffer buf)))

(defun simon/triage-classy-emails ()
  "Open agent-shell buffers for the last 5 unread emails to simon@classy.school.
Each buffer gets a triage prompt seeded with the email's `mu view' rendering."
  (interactive)
  (let* ((inbox (expand-file-name simon/-classy-inbox))
         (candidates (and (file-directory-p inbox)
                          (directory-files inbox t "\\`[^.]" t)))
         (matches (seq-filter (lambda (p)
                                (and (file-regular-p p)
                                     (simon/-mail-headers-classy-p p)))
                              candidates))
         (pairs (mapcar (lambda (p) (cons (or (simon/-mail-date p) 0) p)) matches))
         (sorted-pairs (sort pairs (lambda (a b) (time-less-p (car b) (car a)))))
         (top (mapcar #'cdr (seq-take sorted-pairs 1))))
    (unless top
      (user-error "No unread emails to simon@classy.school in %s" inbox))
    ;; Visit a project file so envrc activates and agent-shell inherits
    ;; the right env + default-directory.
    (let* ((default-directory simon/-classy-project)
           (probe (find-file-noselect
                   (expand-file-name "CLAUDE.md" simon/-classy-project))))
      (with-current-buffer probe
        (dolist (path top)
          (simon/-triage-open-email path))))))

(provide 'config-email)
