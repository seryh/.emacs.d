(require 'package)

;; OLD package settings
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; (when (< emacs-major-version 24)
;;   (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;; (package-initialize)

(defvar gnu '("gnu" . "https://elpa.gnu.org/packages/"))
(defvar melpa '("melpa" . "https://melpa.org/packages/"))
(defvar melpa-stable '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; Add marmalade to package repos
(setq package-archives nil)
(add-to-list 'package-archives melpa-stable t)
(add-to-list 'package-archives melpa t)
(add-to-list 'package-archives gnu t)

(package-initialize)

(defun packages-install (&rest packages)
  (message "running packages-install")
  (mapc (lambda (package)
          (let ((name (car package))
                (repo (cdr package)))
            (when (not (package-installed-p name))
              (let ((package-archives (list repo)))
                (package-initialize)
                (package-install name)))))
        packages)
  (package-initialize)
  (delete-other-windows))


;; Install extensions if they're missing
(defun init--install-packages ()
  (message "Lets install some packages")
  (packages-install
   ;; Since use-package this is the only entry here
   ;; ALWAYS try to use use-package!
   (cons 'use-package melpa)
   ))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; -------------------------------------------------------------

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(defmacro with-system (type &rest body)
  "Evaluate BODY if `system-type' equals TYPE."
  (declare (indent defun))
  `(when (eq system-type ',type)
     ,@body))

;; System-type definition
(defun system-is-linux()
  (string-equal system-type "gnu/linux"))

(defun system-is-windows()
  (string-equal system-type "windows-nt"))

(defun system-is-mac()
  (string-equal system-type "darwin"))

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
    aggressive-indent

    hydra
    ;; request
    xml
    use-package
    yasnippet

    ;;bookmark+
    ;;redo+

    helm-swoop

    ;; git
    magit
    diff-hl

    powerline
    moe-theme
    cl-lib
    ;;etags-table
    org-bullets

    ;;hl-line+

    ;; clojure
    ;; cider
    paredit

    rainbow-delimiters

    ido           ;; интерактивное управление буферами и файлами;

    ido-vertical-mode
    smex

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

;;(helm-mode 1)

;; ------------------------------------------------------- [ bookmark ]
;;(require 'bookmark+)
;;(bmkp-toggle-auto-light-when-jump)
;;(bmkp-toggle-auto-light-when-set)

(load (ser/get-config-dir "seryh/redo+.el"))
;;(load (ser/get-config-dir "seryh/pug-mode.el"))
(load (ser/get-config-dir "seryh/hl-line+.el"))

;;(ac-js2-mode t)

;;(require 'etags-table)
;;(setq etags-table-search-up-depth 5)


;; ------------------------------------------------------- [ gpg https://www.gnupg.org/ ]
(require 'epa-file)

(when (system-is-mac)
  ;; (require 'ls-lisp)
  ;; (setq ls-lisp-use-insert-directory-program nil)
  (custom-set-variables '(epg-gpg-program  "/usr/local/bin/gpg"))
  )

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

(require 'ido-vertical-mode)

(require 'smex) ; Not needed if you use package.el

;; ----------- [ magit ]
(require 'magit)
(global-magit-file-mode t)

(with-system gnu/linux
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode 1)
  )

(when (eq system-type 'darwin)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode 1)
  )
;; -------------------------------

;; (ido-mode t)
;; (ido-everywhere 1)
;; (ido-vertical-mode 1)
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;;(setq ac-js2-evaluate-calls t)
(require 'yasnippet)
(when (require 'yasnippet nil 'noerror)
  (progn
    (yas/load-directory "~/.emacs.d/snippets")))


(use-package general
  :ensure t)

;; load concrete packages
(add-to-list 'load-path ".")
(load (ser/get-config-dir "seryh/emacs-ser-general.el"))
;;(load (ser/get-config-dir "seryh/emacs-ser-projectile-conf.el"))
;;(load (ser/get-config-dir "seryh/emacs-cider-conf.el"))
(load (ser/get-config-dir "seryh/emacs-seryh-mdash.el"))
(load (ser/get-config-dir "seryh/emacs-ser-kbd.el"))
;;(load (ser/get-config-dir "emacs-gulpjs/gulpjs.el"))
(load (ser/get-config-dir "seryh/emacs-ser-txtnav-kbd.el"))
;;(load (ser/get-config-dir "seryh/stab-mode.el"))
(load (ser/get-config-dir "seryh/emacs-powerline-conf"))
;;(load (ser/get-config-dir "seryh/turn-off-messaging.el"))


;;(require 'gulpjs)
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
      (append '(("\\.clj$" . clojure-mode)
                ("\\.cljc$" . clojure-mode)
                ("\\.edn$" . clojure-mode)
                ("\\.cljs$" . clojurescript-mode)

		("\\.scss$". scss-mode)

                ("\\.java$". java-mode)

                ("\\.conf$". conf-mode)
                ("\\.org$". org-mode)
                ("\\.gpg$". org-mode)
                ;;("\\.pug$". pug-mode)

                ("\\.yaml$". conf-mode)
                ("\\.yml$". conf-mode)
                ("Makefile$". makefile-mode)

                ("\\.el$". emacs-lisp-mode)
                (".emacs". emacs-lisp-mode))))


;; ------------------------------------ [ web-mode ]
(use-package web-mode
  :ensure t
  :config
      (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.phtml?\\'" . web-mode))

      ;; (add-to-list 'auto-mode-alist '("\\.php?\\'" . web-mode))
      ;; (setq web-mode-engines-alist
      ;;       '(("php" . "\\.phtml\\'")))

      (setq web-mode-engines-alist
            '(("\\.phtml\\'")))

      ;; (setq web-mode-ac-sources-alist
      ;;       '(("css" . (ac-source-css-property))
      ;;         ("html" . (ac-source-words-in-buffer ac-source-abbrev))))

      (setq web-mode-enable-auto-closing t)
  :init
      (add-hook 'web-mode-hook
                (lambda ()
                  (auto-complete-mode)
                  (aggressive-indent-mode t)
                  (hs-minor-mode t) ;; hide/show block C-.
                  (emmet-mode t)    ;; zencoding-mode
                  ))
      )

(setq web-mode-enable-auto-quoting t) ; this fixes the quote problem
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
;; ----------------------------------------------------------


(load (ser/get-config-dir "flow-js2/flow-js2-mode.el"))
(load (ser/get-config-dir "seryh/emacs-js-conf.el"))

;;(load (ser/get-config-dir "flow-js2/flow-js2-test-helpers.el"))
;;(load (ser/get-config-dir "seryh/emacs-go-conf.el"))
(load (ser/get-config-dir "seryh/emacs-php-conf.el"))
(load (ser/get-config-dir "seryh/emacs-ser-tide.el"))
;;(with-system gnu/linux (load (ser/get-config-dir "seryh/emacs-docker-conf.el")))

;; -------------------------- [ org-mode ]
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-src-fontify-natively t)


(add-hook 'js2-mode-hook
          (lambda ()
            (auto-complete-mode)))


(add-hook 'scss-mode-hook
          (lambda ()
            (aggressive-indent-mode t)
            (auto-complete-mode)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (company-mode)))



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

;; ------------------------------------ [beacon]

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1)
  (setq beacon-color "magenta")
  (setq beacon-blink-duration 0.1))

;; -------------------------------------- [hungry-delete]

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))


;; ------------------------------------ [ autopair-mode ] -- автозакрытие скобок
(defvar autopair-modes '(scss-mode web-mode emacs-lisp-mode))
(defun turn-on-autopair-mode () (autopair-mode 1))
(dolist (mode autopair-modes) (add-hook (intern (concat (symbol-name mode) "-hook")) 'turn-on-autopair-mode))
;;(autopair-global-mode)

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
(setq cua-enable-cua-keys nil)        ;; disable the overriding of standard Emacs binding by CUA mode
(transient-mark-mode 1) ;; No region when it is not highlighted


;; -------------------------------------------------
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))


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


(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


(defun use-monospace ()
  "Switch the current buffer to a monospace font."
  (face-remap-add-relative 'default '(:family "Monospace")))

(add-hook 'dired-mode-hook 'use-monospace)
