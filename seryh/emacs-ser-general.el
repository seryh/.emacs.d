;;; emacs-rc-general.el ---

;; решаем виндопроблемы с кодирвокой
                                        ; (set-language-environment 'UTF-8)
                                        ; (setq default-input-method 'russian-computer)
                                        ; (set-selection-coding-system 'windows-1251)
                                        ; (set-default-coding-systems 'windows-1251)
                                        ; (prefer-coding-system 'windows-1251)

;; скрыть все меню
(when (system-is-windows)
  (setenv "PATH"
          (concat
           "C:\\msys64\\usr\\bin;"
           "C:\\msys64\\mingw64\\bin;"
           (getenv "PATH")))

  (setq frame-title-format "%b (%f)")
  (set-file-name-coding-system 'windows-1251)
  (setq default-process-coding-system '(windows-1251 . windows-1251))
  (prefer-coding-system 'windows-1251)
  (set-language-environment 'UTF-8)
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
  (setq ring-bell-function 'ignore) ;; отключить звуковой сигнал
  )

(custom-set-variables
 '(buffer-face-mode-face (quote (:background "black"))))

(add-hook 'dired-mode-hook 'buffer-face-mode)

;;(setq inhibit-splash-screen t)
;;(setq inhibit-startup-message t)
;;(setq inhibit-startup-screen t)

(setq-default tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

(setq-default js-indent-level 2)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)

;; Display file size/time in mode-line
(setq display-time-24hr-format t) ;; 24-часовой временной формат в mode-line

(require 'tree-widget)
(require 'linum)                    ;; show line numbers

(global-linum-mode 1)
(show-paren-mode 1)                 ;; show pair parentheses

(setq-default
 uniquify-buffer-name-style (quote forward)
 column-number-mode t
 size-indication-mode t            ;; размер файла в %-ах
 transient-mark-mode t
 ;;  x-stretch-cursor 0                ;; Show cursor as block, not underline
 cursor-type 'bar
 show-paren-delay 0                ;; set paren show delay
 global-font-lock-mode 1           
 )


;; Require typing only "y" or"n" instead of the full "yes" to confirm destructive actions.
(fset 'yes-or-no-p 'y-or-n-p) 

;; Fira Code

(set-face-attribute 'default nil :family "Fira Code" :height 110)
;;(set-face-attribute 'default nil :family "Sauce Code Powerline" :height 110)

(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               ;;(46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))


;; Show-paren-mode settings
;;(show-paren-mode t) ;; включить выделение выражений между {},[],()
;;(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()
