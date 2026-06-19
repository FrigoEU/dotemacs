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
  (setq magit-difftastic-syntax-highlight nil)
  (magit-difftastic-mode +1))

;; Both difftastic and magit-difftastic render difft output through
;; `difftastic--ansi-color-apply', which maps difft's 8 ANSI colors onto the
;; faces in these vectors. Slots 1/2 are removed/added (our red/green, see
;; `magit-diff-removed'/`magit-diff-added' in config-eyecandy); collapse the
;; rest (heading/comment/string/warning) to `default' so nothing else is
;; colored. Affects both the D/S buffers and the inline magit chunks.
(with-eval-after-load 'difftastic
  (let ((v (vector
            (aref ansi-color-normal-colors-vector 0) ; black
            'magit-diff-removed                       ; red
            'magit-diff-added                         ; green
            'default                                  ; heading
            'default                                  ; comment
            'default                                  ; string
            'default                                  ; warning
            (aref ansi-color-normal-colors-vector 7)))) ; white
    (setq difftastic-normal-colors-vector v
          difftastic-bright-colors-vector v)))

(provide 'config-difftastic)
