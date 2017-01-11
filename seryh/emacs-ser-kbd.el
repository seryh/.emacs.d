;; функция для смены ориентации 2 окон
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; функция создания файла для dired-mode
(eval-after-load 'dired
  '(progn
     (define-key dired-mode-map (kbd "C-c n") 'my-dired-create-file)
     (defun my-dired-create-file (file)
       "Create a file called FILE.If FILE already exists, signal an error."
       (interactive
        (list (read-file-name "Create file: " (dired-current-directory))))
       (let* ((expanded (expand-file-name file))
              (try expanded)
              (dir (directory-file-name (file-name-directory expanded)))
              new)
         (if (file-exists-p expanded)
             (error "Cannot create file %s: file exists" expanded))
         ;; Find the topmost nonexistent parent dir (variable `new')
         (while (and try (not (file-exists-p try)) (not (equal new try)))
           (setq new try
                 try (directory-file-name (file-name-directory try))))
         (when (not (file-exists-p dir))
           (make-directory dir t))
         (write-region "" nil expanded t)
         (when new
           (dired-add-file new)
           (dired-move-to-filename))))))


;;(defun find-project-file (file)
;;  (find-file (expand-file-name file (projectile-project-root))))

(bind-keys*
 ("C-x C-b" . ibuffer))

(global-set-key (kbd "M-<f1>")  
                (lambda () (interactive) (dired ".")))
(global-set-key (kbd "M-<f2>") 'ibuffer)
(global-set-key (kbd "M-<f3>") 'imenu)
(global-set-key (kbd "M-<f4>") 'magit-status)

(global-set-key (kbd "<f5>") 'bookmark-bmenu-list)
(global-set-key (kbd "<f6>") 'bookmark-jump)
(global-set-key (kbd "<f7>") 'bookmark-set)

(global-set-key [f2] 'save-buffer)

;;(windmove-default-keybindings) ;; переопределить перемещение по буферу на Shift-<arrow>
;; hide/show
(global-set-key (kbd "C-.") 'hs-toggle-hiding)
(global-set-key (kbd "C-,") 'hs-hide-all)
(global-set-key (kbd "C-x C-,") 'hs-show-all)

(global-set-key (kbd "C-;") 'comment-region)
(global-set-key (kbd "C-:") 'uncomment-region)

(global-set-key "\C-c\C-r" 'replace-string) 

(global-set-key (kbd "C-z") 'undo) ;; по умолчанию емакс уходит в бакграунд 
(global-set-key (kbd "M-z") 'redo)

(defun ser/hRGB ()
  "Syntax color text of the form 「#ff1100」 and 「#abc」 in current buffer"
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[ABCDEFabcdef[:digit:]]\\{3\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background
                      (let* (
                             (ms (match-string-no-properties 0))
                             (r (substring ms 1 2))
                             (g (substring ms 2 3))
                             (b (substring ms 3 4)))
                        (concat "#" r r g g b b))))))
     ("#[ABCDEFabcdef[:digit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-fontify-buffer))

(defun ser/duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

(defun ser/my-revert-buffer-noconfirm ()
  "Call `revert-buffer' with the NOCONFIRM argument set."
  (interactive)
  (revert-buffer nil t))

;; modes

(define-prefix-command 'nav-menu)
(define-key nav-menu "1" 'helm-swoop)
(define-key nav-menu (kbd "<left>") 'helm-swoop-back-to-last-point)
(define-key nav-menu "2" 'helm-multi-swoop)
(define-key nav-menu "3" 'elm-multi-swoop-all)

;; -------------------- [helm kdb]
(global-set-key (kbd "C-f") 'helm-swoop)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(define-prefix-command 'seryh-menu)
(global-set-key "\M-m" 'seryh-menu)
(define-key seryh-menu "1" 'js2-mode)
(define-key seryh-menu "2" 'web-mode)
(define-key seryh-menu "3" 'conf-mode)
(define-key seryh-menu "4" 'rainbow-delimiters-mode)
(define-key seryh-menu "5" 'org-mode)
(define-key seryh-menu "6" 'ser/hRGB)
(define-key seryh-menu "l" 'toggle-truncate-lines) ;; режим word-wrap
(define-key seryh-menu "r" 'replace-string)        ;; replace
(define-key seryh-menu "p" 'ser/pretty-text)
(define-key seryh-menu "w" 'whitespace-mode)
(define-key seryh-menu "g" 'gulpjs-start-task)
(define-key seryh-menu "d" 'ser/duplicate-line)
(define-key seryh-menu (kbd "<ESC>") 'ser/my-revert-buffer-noconfirm)
(define-key seryh-menu (kbd "<SPC>") 'nav-menu)



;; projectile-mode-kbd
;;(defun my-projectile-mode-config ()
;;  "For use in `projectile-mode-hook'."
;;  (local-set-key (kbd "M-<f1>")  ;; открывает директорию с проектом в котором находится
;;                 (lambda ()
;;                   (interactive)
;;                   (projectile-dired))))

;; add to hook
;;(add-hook 'projectile-mode-hook 'my-projectile-mode-config)

;; Resize the current window
(defun win-resize-top-or-bot ()
  "Figure out if the current window is on top, bottom or in the
   middle"
  (let* ((win-edges (window-edges))
         (this-window-y-min (nth 1 win-edges))
         (this-window-y-max (nth 3 win-edges))
         (fr-height (frame-height)))
    (cond
     ((eq 0 this-window-y-min) "top")
     ((eq (- fr-height 1) this-window-y-max) "bot")
     (t "mid"))))

(defun win-resize-left-or-right ()
  "Figure out if the current window is to the left, right or in the
   middle"
  (let* ((win-edges (window-edges))
         (this-window-x-min (nth 0 win-edges))
         (this-window-x-max (nth 2 win-edges))
         (fr-width (frame-width)))
    (cond
     ((eq 0 this-window-x-min) "left")
     ((eq (+ fr-width 4) this-window-x-max) "right")
     (t "mid"))))

(defun win-resize-enlarge-vert ()
  (interactive)
  (cond
   ((equal "top" (win-resize-top-or-bot)) (enlarge-window -5))
   ((equal "bot" (win-resize-top-or-bot)) (enlarge-window 5))
   ((equal "mid" (win-resize-top-or-bot)) (enlarge-window -5))
   (t (message "nil"))))

(defun win-resize-minimize-vert ()
  (interactive)
  (cond
   ((equal "top" (win-resize-top-or-bot)) (enlarge-window 5))
   ((equal "bot" (win-resize-top-or-bot)) (enlarge-window -5))
   ((equal "mid" (win-resize-top-or-bot)) (enlarge-window 5))
   (t (message "nil"))))

(defun win-resize-enlarge-horiz ()
  (interactive)
  (cond
   ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally -30))
   ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally 30))
   ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally 30))))

(defun win-resize-minimize-horiz ()
  (interactive)
  (cond
   ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally 30))
   ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally -30))
   ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally -30))))


;; Resize window old
;; (global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
;; (global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-S-<down>") 'shrink-window)
;; (global-set-key (kbd "C-S-<up>") 'enlarge-window)


;; Resize window
(global-set-key (kbd "C-S-<left>") 'win-resize-enlarge-horiz)
(global-set-key (kbd "C-S-<right>") 'win-resize-minimize-horiz)
(global-set-key (kbd "C-S-<down>") 'win-resize-minimize-vert)
(global-set-key (kbd "C-S-<up>") 'win-resize-enlarge-vert)

;; Move active cursor to window
;; (global-set-key (kbd "<M-right>") 'windmove-right)
;; (global-set-key (kbd "<M-left>") 'windmove-left)
;; (global-set-key (kbd "<M-up>") 'windmove-up)            
;; (global-set-key (kbd "<M-down>") 'windmove-down)       
(global-set-key (kbd "<scroll>") 'other-window)

;; Swap current buffer with buffer in direction of arrow
(global-set-key (kbd "C-x t <right>") 'buf-move-right)
(global-set-key (kbd "C-x t <left>") 'buf-move-left)
(global-set-key (kbd "C-x t <up>") 'buf-move-up)
(global-set-key (kbd "C-x t <down>") 'buf-move-down)
(global-set-key (kbd "C-0") 'toggle-window-split) ;; сменить ориентацию split

;; если есть выделенный регион то используем его для поиска
(defun ser/isearch-with-region ()
  "Use region as the isearch text."
  (when mark-active
    (let ((region (funcall region-extract-function nil)))
      (deactivate-mark)
      (isearch-push-state)
      (isearch-yank-string region)
)))

(add-hook 'isearch-mode-hook #'ser/isearch-with-region)

(add-hook 'isearch-mode-hook (lambda ()
      (define-key isearch-mode-map "\C-h" 'isearch-mode-help)
      (define-key isearch-mode-map "\C-t" 'isearch-toggle-regexp)
      (define-key isearch-mode-map "\C-c" 'isearch-toggle-case-fold)
      (define-key isearch-mode-map "\C-e" 'isearch-edit-string)
))

(defun my-clear-message ()
  (interactive)
  (message nil))

(global-set-key (kbd "C-c c") 'my-clear-message)

