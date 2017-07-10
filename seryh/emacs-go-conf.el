(use-package go-mode
  :ensure t
  :mode ("\\.go$" . go-mode)
  :config
  (progn
    (use-package flymake-go
      :ensure t)))




(provide 'emacs-go-conf)
