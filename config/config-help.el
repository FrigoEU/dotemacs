;;;  -*- lexical-binding: t; -*-

;; (defun show-transient-below (l)
;;   (progn
;;     ;; Temporary change to how we want transient to show up
;;     ;; We always want this to go full length over the bottom
;;     ;; This option applies to all transient menus (including eg: magit)
;;     ;; So we roll it back after our own
;;     (let ((prev transient-display-buffer-action))
;;       (setq transient-display-buffer-action
;;             '(display-buffer-in-side-window
;;               (side . bottom)
;;               (inhibit-same-window . nil)
;;               (window-parameters (no-other-window . t)))
;;             )
;;       (funcall l)
;;       (setq transient-display-buffer-action
;;             prev
;;             )
;;       )
;;     )
;;   )


;; (defun show-help-transient ()
;;   (interactive)
;;   (show-transient-below 'help-transient)
;;   )


;; (transient-define-prefix help-transient ()
;;   "test"
;;   :transient-non-suffix 'transient--do-quit-all ;; close transient state and popup buffer immediately when we use any other keybind
;;   [
;;    "Help"
;;    :class transient-column
;;    ("f" "Function" helpful-function)
;;    ("k" "Key" helpful-key)
;;    ("b" "Bindings" describe-bindings)
;;    ("m" "Mode" describe-mode)
;;    ("v" "Variable" helpful-variable)
;;    ]
;;   )

(use-package helpful
  :straight t
  )
