;; emacs-rc-general.el ---

;; Turn off mouse interface early in startup to avoid momentary display
(when (display-graphic-p)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(when (not (display-graphic-p))
  (menu-bar-mode -1))

(when (system-is-windows)
  (setenv "PATH"
          (concat
           "C:\\msys64\\usr\\bin;"
           "C:\\msys64\\mingw64\\bin;"
           "C:\\Program Files\\7-Zip;"
           (getenv "PATH")))

  (setq frame-title-format "%b (%f)")
  (set-file-name-coding-system 'windows-1251)
  (setq default-process-coding-system '(windows-1251 . windows-1251))
  (prefer-coding-system 'windows-1251)
  (set-language-environment 'UTF-8)

  (defadvice shell (after my-shell-advice)
    (set-buffer-process-coding-system 'cp1251 'cp1251))
  (ad-activate 'shell)
  )


(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал
(setq auto-revert-verbose nil) ;; отключить вывод сообщений "Reverting buffer %s." 

;; Интерфейс
(global-linum-mode 1)
(show-paren-mode 1)                 ;; show pair parentheses
  
(setq-default
 uniquify-buffer-name-style (quote forward)
 size-indication-mode t            ;; размер файла в %-ах
 transient-mark-mode t
 show-paren-delay 0                ;; set paren show delay
 cursor-type 'box                  ;; bar, hollow, hbar, box
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
(setq-default case-fold-search t)                  ;; Поиск без учёта регистра
(global-font-lock-mode t)                    ;; Поддержка различных начертаний шрифтов в буфере
(setq font-lock-maximum-decoration t)        ;; Максимальное использование различных начертаний шрифтов
(if window-system (setq scalable-fonts-allowed t)) ;; Масштабируемые шрифты в графическом интерфейсе
(setq read-file-name-completion-ignore-case t) ;; Дополнение имён файлов без учёта регистра
(file-name-shadow-mode t)                    ;; Затенять игнорируемую часть имени файла
;;(setq resize-mini-windows nil)                 ;; Изменять при необходимости размер минибуфера по вертикали
;;(setq resize-minibuffer nil)
(auto-image-file-mode t)                     ;; Показывать картинки
(setq read-quoted-char-radix 16)             ;; Ввод символов по коду в десятичном счислении C-q
(fset 'yes-or-no-p 'y-or-n-p) ;; Require typing only "y" or"n" 

;; scroll lag fix
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 1
  scroll-preserve-screen-position 1)


(set-face-attribute 'default nil :height 100)

;; Show-paren-mode settings
;;(show-paren-mode t) ;; включить выделение выражений между {},[],()
;;(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Consolas")
  
  ;; WARNING!  Depending on the default font,
  ;; if the size is not supported very well, the frame will be clipped
  ;; so that the beginning of the buffer may not be visible correctly. 
  (set-face-attribute 'default nil :height 155)

  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
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
(add-hook 'focus-out-hook
          (lambda ()
            (cl-letf (((symbol-function 'message) #'format))
              (save-some-buffers t))))

;;------------------ [ibuffer]
(setq ibuffer-saved-filter-groups
      (quote (("default"
                   ("dired" (mode . dired-mode))
                   ("web"  (or
                            (mode . sass-mode)
                            (mode . js2-mode)
                            (mode . web-mode)))
                   ("emacs" (or
                             (name . "^\\*scratch\\*$")
                             (name . "^\\*Messages\\*$")))
                   ("clojure" (or
                               (mode . clojure-mode)))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

(defadvice ibuffer-update-title-and-summary (after remove-column-titles)
   (save-excursion
      (set-buffer "*Ibuffer*")
      (toggle-read-only 0)
      (goto-char 1)
      (search-forward "-\n" nil t)
      (delete-region 1 (point))
      (let ((window-min-height 1)) 
        ;; save a little screen estate
        (shrink-window-if-larger-than-buffer))
      (toggle-read-only)))
  
(ad-activate 'ibuffer-update-title-and-summary)

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)
