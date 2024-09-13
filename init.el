;; -*- lexical-binding: t -*-

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
;; (add-hook 'window-setup-hook 'toggle-frame-fullscreen)
(toggle-frame-fullscreen)

;; Installing/starting straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; https://github.com/jwiegley/use-package?tab=readme-ov-file#hooks
(setq use-package-hook-name-suffix nil)

(setq simon/eshell-or-vterm 'eshell)

(let ((gc-cons-threshold (* 256 1024 1024))
      (file-name-handler-alist nil))

  (defgroup dotemacs nil
    "Custom configuration for dotemacs."
    :group 'local)

  (defcustom dotemacs-cache-directory (concat user-emacs-directory ".cache/")
    "The storage location for various persistent files."
    :type 'directory
    :group 'dotemacs)

  (load (concat user-emacs-directory "core/core-boot"))
  (load (concat user-emacs-directory "config/config-auxiliary-modes.el"))
  ;; (load (concat user-emacs-directory "config/config-helm.el"))
  ;; (load (concat user-emacs-directory "config/config-ivy.el"))
  (load (concat user-emacs-directory "config/config-consult-vertico.el"))
  (load (concat user-emacs-directory "config/config-core.el"))
  (load (concat user-emacs-directory "config/config-dashboard.el"))
  (load (concat user-emacs-directory "config/config-eshell.el"))
  (load (concat user-emacs-directory "config/config-vterm.el"))
  (load (concat user-emacs-directory "config/config-evil.el"))
  (load (concat user-emacs-directory "config/config-eyecandy.el"))
  ;; (load (concat user-emacs-directory "config/config-flycheck.el"))
  (load (concat user-emacs-directory "config/config-git.el"))
  (load (concat user-emacs-directory "config/config-help.el"))
  (load (concat user-emacs-directory "config/config-js.el"))
  (load (concat user-emacs-directory "config/config-lisp.el"))
  (load (concat user-emacs-directory "config/config-corfu.el"))
  ;; (load (concat user-emacs-directory "config/config-lsp-bridge.el"))
  (load (concat user-emacs-directory "config/config-misc.el"))
  (load (concat user-emacs-directory "config/config-pairs.el"))
  (load (concat user-emacs-directory "config/config-projectile.el"))
  (load (concat user-emacs-directory "config/config-rust.el"))
  (load (concat user-emacs-directory "config/config-tree-sitter.el"))
  (load (concat user-emacs-directory "config/config-typescript.el"))
  (load (concat user-emacs-directory "config/config-workspaces.el"))
  ;; (load (concat user-emacs-directory "config/config-lsp-mode.el"))
  (load (concat user-emacs-directory "config/config-eglot.el"))
  (load (concat user-emacs-directory "bindings/bindings.el"))
  ;; Direnv integration last
  (load (concat user-emacs-directory "config-direnv-envrc.el"))
  )

;; Not very clean, but doesn't work otherwise
(setq vertico-posframe-width (round (* (frame-width) 0.62)))
(setq vertico-posframe-border-width 8)
(setq vertico-posframe-parameters
      '((left-fringe . 8)
        (right-fringe . 8)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c1638a7061fb86be5b4347c11ccf274354c5998d52e6d8386e997b862773d1d2" "4e2e42e9306813763e2e62f115da71b485458a36e8b4c24e17a2168c45c9cf9d" "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "6fc9e40b4375d9d8d0d9521505849ab4d04220ed470db0b78b700230da0a86c1" "76ddb2e196c6ba8f380c23d169cf2c8f561fd2013ad54b987c516d3cabc00216" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "0af489efe6c0d33b6e9b02c6690eb66ab12998e2649ea85ab7cfedfb39dd4ac9" "0340489fa0ccbfa05661bc5c8c19ee0ff95ab1d727e4cc28089b282d30df8fc8" "88267200889975d801f6c667128301af0bc183f3450c4b86138bfb23e8a78fb1" default))
 '(safe-local-variable-values
   '((multi-compile-alist
      ("\\.*"
       ("css" . "npm run css")
       ("sqltyper_domain" . "npm run sqltyper_domain")
       ("setup_demo" . "npm run setup_demo")
       ("translations" . "npm run download_translations && npm run run_translations")))
     (projectile-project-compilation-cmd . "npm run check"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
