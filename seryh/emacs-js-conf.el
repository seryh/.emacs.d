;; js mode conf


;; example
;; https://github.com/CSRaghunandan/.emacs.d/blob/b269a0c63e34c5bd2c1d7f19cb40f9c7bd2e1255/setup-files/setup-js.el

;; автокомплит для js нуждается в npm install -g tern
(use-package ac-js2 :ensure t)

(use-package flow-minor-mode
  :ensure t)


; (use-package company-tern
;   :ensure t)

(use-package tern
  :ensure t)

(use-package tern-auto-complete
  :ensure t)

(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'color-identifiers-mode)
  (add-hook 'rjsx-mode-hook 'color-identifiers-mode)
  )

;; (setq ac-js2-evaluate-calls t)
;; (add-hook 'js2-mode-hook 'ac-js2-setup-auto-complete-mode)


   

(use-package js2-mode
  :ensure t
  :init
  (setq js-basic-indent 2)
  (setq js2-basic-offset 2)
  (setq js2-strict-inconsistent-return-warning nil)
  (setq js2-strict-missing-semi-warning nil)
  (setq js2-missing-semi-one-line-override nil)
  (setq js2-strict-trailing-comma-warning nil)
  (setq js2-mode-show-strict-warnings nil)
  (setq js2-mode-show-parse-errors nil)
  (setq truncate-lines 0)
  
  (setq-default
   js2-basic-indent 2
   js2-basic-offset 2
   js2-auto-indent-p t
   js2-cleanup-whitespace t
   js2-enter-indents-newline t
   js2-indent-on-enter-key t
   js2-global-externs (list
                       "define" "iwayWidgets" "window" "module" "require" "buster"
                       "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval"
                       "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$"
                       "describe" "it" "expect" "before" "after"))

  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

  (defun my-kbd-config ()

    ;; фикс перезаписи буфера при <backspace>
    (local-set-key (kbd "<backspace>") '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))
    (local-set-key (kbd "C-j") 'yas-expand)

    )

  
  (add-hook 'js2-mode-hook
            (lambda ()
              (setq js2-basic-offset 2)
              (autopair-mode t)
              (hs-minor-mode t)            ;; hide/show
              ;;(paredit-mode t) ;; херит C-j
              (js2-imenu-extras-mode t)
              ;;(aggressive-indent-mode t)
              (rainbow-delimiters-mode t)
              (company-mode t)
              (flow-js2-mode t)
              (tern-mode t)
              (company-tern t)
              ;;(ac-js2-mode t)

              (push '("function" . ?λ) prettify-symbols-alist)
              
              ;;(push '("!=" . ?≠) prettify-symbols-alist)
              ;;(push '(">=" . ?≥) prettify-symbols-alist)
              ;;(push '("<=" . ?≤) prettify-symbols-alist)
              
              (prettify-symbols-mode 1)
              (local-set-key (kbd "<backspace>") '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))
              (local-set-key (kbd "C-j") 'yas-expand)

              ))

  )



;; indium: javascript awesome development environment
;; https://github.com/NicolasPetton/indium
;; (use-package indium
;;   :ensure t
;;   :config (add-hook 'js2-mode-hook 'indium-interaction-mode))

(use-package json-mode
  :ensure t)




(use-package rjsx-mode
  :ensure t
  :init
  
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.react.js\\'" . rjsx-mode))
  (add-to-list 'magic-mode-alist '("/\\*\\* @jsx React\\.DOM \\*/" . rjsx-mode))
  (add-to-list 'magic-mode-alist '("^import React" . rjsx-mode))
  (setq js2-basic-offset 2)

  
  
  (add-hook 'rjsx-mode-hook
            (lambda ()
              (autopair-mode 0)
              (flow-js2-mode t)
              (company-mode t)
              (tern-mode t)
              (company-tern t) 
              ;;(ac-js2-mode t)
              (local-set-key (kbd "<backspace>") '(lambda () (interactive) (backward-delete-char-untabify 1 nil)))
              (local-set-key (kbd "C-j") 'yas-expand)
              ))
  
  )
