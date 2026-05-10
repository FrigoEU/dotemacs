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

(provide 'config-email)
