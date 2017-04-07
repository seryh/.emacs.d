(use-package js2-mode
  :ensure t
  :init
  (setq js-basic-indent 2)
  (setq js2-strict-inconsistent-return-warning nil)
  (setq truncate-lines 0)
  (setq-default
   js2-basic-indent 2
   js2-basic-offset 2
   js2-auto-indent-p t
   js2-cleanup-whitespace t
   js2-enter-indents-newline t
   js2-indent-on-enter-key t
   js2-global-externs (list "define" "iwayWidgets" "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$"))

  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  
  (defun my-kbd-config ()

    ;; фикс перезаписи буфера при <backspace>
    (local-set-key (kbd "<backspace>") '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))

    )

  (add-hook 'js2-mode-hook
            (lambda ()
              (hs-minor-mode t)            ;; hide/show
              (js2-imenu-extras-mode t)
              ;;(aggressive-indent-mode t)
              (my-kbd-config)
              
              ;;(tern-mode t) 
              ;;(ac-js2-mode t)
              (push '("function" . ?λ) prettify-symbols-alist)
              
              ;;(push '("!=" . ?≠) prettify-symbols-alist)
              ;;(push '(">=" . ?≥) prettify-symbols-alist)
              ;;(push '("<=" . ?≤) prettify-symbols-alist)
              
              (prettify-symbols-mode 1)

              ))
  
  )

;;(use-package color-identifiers-mode
;;  :ensure t
;;  :init
;;  (add-hook 'js2-mode-hook 'color-identifiers-mode))
