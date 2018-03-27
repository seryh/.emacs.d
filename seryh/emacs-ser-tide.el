
(defun my-kbd-config ()

  ;; фикс перезаписи буфера при <backspace>
  (local-set-key (kbd "<backspace>") '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))
  ;;(local-set-key (kbd "C-j") 'yas-expand)

  )


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (my-kbd-config)
  ;;(ng2-mode)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (local-set-key (kbd "<backspace>") '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))
  (local-set-key (kbd "C-j") 'yas-expand)
  (company-mode +1))

(use-package tide :ensure t)

(use-package ng2-mode
  :ensure t
  :mode ("\\.ts$" . ng2-mode)
  :init
  (progn

    ;; aligns annotation to the right hand side
    (setq company-tooltip-align-annotations t)

    ;; formats the buffer before saving
    ;;(add-hook 'before-save-hook 'tide-format-before-save)
    
    (add-hook 'typescript-mode-hook #'setup-tide-mode)
    
    (setq typescript-indent-level 4)
    (setq tide-format-options '(:placeOpenBraceOnNewLineForFunctions t :placeOpenBraceOnNewLineForControlBlocks t))
    (setq company-tooltip-align-annotations t)

    )

  )




(provide 'emacs-tide-conf)
