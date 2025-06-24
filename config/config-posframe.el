
(use-package hydra-posframe
  :straight '(hydra-posframe :type git :host github :repo "ladicle/hydra-posframe")
  :defer t
  :init
  (setq hydra-posframe-border-width 4)
  (setq hydra-posframe-parameters
        `((left-fringe . 16)
          (right-fringe . 16)
          (min-height . 21)
          (height . 21)
          ;; backtick + comma = evaluate at runtime
          (min-width . ,(floor ( * (frame-width) 0.62)))
          ))
  (hydra-posframe-mode 1)
  :custom-face (hydra-posframe-border-face
                ((t (
                     :background "#57c7ff"
                     :inherit 'highlight
                     ))))
  )

(use-package vertico-posframe
  :straight t
  :defer t
  :init
  (vertico-posframe-mode 1)
  (setq vertico-posframe-width (round (* (frame-width) 0.62)))
  (setq vertico-posframe-border-width 4)
  (setq vertico-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)
          ))
  (setq vertico-multiform-commands
        '((consult-line (:not posframe)) 
          (t posframe)))
  :config
  :custom-face (vertico-posframe-border
                ((t (
                     :background "#57c7ff"
                     :inherit 'highlight
                     ))))
  )
