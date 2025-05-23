;; -*- lexical-binding: t -*-

(use-package evil
  :straight t
  :init
  (setq evil-want-keybinding nil)
  (evil-mode)
  :config
  (evil-esc-mode 1)

  (setq evil-search-module 'evil-search)
  (setq evil-magic 'very-magic)

  (setq evil-emacs-state-cursor '("red" box))
  (setq evil-motion-state-cursor '("orange" box))
  (setq evil-normal-state-cursor '("green" box))
  (setq evil-visual-state-cursor '("orange" box))
  (setq evil-insert-state-cursor '("red" bar))
  (setq evil-replace-state-cursor '("red" bar))
  (setq evil-operator-state-cursor '("red" hollow))
  
  (setq evil-split-window-below t)
  (setq evil-vsplit-window-right t)
  (setq evil-auto-balance-windows t)
  (evil-set-undo-system 'undo-redo)

  (setq evil-want-keybinding nil) ;; evil-collection will provide instead

  (add-hook 'evil-jumps-post-jump-hook #'recenter)

  (after 'diff-mode
    (evil-define-key 'normal diff-mode diff-mode-map
      "j" #'diff-hunk-next
      "k" #'diff-hunk-prev))

  (evil-ex-define-cmd "q[uit]" 'evil-quit)



  :bind (:map evil-normal-state-map
              ("C-d" . evil-scroll-down)
              ("C-u" . evil-scroll-up)
              ("C-w" . workspace-switcher)
              ("s"   . evil-substitute)
              ("g d" . xref-find-definitions)
              ("!" . simon-async-shell-command-with-make)

              ("u"   . evil-undo)
              ("C-r" . evil-redo)
              )
  :bind (:map evil-insert-state-map
              ("C-r" . nil) ;; This was screwing with ESP32 dev where I'm in an eshell and need to press Ctrl + R to restart 
              )
  :bind (:map evil-normal-state-map
              ("<left>" . evil-window-left)
              ("<down>" . evil-window-down)
              ("<up>"   . evil-window-up)
              ("<right>". evil-window-right)
              ("C-h" . evil-window-left)
              ("C-j" . evil-window-down)
              ("C-k"   . evil-window-up)
              ("C-l". evil-window-right)
              ) 
  :bind (:map evil-motion-state-map
              ("j" . evil-next-line)
              ("k" . evil-previous-line)
              ) 
  :bind (:map evil-visual-state-map
              ("s" . evil-surround-region)
              )

  )


(use-package evil-commentary
  :straight t
  :init
  (evil-commentary-mode t))

(use-package evil-surround
  :straight t
  :init
  (global-evil-surround-mode t))

(use-package evil-collection
  :straight t
  :after evil
  :init
  (evil-collection-init)
  :config
  (add-hook 'evil-collection-setup-hook
            (defun /bindings/evil/evil-collection-setup-hook (_mode mode-keymaps)
              ;; removes any bindings to SPC and , since they are global prefix keys
              (evil-collection-translate-key 'normal mode-keymaps
                (kbd "SPC") nil
                "," nil
                ))))

(after 'evil-common
  (evil-put-property 'evil-state-properties 'normal   :tag " NORMAL ")
  (evil-put-property 'evil-state-properties 'insert   :tag " INSERT ")
  (evil-put-property 'evil-state-properties 'visual   :tag " VISUAL ")
  (evil-put-property 'evil-state-properties 'motion   :tag " MOTION ")
  (evil-put-property 'evil-state-properties 'emacs    :tag " EMACS ")
  (evil-put-property 'evil-state-properties 'replace  :tag " REPLACE ")
  (evil-put-property 'evil-state-properties 'operator :tag " OPERATOR "))

;; (require-package 'evil-anzu)
;; (require 'evil-anzu)

;; Press “%” to jump between matched tags (“<div>” and “</div>” in html, etc).
(use-package evil-matchit
  :straight t
  :init
  (global-evil-matchit-mode t))

;; Make a visual selection with v or V, and then hit * to search 
(use-package evil-visualstar
  :straight t
  :init
  (global-evil-visualstar-mode t)
  )


;; (defun evilmi-customize-keybinding ()
;;   (evil-define-key 'normal evil-matchit-mode-map
;;     "%" 'evilmi-jump-items))

;; (unless (display-graphic-p)
;;   (require-package 'evil-terminal-cursor-changer)
;;   (evil-terminal-cursor-changer-activate))

(defadvice evil-ex-search-next (after dotemacs activate)
  (recenter))

(defadvice evil-ex-search-previous (after dotemacs activate)
  (recenter))

(provide 'config-evil)
