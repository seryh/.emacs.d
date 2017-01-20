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

(defun my-package-recompile()
  "Recompile all packages"
  (interactive)
  (byte-recompile-directory "~/.emacs.d/elpa" 0 t))

;; Оптимизация работы редактора
(setq max-specpdl-size 5)  ; default is 1000, reduce the backtrace level
(setq debug-on-error t)    ; now you should get a backtrace
(setq max-lisp-eval-depth 10000)

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

;; Add in your own as you wish:
(defvar my-packages
  '(
    hydra
    request
    xml
    use-package
    yasnippet
    
    bookmark+
    redo+
    
    helm-swoop
  
    magit
    powerline
    moe-theme
    cl-lib
    etags-table
    org-bullets
    
    hl-line+
    
    ;; clojure
    cider         
    paredit
    
    web-mode
    rainbow-delimiters
    
    ido           ;; интерактивное управление буферами и файлами;
    ido-ubiquitous
    ido-vertical-mode
    smex
    auto-indent-mode
    
    ;;ac-js2      ;; автокомплит js
    js2-mode      ;; подстветка синтаксиса js
    company       ;; popup
    auto-complete
    
    scss-mode 
    ;;tern        ;; автокомплит для js нуждается в npm install -g tern
    ;;tern-auto-complete 
    emmet-mode    ;; zen-coding автокомплит для html - C-j 
    autopair      ;; автозакрытие ковычек и скобок
    which-key     ;; which-key - буфер с шорткат подсказками https://github.com/justbur/emacs-which-key
    buffer-move   ;; перемещение буфера buf-move-<pos>
    expand-region ;; семантическое выделение региона
    )
  "A list of packages to ensure are installed at launch.")

