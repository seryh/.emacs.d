(general-define-key :keymaps 'php-mode-map
                    "M-," (defhydra hydra-php (:hint nil :color blue :exit t :columns 4)
                            "PHP Helper"
                            ("p" psysh "psysh-repl")
                            ;; TODO
                            ;; ("]" ac-php-find-symbol-at-point "find-symbol-at-point")
                            ;; ("t" ac-php-location-stack-back "location-stack-back")
                            ("q" nil "Cancel")))


;; ------ packages
(use-package ede-php-autoload
  :ensure t)

(use-package ac-php
  :ensure t)

(use-package psysh
  :ensure t)

(use-package company-php
  :ensure t)

(use-package php-auto-yasnippets
  :ensure t
  :commands yas/create-php-snippet)

(use-package phpunit
  :ensure t
  :commands (phpunit-current-test
             phpunit-current-class
             phpunit-current-project))

(use-package php-mode
  :ensure t
  :mode (("\\.php[0-9]?\\'" . php-mode))
  :bind (:map php-mode-map
              ("C-c C-y" . yas/create-php-snippet)
              ("C-c C-t t" . phpunit-current-test)
              ("C-c C-t c" . phpunit-current-class)
              ("C-c C-t p" . phpunit-current-project))
  :init
  (add-hook 'php-mode-hook (lambda ()
                             ;;(paredit-mode t)
                             
                             (ede-php-autoload-mode t)
                             
                             (company-mode t)
                             (ac-php-core-eldoc-setup) ;; enable eldoc
                             (make-local-variable 'company-backends)
                             (add-to-list 'company-backends 'company-ac-php-backend)
                             
                             ))
)

(provide 'emacs-php-conf)
