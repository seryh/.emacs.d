;; seryh
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; System-type definition
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))
(defun system-is-windows()
    (string-equal system-type "windows-nt"))

(setq user-full-name "Seryh Oleg"
      user-mail-address "o.seryh@gmail.com")

;; get-config dir platform independent
(defun ser/get-config-dir (VPath)
  "get default config dir for plugins"
  (concat user-emacs-directory
          (convert-standard-filename VPath)))

;; add-load-path platform independent
(defun ser/add-load-path (VPath)
  "add to load path"
  (add-to-list 'load-path
               (ser/get-config-dir VPath)))

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(
    undo-tree
    magit
    powerline
    moe-theme
    cider         ;; clojure  
    web-mode
    rainbow-delimiters
    projectile    ;; простая навигация по проектам
    ido           ;; интерактивное управление буферами и файлами;
    ;;ac-js2      ;; автокомплит js
    js2-mode      ;; подстветка синтаксиса js
    company       ;; popup 
    sass-mode 
    ;;tern        ;; автокомплит для js нуждается в npm install -g tern
    ;;tern-auto-complete 
    emmet-mode    ;; zen-coding автокомплит для html - C-j 
    autopair      ;; автозакрытие ковычек и скобок
    which-key     ;; which-key - буфер с шорткат подсказками https://github.com/justbur/emacs-which-key
    buffer-move   ;; перемещение буфера buf-move-<pos>
    expand-region ;; семантическое выделение региона
    )
  "A list of packages to ensure are installed at launch.")

;;(load (ser/get-config-dir "seryh/emacs-ser-theme.el"))

;; Automaticaly install any missing packages
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'powerline)
(require 'moe-theme)
(setq moe-theme-highlight-buffer-id t)

(powerline-moe-theme)
(moe-dark)

(require 'org-install)
(require 'ido)
(require 'ibuffer)
(require 'cider)

;; ------------------------------------------------------- [ Company ]
(require 'company)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0.1)
(global-company-mode)
(global-undo-tree-mode)
(autopair-global-mode) 
;;(ac-js2-mode t)
(ido-mode t)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;(setq ac-js2-evaluate-calls t)

;; load concrete packages
(load (ser/get-config-dir "seryh/emacs-ser-general.el"))
(load (ser/get-config-dir "seryh/emacs-ser-projectile-conf.el"))
(load (ser/get-config-dir "seryh/emacs-ser-kbd.el"))

(setq auto-mode-alist
  (append '(("\\.scss$". sass-mode)
            ("\\.css$". web-mode)
            ("\\.js$". js2-mode)
            ("\\.html$". web-mode)
            ("\\.phtml$". web-mode)
            ("\\.org$". org-mode)
            ("\\.php$". web-mode)
            ("\\.clj$". clojure-mode)
            ("\\.end$". clojure-mode)
            ("\\.el$". emacs-lisp-mode)
            (".emacs". emacs-lisp-mode))))


(add-hook 'scss-mode-hook 
          (lambda ()
            (sass-mode)))

(add-hook 'clojure-mode-hook 
  (lambda () 
    (rainbow-delimiters-mode t)))

(add-hook 'js2-mode-hook 
  (lambda () 
    (rainbow-delimiters-mode t)
    (hs-minor-mode t)
    ;;(tern-mode t) 
    ;;(ac-js2-mode t)
    ))

(add-hook 'web-mode-hook 
  (lambda () 
    (hs-minor-mode t)
    (emmet-mode t)))

(add-hook 'dired-mode-hook (lambda ()
  (hl-line-mode t)))

(add-hook 'ibuffer-hook
        (lambda ()
          (hl-line-mode t)      
          (unless (eq ibuffer-sorting-mode 'alphabetic)
            (ibuffer-do-sort-by-alphabetic))) )

(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

;; ------------------ [ web-mode ]
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'"))
)

;; ------------------ [ cua-mode] классическая копипаста, если есть регионы
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
;; shift + click select region
(define-key global-map (kbd "<S-down-mouse-1>") 'ignore) ; turn off font dialog
(define-key global-map (kbd "<S-mouse-1>") 'mouse-set-point)
(put 'mouse-set-point 'CUA 'move)

;; scroll lag fix
(setq scroll-conservatively 101) ;; move minimum when cursor exits view, instead of recentering
(setq mouse-wheel-scroll-amount '(1)) ;; mouse scroll moves 1 line at a time, instead of 5 lines
(setq mouse-wheel-progressive-speed 1) ;; on a long mouse scroll keep scrolling by 1 line


(setq which-key-idle-delay 1.0)
(setq which-key-separator " → " )
(which-key-mode t)
(desktop-save-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(buffer-face-mode-face (quote (:background "#1a0b19")))
 '(cider-lein-parameters "with-profile +windows repl :headless"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