;; Automaticaly install any missing packages
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(yas-global-mode 1)
(require 'hydra)
(require 'powerline)
(require 'moe-theme)
(setq moe-theme-highlight-buffer-id t)
(moe-theme-set-color 'w/b)

(auto-revert-mode t)
(powerline-moe-theme)
;;(moe-light)
(moe-dark)

(require 'org-install)
(require 'ibuffer)
(require 'paredit)
;;(require 'cider)

;; --------------------------------------------------------[ helm ]
(require 'helm)
(require 'helm-config)

(helm-autoresize-mode t)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)

(helm-mode 1)

;; ------------------------------------------------------- [ bookmark ]
(require 'bookmark+)
;;(bmkp-toggle-auto-light-when-jump)
;;(bmkp-toggle-auto-light-when-set)
(require 'redo+)

;;(ac-js2-mode t)

(require 'etags-table)
(setq etags-table-search-up-depth 5)

;; ------------------------------------------------------- [ gpg https://www.gnupg.org/ ]
(require 'epa-file)
(epa-file-enable)


;; ------------------------------------------------------- [ IDO ]
(setq ido-ignore-buffers
      '("\\` " "*Messages*" "*GNU Emacs*" "*Calendar*" "*Completions*" "TAGS"
        "*magit-process*" "*Flycheck error message*" "*Ediff Registry*"
        "*Ibuffer*" "*epc con " "#" "*magit" "*Help*" "*tramp"
        "*anaconda-mode*" "*anaconda-doc*" "*info*"
        "*Shell Command Output*" "*Compile-Log*" "*Python*"
        "*notes*" "*Reftex Select*" "*Shell Command Output*"
        "*.+ output*" "*TeX Help*"))
(setq ido-ignore-files '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./"))
(require 'ido)
(require 'ido-ubiquitous)
(require 'ido-vertical-mode)

(require 'smex) ; Not needed if you use package.el
(require 'magit)
(require 'expand-region)

(global-magit-file-mode t)
(ido-mode t)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(ido-vertical-mode 1)
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; ------------------------------------------------------- [ auto-indent ]
;; (setq auto-indent-on-visit-file t) ;; If you want auto-indent on for files
(setq auto-indent-key-for-end-of-line-then-newline "<M-return>")
(setq auto-indent-key-for-end-of-line-insert-char-then-newline "<C-M-return>")
(require 'auto-indent-mode)
(auto-indent-global-mode)
(setq auto-indent-indent-style 'conservative)

;;(setq ac-js2-evaluate-calls t)
(require 'yasnippet)
(when (require 'yasnippet nil 'noerror)
  (progn
    (yas/load-directory "~/.emacs.d/snippets")))

;; load concrete packages
(add-to-list 'load-path ".")
(load (ser/get-config-dir "seryh/emacs-ser-general.el"))
;;(load (ser/get-config-dir "seryh/emacs-ser-projectile-conf.el"))
(load (ser/get-config-dir "seryh/emacs-cider-conf.el"))
(load (ser/get-config-dir "seryh/emacs-seryh-mdash.el"))
(load (ser/get-config-dir "seryh/emacs-ser-kbd.el"))
(load (ser/get-config-dir "emacs-gulpjs/gulpjs.el"))
(load (ser/get-config-dir "seryh/emacs-ser-txtnav-kbd.el"))
(load (ser/get-config-dir "seryh/stab-mode.el"))
(load (ser/get-config-dir "seryh/emacs-powerline-conf"))
;;(load (ser/get-config-dir "seryh/turn-off-messaging.el"))

(require 'gulpjs)
(require 'auto-complete)

;; ------------------------------------------------------- [ Company ]
(require 'company)
(setq company-minimum-prefix-length 2)
(setq company-tooltip-limit 20)
(setq company-tooltip-align-annotations 't)
(setq company-idle-delay .3)
(setq company-begin-commands '(self-insert-command))
;;(global-company-mode)

(setq auto-mode-alist
      (append '(
                ("\\.clj$" . clojure-mode)
                ("\\.cljc$" . clojure-mode)
                ("\\.edn$" . clojure-mode)
                ("\\.cljs$" . clojurescript-mode)

                ("\\.scss$". scss-mode)
                ("\\.css$". web-mode)
                ("\\.html$". web-mode)
                ("\\.phtml$". web-mode)
                ("\\.org$". org-mode)
                ("\\.gpg$". org-mode)
                ("\\.php$". web-mode)
                ("\\.el$". emacs-lisp-mode)
                (".emacs". emacs-lisp-mode))))

(load (ser/get-config-dir "seryh/emacs-js-conf.el"))

(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(add-hook 'web-mode-hook 
          (lambda ()
            (auto-complete-mode)
            (hs-minor-mode t)
            (emmet-mode t)))

(add-hook 'js2-mode-hook
          (lambda ()
            (auto-complete-mode)))


(add-hook 'scss-mode-hook
          (lambda ()
            (auto-complete-mode)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (company-mode)))

;; (add-hook 'org-mode-hook 
;;           (lambda () 
;;             (drag-stuff-mode -1) 
;;             (linum-mode -1)))

(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files "^#\\|*~\\|^\\.$")

(add-hook 'dired-mode-hook (lambda ()
                             (hl-line-mode t)))



(add-hook 'ibuffer-hook
          (lambda ()
            (hl-line-mode t)      
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))) )

;; ----------------------------------------------- [markdown-mode]
;; needed https://github.com/fletcher/peg-multimarkdown/wiki/How-do-I-install-MultiMarkdown%3F
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; ------------------ [ autopair-mode ]
(defvar autopair-modes '(scss-mode web-mode js2-mode emacs-lisp-mode))
(defun turn-on-autopair-mode () (autopair-mode 1))
(dolist (mode autopair-modes) (add-hook (intern (concat (symbol-name mode) "-hook")) 'turn-on-autopair-mode))
;;(autopair-global-mode) 

;; ------------------ [ web-mode ]
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")))

;; ------------------ [ cua-mode] классическая копипаста, если есть регионы
;; To enter an Emacs command like C-x C-f while the mark is active, use one of the
;; following methods: either hold Shift together with the prefix key, e.g., S-C-x C-f,
;; or quickly type the prefix key twice, e.g., C-x C-x C-f.

;; https://www.emacswiki.org/emacs/PcSelectionMode
(if (fboundp 'pc-selection-mode)
    (pc-selection-mode)
  (require 'pc-select))

(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
;;(setq cua-keep-region-after-copy t) ;; оставлять регион после копирования
;; shift + click select region
;;(define-key global-map (kbd "<S-down-mouse-1>") 'ignore) ; turn off font dialog
;;(define-key global-map (kbd "<S-mouse-1>") 'mouse-set-point)
;;(put 'mouse-set-point 'CUA 'move)


;; ------------------------------------------------- [ input method settings ]
(defun cfg:reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))
(cfg:reverse-input-method 'russian-computer)
(setq default-input-method "cyrillic-jcuken")

(which-key-mode t)
(desktop-save-mode t)

(setq custom-file "~/.emacs.d/seryh/emacs-ser-vars.el")
(load custom-file)


