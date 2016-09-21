(defun stop-clj-process (arg)
  (interactive "P")
  (cider-interactive-eval "(System/exit 0)"))

(eval-after-load 'clojure-mode
  '(progn
     (define-key clojure-mode-map (kbd "<f12>") 'stop-clj-process)))

(use-package cider
  :ensure t
  :commands (cider cider-connect cider-jack-in)

  :init
  (setq cider-auto-select-error-buffer t
        ;;cider-repl-pop-to-buffer-on-connect nil
        cider-repl-use-clojure-font-lock t
        cider-repl-wrap-history t
        cider-repl-history-size 1000
        cider-show-error-buffer t
        nrepl-hide-special-buffers t
        ;; Stop error buffer from popping up while working in buffers other than the REPL:
        nrepl-popup-stacktraces nil)

  ;;(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
  ;;(add-hook 'cider-mode-hook 'company-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'cider-repl-mode-hook 'paredit-mode)
  ;;(add-hook 'cider-repl-mode-hook 'superword-mode)
  ;;(add-hook 'cider-repl-mode-hook 'company-mode)
  ;;(add-hook 'cider-test-report-mode 'jcf-soft-wrap)

  :bind (:map cider-mode-map
              ("C-c C-v C-c" . cider-send-and-evaluate-sexp)
              ("C-c C-p"     . cider-eval-print-last-sexp))

  :config
  (use-package slamhound))

;; "\e\er" - M-ESC er

(use-package clj-refactor
  :ensure t
  :init
  (add-hook 'clojure-mode-hook 'clj-refactor-mode)
  :config
  ;; Configure the Clojure Refactoring prefix:
  (cljr-add-keybindings-with-prefix "C-c .")
  :diminish clj-refactor-mode)
