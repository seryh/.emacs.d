;; custom vars
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/bookmarks")
 '(buffer-face-mode-face (quote (:background "#1a0b19")))
 '(cider-lein-parameters "with-profile +office,+dev repl :headless")
 '(package-selected-packages
   (quote
    (ng2-mode flymake-go mode-icons indium color-identifiers-mode ace-window markdown-mode clj-refactor expand-region buffer-move which-key autopair emmet-mode scss-mode auto-complete company js2-mode auto-indent-mode smex ido-vertical-mode ido-ubiquitous rainbow-delimiters web-mode paredit cider hl-line+ org-bullets etags-table moe-theme powerline magit helm-swoop redo+ bookmark+ yasnippet use-package request))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:weight bold :foreground "brown")))))

(when (system-is-windows)
  (setq default-directory "C:\\Users\\Seryh\\Downloads"))

(server-start) 
