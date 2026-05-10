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

(setq user-mail-address "simon.van.casteren@gmail.com")

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

;; mu4e setup goes here once we install it. mu4e ships with the `mu` package
;; on NixOS at /nix/store/.../share/emacs/site-lisp/mu4e — may need to add
;; to load-path explicitly if not picked up automatically.
;;
(use-package mu4e
  ;; :load-path "/run/current-system/sw/share/emacs/site-lisp/mu4e"
  :config
  (setq mu4e-maildir "~/Mail"
        mu4e-get-mail-command "mbsync gmail"
        mu4e-update-interval 300
        mu4e-change-filenames-when-moving t  ;; required for mbsync
        mu4e-maildir-shortcuts '((:maildir "/gmail/Inbox" :key ?i))))

(provide 'config-email)
