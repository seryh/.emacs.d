(defun clj-insert-fn ()
  (interactive)
  (insert "(fn [])")
  (backward-char 2))

(defun stop-clj-process (arg)
  (interactive "P")
  (cider-interactive-eval "(System/exit 0)"))

;;(setq nrepl-hide-special-buffers t)
;;(setq cider-repl-pop-to-buffer-on-connect nil)
;;(setq cider-show-error-buffer 'except-in-repl)
;;(setq cider-prompt-for-symbol nil)

(eval-after-load 'clojure-mode
  '(progn
     (define-key clojure-mode-map (kbd "<f12>") 'stop-clj-process)
     (define-key clojure-mode-map (kbd "M-m t") 'cider-switch-to-repl-buffer)
     (define-key clojure-mode-map (kbd "M-m f") 'clj-insert-fn)))

;; "\e\er" - M-ESC er
