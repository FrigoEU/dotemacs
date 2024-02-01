;; -*- lexical-binding: t -*-

(use-package hydra :straight t)

(defhydra /hydras/main
  (:hint nil :exit t :idle 0.5)
  "

  _SPC_ → Search commands (M-x)

  _b_ → _b_uffers           _o_ → _o_pen             _r_ → _r_epeat
  _f_ → _f_iles             _-_ → dired            _l_ → _l_ayers
  _w_ → _w_indows           _h_ → _h_elp             _e_ → _e_rrors             
  _p_ → _p_rojects          _g_ → _g_it              _q_ → _q_uit             

  _/_ → Grep              _*_ → Grep at point    _s_ → _s_earch in file             
"
  ("SPC" execute-extended-command)
  ("b"   /hydras/buffers/body)
  ("q"   /hydras/quit/body)
  ("e"   /hydras/errors/body)
  ("o"   /hydras/open/body)
  ("r"   /hydras/repeat/body)
  ("w"   /hydras/windows/body)
  ("f"   /hydras/files/body)
  ("g"   /hydras/git/body)
  ("c"   /hydras/compile/body)
  ("-"   dired-jump)
  ("/"   consult-ripgrep-root)
  ("*"   consult-ripgrep-root-at-point)
  ("s"   consult-line)
  ("l"   show-workspace-switcher)
  ("h"   show-help-transient)
  ("p"   /hydras/project/body)
  )

(define-key evil-normal-state-map (kbd "SPC") '/hydras/main/body)

(setq lv-use-separator t)

(defhydra /hydras/repeat (:hint nil :exit t :idle 0.5)
  "
Quit

  _y_ → yank-ring
  _l_ → repeat vertico
  _c_ → repeat command

"
  ("y"  consult-yank-from-kill-ring)
  ("l"  vertico-repeat)
  ;; ("l"  vertico-suspend)
  ("c"  consult-complex-command)
  )

(defhydra /hydras/quit (:hint nil :exit t :idle 0.5)
  "
Quit

  _q_ → quit
  _r_ → restart

"
  ("q" 
   save-buffers-kill-terminal)
  ("r" (restart-emacs)))

(defhydra /hydras/buffers (:hint nil :exit t :idle 0.5)
  "
Buffers

  _b_ → buffers          _d_ → delete buffer           
  _m_ → goto messages    _p_ → previous
  _x_ → goto scratch     _n_ → next

"
  ("x" /utils/goto-scratch-buffer)
  ("d" kill-this-buffer)
  ("m" (switch-to-buffer "*Messages*"))
  ("b" consult-buffer)
  ("p" previous-buffer)
  ("n" next-buffer)
  )

(defhydra /hydras/windows (:hint nil :exit t :idle 0.5)
  "
Windows

  _S_     → split horizontal      _V_      → split vertical         _=_     → balance splits

  ^ ^                              _<up>_   → move window up         ^ ^
  _<left>_ → move window left     ^ ^                                _<right>_ → move window right
  ^ ^                              _<down>_ → move window dow        ^ ^
"
  ("S" evil-window-split)
  ("V" evil-window-vsplit)
  ("=" balance-windows)
  ("<left>" evil-window-move-far-left)
  ("<right>" evil-window-move-far-right)
  ("<up>" evil-window-move-very-top)
  ("<down>" evil-window-move-very-bottom)
  )

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (let*
      ;; magics
      ((default-directory (project-root (project-current t))))
    (eshell 'N)))
(defhydra /hydras/open (:hint nil :exit t :idle 0.5)
  "
Open

  _e_  → eshell
  _-_  → dired       ^ ^                      
  
"
  ("e" vterm-new)
  ("-" dired-jump)
  )

(defhydra /hydras/files (:hint nil :exit t :idle 0.5)
  "
Files

  _f_ → find files      
  _R_ → rename

"
  ("R" /utils/rename-current-buffer-file)
  ("f" find-file)
  )

(defhydra /hydras/compile
  (:hint nil :exit t :idle 0.5)
  "
Git

  _c_ → _c_ompile
  _r_ → _r_epeat

"
  ("c" compile)
  ("r" recompile)
  )


(defhydra /hydras/git
  (:hint nil :exit t :idle 0.5)
  "
Git

  _t_ → _t_ime machine
  _s_ → _s_tatus

"
  ("t" git-timemachine)
  ("s" magit-status)
  )

(defhydra /hydras/errors (:hint nil :idle 0.5  :exit t)
  "
Errors
------
  _l_ -> _l_ist
  _n_ -> _n_ext
  _p_ -> _p_previous
"
  ("l" flycheck-list-errors)
  ("n" flycheck-next-error)
  ("p" flycheck-previous-error)
  )

(defhydra /hydras/project
  (:hint nil :exit t :idle 0.5)
  "
Projects

  _p_ → _p_rojects search
  _f_ → _f_ind file in project
  _a_ → _a_dd project

"
  ("p" projectile-persp-switch-project)
  ("f" consult-projectile-find-file)
  ("a" projectile-add-known-project)
  )

(use-package transient
  :straight t
  :config
  (setq transient-history-file (concat dotemacs-cache-directory "transient/history.el"))
  (setq transient-levels-file (concat dotemacs-cache-directory "transient/levels.el"))
  (setq transient-values-file (concat dotemacs-cache-directory "transient/values.el"))
  )

(use-package which-key
  :straight t
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.2)
  (setq which-key-min-display-lines 3)
  )

;; escape minibuffer
(define-key minibuffer-local-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] '/utils/minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] '/utils/minibuffer-keyboard-quit)

(define-key minibuffer-local-map (kbd "C-h") 'backward-kill-word)
(define-key minibuffer-local-map (kbd "C-z") 'embark-export)

(define-key minibuffer-local-map (kbd "C-j") 'vertico-next)
(define-key minibuffer-local-map (kbd "C-k") 'vertico-previous)

(after 'comint
  (define-key comint-mode-map [up] 'comint-previous-input)
  (define-key comint-mode-map [down] 'comint-next-input))

(after 'auto-complete
  (define-key ac-completing-map (kbd "<down>") 'ac-next)
  (define-key ac-completing-map (kbd "<up>") 'ac-previous))

(after "expand-region-autoloads"
  (global-set-key (kbd "C-=") 'er/expand-region))

(after 'compile
  (define-key compilation-mode-map (kbd "j") 'compilation-next-error)
  (define-key compilation-mode-map (kbd "k") 'compilation-previous-error))

(after "vkill-autoloads"
  (autoload 'vkill "vkill" nil t)
  (global-set-key (kbd "C-x p") 'vkill))

(provide 'config-bindings)
