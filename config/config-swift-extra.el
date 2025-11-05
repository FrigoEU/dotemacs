(use-package swift-development
  :straight (:type git :host github :repo "konrad1977/swift-development")
  :config
  (require 'swift-development)
  (require 'xcode-project)
  (require 'xcode-build-config)

  ;; Optional modules
  ;; (require 'ios-simulator)
  ;; (require 'ios-device)
  (require 'swift-refactor)
  (require 'localizeable-mode)
  ;; (require 'swift-lsp)
  )

;; (require 'swift-lsp)

(use-package async :straight t)
(use-package periphery ;; This name is arbitrary
  :straight (:type git :host github :repo "konrad1977/periphery")
  :config
  ;; Add the directory to load-path so 'require' can find the file
  ;; (let ((periphery-dir
  ;;        (expand-file-name "emacs/localpackages/periphery"
  ;;                          (straight-lib-dir "konrad1977-emacs-config"))))
  ;;   (add-to-list 'load-path periphery-dir))
  ;; Now, require the main file, which will pull in the others
  )
