;; (use-package ultra-scroll
;;   :straight
;;   (el-patch :type git :host github :repo "jdtsmith/ultra-scroll")

;;   :init
;;   (setq scroll-conservatively 3 ; or whatever value you prefer, since v0.4
;;         scroll-margin 0)        ; important: scroll-margin>0 not yet supported

;;   ;; better scrolling
;;   (setq ;; scroll-conservatively 9999
;;    ;; scroll-preserve-screen-position nil
;;    ;; scroll-margin 12
;;    )

;;   ;; (setq pixel-scroll-precision-interpolate-page 1)

;;   ;; smooth scrolling (= interpolation scrolling) options
;;   ;; (setq pixel-scroll-precision-interpolation-total-time 0.150)

;;   :config
;;   (ultra-scroll-mode 1)
;;   )

;; (setq
;;  scroll-conservatively 3
;;  scroll-preserve-screen-position nil
;;  pixel-scroll-precision-interpolate-page 1
;;  ;; scroll-margin 12
;;  )

;; (pixel-scroll-precision-mode 1)

;; (defun simon/scroll-down ()
;;   (interactive)
;;   ;; (evil-scroll-up)
;;   ;; (pixel-scroll-precision-interpolate
;;   ;;  (* -10 (line-pixel-height))
;;   ;;  )
;;   ;; (ultra-scroll-down
;;   ;;  (* 10 (line-pixel-height))
;;   ;;  )
;;   (scroll-up-line 10)
;;   ;; (scroll-down-command)
;;   )

;; (defun simon/scroll-up ()
;;   (interactive)
;;   ;; (evil-scroll-down)
;;   ;; (pixel-scroll-precision-interpolate
;;   ;;  (* 10 (line-pixel-height))
;;   ;;  )
;;   ;; (ultra-scroll-up
;;   ;;  (* 10 (line-pixel-height))
;;   ;;  )
;;   (scroll-down-line 10)
;;   ;; (scroll-up-command)
;;   )
