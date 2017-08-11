;; emacs-rc-general.el ---

;; Turn off mouse interface early in startup to avoid momentary display
(when (display-graphic-p)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(when (not (display-graphic-p))
  (menu-bar-mode -1))


(set-face-attribute 'default nil :height 100)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(with-system gnu/linux
  (setq frame-title-format "%f")
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin"))))

(when (system-is-windows)
  
  ;;(setq default-directory "C:\\Users\\Seryh\\Downloads")
  
  (setenv "PATH"
          (concat
           "C:\\msys64\\usr\\bin;"
           "C:\\msys64\\mingw64\\bin;"
           "C:\\Program Files\\7-Zip;"
           (getenv "PATH")))

  ;; (set-face-attribute 'default nil
  ;;                     :family "Fira Code"
  ;;                     :height 100)
  
  (set-face-attribute 'default nil
                      :family "Liberation Mono"
                      :height 105)
  
  (setq frame-title-format "%b (%f)")
  (set-file-name-coding-system 'windows-1251)
  (setq default-process-coding-system '(windows-1251 . windows-1251))
  (prefer-coding-system 'windows-1251)
  (set-language-environment 'UTF-8)

  (defadvice shell (after my-shell-advice)
    (set-buffer-process-coding-system 'cp1251 'cp1251))
  (ad-activate 'shell))

(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал
(setq auto-revert-verbose nil)    ;; отключить вывод сообщений "Reverting buffer %s." 

;; Интерфейс
;;(global-linum-mode 1)

;; Show-paren-mode settings
(show-paren-mode t)                 ;; включить выделение выражений между {},[],()
;;(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()
(set-face-background 'show-paren-match-face "purple4")
(set-face-foreground 'show-paren-match "#def")

(set-face-background 'fringe "black-5")  ;; gray20 or black-5

(setq column-number-mode t)                  ;; Показывать номер текущей колонки
(setq line-number-mode t)                    ;; Показывать номер текущей строки
(setq inhibit-startup-message t)             ;; Не показываем сообщение при старте
(setq echo-keystrokes 0.001)                 ;; Мгновенное отображение набранных сочетаний клавиш
(setq use-dialog-boxes nil)                  ;; Не использовать диалоговые окна
(setq cursor-in-non-selected-windows nil)    ;; Не показывать курсоры в неактивных окнах
(setq blink-cursor-mode nil)                 ;; Не мигать курсором
(setq default-tab-width 4)                   ;; размер табуляции
(setq-default indent-tabs-mode nil)          ;; отступ только пробелами
(setq initial-scratch-message nil)           ;; Scratch buffer settings. Очищаем его.
(setq-default case-fold-search t)            ;; Поиск без учёта регистра
(setq-default word-wrap t)
(setq auto-save-default nil)                 ;; отключить авто сохранение
;;(require 'hl-line+) 
;;(global-hl-line-mode t)                      ;; подсветка текущей строки

;; http://stackoverflow.com/questions/18316665/how-to-improve-emacs-performace-when-view-large-file
(global-font-lock-mode t)                    ;; Поддержка различных начертаний шрифтов в буфере - t




(setq ns-pop-up-frames nil) ;; Don’t open files from the workspace in a new frame

;; optimization
(setq jit-lock-defer-time 0.05)
(setq fast-but-imprecise-scrolling t)        ;; быстрая навигация курсором но не точная
(setq redisplay-dont-pause t)
(setq tooltip-delay 0.15)
(setq load-prefer-newer t)

;; Mac Emacs settings
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

(setq font-lock-maximum-decoration t)              ;; Максимальное использование различных начертаний шрифтов
(if window-system (setq scalable-fonts-allowed t)) ;; Масштабируемые шрифты в графическом интерфейсе
(setq read-file-name-completion-ignore-case t)     ;; Дополнение имён файлов без учёта регистра
(file-name-shadow-mode t)                          ;; Затенять игнорируемую часть имени файла
;;(setq resize-mini-windows nil)                   ;; Изменять при необходимости размер минибуфера по вертикали
;;(setq resize-minibuffer nil)
(auto-image-file-mode t)                     ;; Показывать картинки
(setq read-quoted-char-radix 16)             ;; Ввод символов по коду в десятичном счислении C-q
(fset 'yes-or-no-p 'y-or-n-p) ;; Require typing only "y" or"n" 

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:weight bold :foreground "brown")))))



;; (defvar label-hl-modes '(scss-mode web-mode clojure-mode js2-mode emacs-lisp-mode))
;; (defun turn-on-label-hl-mode () (font-lock-add-keywords
;;                                  nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|HACK\\|REFACTOR\\|NOCOMMIT\\)"
;;                                         1 font-lock-warning-face t))))
;; (dolist (mode label-hl-modes) (add-hook (intern (concat (symbol-name mode) "-hook")) 'turn-on-label-hl-mode))

;; scroll fix
;;   scroll-margin 1
;;   scroll-step 1
;;   scroll-preserve-screen-position 1
(setq scroll-conservatively 10000)
(setq linum-delay t)


(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Consolas")
  
  ;; WARNING!  Depending on the default font,
  ;; if the size is not supported very well, the frame will be clipped
  ;; so that the beginning of the buffer may not be visible correctly. 
  (set-face-attribute 'default nil :height 155)

  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
  )


(with-system gnu/linux
  (set-face-attribute 'default nil
                      :family "Source Code Pro"
                      :height 104
                      :weight 'normal
                      :width 'normal)
  )


(setq which-key-idle-delay 1.0)
(setq which-key-separator " → " )

(require 'which-key)
(add-to-list 'which-key-key-replacement-alist '("TAB" . "↹"))
(add-to-list 'which-key-key-replacement-alist '("RET" . "⏎"))
(add-to-list 'which-key-key-replacement-alist '("DEL" . "⇤"))
(add-to-list 'which-key-key-replacement-alist '("SPC" . "␣"))

;; Ido-mode customizations
(require 'cl-lib) ; Used: cl-letf.
(setq ido-decorations
      (quote
       ("\n-> "           ; Opening bracket around prospect list
        ""                ; Closing bracket around prospect list
        "\n   "           ; separator between prospects
        "\n   ..."        ; appears at end of truncated list of prospects
        "["               ; opening bracket around common match string
        "]"               ; closing bracket around common match string
        " [No match]"     ; displayed when there is no match
        " [Matched]"      ; displayed if there is a single match
        " [Not readable]" ; current diretory is not readable
        " [Too big]"      ; directory too big
        " [Confirm]")))   ; confirm creation of new file or buffer

(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-completion-map [down] 'ido-next-match)
            (define-key ido-completion-map [up] 'ido-prev-match)
            (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
            (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)))

;; Save on tab-out
;; (add-hook 'focus-out-hook
;;           (lambda ()
;;             (cl-letf (((symbol-function 'message) #'format))
;;               (save-some-buffers t))))

;;------------------ [ibuffer]
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("org"   (mode . org-mode))
               ("golang" (mode . go-mode))
               ("php" (mode . php-mode))
               ("web"  (or
                        (mode . scss-mode)
                        (mode . js2-mode)
                        (mode . rjsx-mode)
                        (mode . web-mode)))
               ("emacs" (or
                         (name . "^\\*.+\*$")))
               ("clojure" (or
                           (mode . clojure-mode)
                           (mode . clojurescript-mode)))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(setq-default
 uniquify-buffer-name-style (quote forward)
 size-indication-mode t            ;; размер файла в %-ах
 transient-mark-mode t
 show-paren-delay 0                ;; set paren show delay
 cursor-type 'hbar
 )

(defun ser/set-cursor-magenta ()
  "set cursor style"
  (interactive)
  (setq cursor-type 'hbar)
  (set-cursor-color "magenta"))

(ser/set-cursor-magenta)

(add-hook 'after-init-hook (lambda () (set-cursor-color "magenta")))
;;(add-hook 'input-method-activate-hook (lambda () (set-cursor-color "magenta")))

;; -------------------------------- [ transparency ]
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))

(global-set-key (kbd "C-c t") 'toggle-transparency)
