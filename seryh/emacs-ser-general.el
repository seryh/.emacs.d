;; emacs-rc-general.el ---

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

;; Интерфейс
(global-linum-mode 1)
(show-paren-mode 1)                 ;; show pair parentheses
  
(setq-default
 uniquify-buffer-name-style (quote forward)
 size-indication-mode t            ;; размер файла в %-ах
 transient-mark-mode t
 show-paren-delay 0                ;; set paren show delay
 cursor-type 'bar
)

(setq column-number-mode t)                  ;; Показывать номер текущей колонки
(setq line-number-mode t)                    ;; Показывать номер текущей строки
(setq inhibit-startup-message t)             ;; Не показываем сообщение при старте
(setq echo-keystrokes 0.001)                 ;; Мгновенное отображение набранных сочетаний клавиш
(setq use-dialog-boxes nil)                  ;; Не использовать диалоговые окна
(setq cursor-in-non-selected-windows nil)    ;; Не показывать курсоры в неактивных окнах
(setq default-tab-width 4)                   ;; размер табуляции
(setq-default indent-tabs-mode nil)          ;; отступ только пробелами
(setq initial-scratch-message nil)           ;; Scratch buffer settings. Очищаем его.
(setq case-fold-search t)                    ;; Поиск без учёта регистра
(global-font-lock-mode t)                    ;; Поддержка различных начертаний шрифтов в буфере
(setq font-lock-maximum-decoration t)        ;; Максимальное использование различных начертаний шрифтов
(if window-system (setq scalable-fonts-allowed t)) ;; Масштабируемые шрифты в графическом интерфейсе
(setq read-file-name-completion-ignore-case t) ;; Дополнение имён файлов без учёта регистра
(file-name-shadow-mode t)                    ;; Затенять игнорируемую часть имени файла
(setq resize-mini-windows nil)                 ;; Изменять при необходимости размер минибуфера по вертикали
(setq resize-minibuffer nil)
(auto-image-file-mode t)                     ;; Показывать картинки
(setq read-quoted-char-radix 16)             ;; Ввод символов по коду в десятичном счислении C-q
(fset 'yes-or-no-p 'y-or-n-p) ;; Require typing only "y" or"n" 


;; scroll lag fix
(setq scroll-conservatively 1)
(setq scroll-step 1)
(setq scroll-margin 1)
(setq next-screen-context-lines 1)
(setq mouse-wheel-scroll-amount '(1)) ;; mouse scroll moves 1 line at a time, instead of 5 lines
(setq mouse-wheel-progressive-speed 1) ;; on a long mouse scroll keep scrolling by 1 line


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

(setq which-key-idle-delay 1.0)
(setq which-key-separator " → " )


