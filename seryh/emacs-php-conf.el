
(use-package php-mode
  :commands php-mode
  :ensure t
  :mode "\\.php?$"
  :init
  (add-hook 'php-mode-hook (lambda ()
                             ;;(paredit-mode t)

                             (company-mode t)
                             (hs-minor-mode t) ;;show/hide block
                             ;;(aggressive-indent-mode t)
                             ))


  )

(provide 'emacs-php-conf)
