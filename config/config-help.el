;;;  -*- lexical-binding: t; -*-


(defun show-help-transient ()
  (interactive)
  (show-transient-below 'help-transient)
  )

(transient-define-prefix help-transient ()
  "test"
  :transient-non-suffix 'transient--do-quit-all ;; close transient state and popup buffer immediately when we use any other keybind
  [
   "Help"
   :class transient-column
   ("f" "Function" helpful-function)
   ("k" "Key" helpful-key)
   ("b" "Bindings" describe-bindings)
   ("m" "Mode" describe-mode)
   ("v" "Variable" helpful-variable)
   ]
  )

(use-package helpful
  :straight t
  )
