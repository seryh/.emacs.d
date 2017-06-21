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
      (dired-move-to-filename))))


(defun ser/copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

;;(defun find-project-file (file)
;;  (find-file (expand-file-name file (projectile-project-root))))

(bind-keys*
 ("C-x C-b" . ibuffer))

(global-set-key (kbd "M-<f1>")  
                (lambda () (interactive) (dired ".")))
(global-set-key (kbd "M-<f2>") 'ibuffer)
(global-set-key (kbd "<apps>") 'ibuffer)
(global-set-key (kbd "<f5>") 'ser/my-revert-buffer-noconfirm)

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
(global-set-key (kbd "<Scroll_Lock>") 'other-window)

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

;; -------------------------------------------------- [ hydra ibuffer]


(defhydra hydra-ibuffer (:color pink :columns 3 :hint nil)
  "Action"
  ("SPC" nil)
  ("*" hydra-ibuffer-mark/body :exit t)
  ("%" hydra-ibuffer-regex/body :exit t)
  ("/" hydra-ibuffer-filter/body :exit t)
  ("s" hydra-ibuffer-sort/body "sort" :exit t)
  ("A" ibuffer-do-view "view")
  ("D" ibuffer-do-delete "delete")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("o" ibuffer-visit-buffer-other-window "other window")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("S" ibuffer-do-save "save")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe"))

(defhydra hydra-ibuffer-mark (:color teal :columns 5 :hint nil
                                     :after-exit
                                     (if (eq major-mode 'ibuffer-mode)
                                         (hydra-ibuffer/body)))
  "Mark"
  ("SPC" nil)
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("%" hydra-ibuffer-regex/body "regex"))

(defhydra hydra-ibuffer-regex (:color teal :hint nil
                                      :after-exit
                                      (if (eq major-mode 'ibuffer-mode)
                                          (hydra-ibuffer/body)))
  "Regex"
  ("SPC" nil)
  ("*" hydra-ibuffer-mark/body "mark")
  ("f" ibuffer-mark-by-file-name-regexp "filename")
  ("m" ibuffer-mark-by-mode-regexp "mode")
  ("n" ibuffer-mark-by-name-regexp "name"))

(defhydra hydra-ibuffer-sort (:color teal :columns 3 :hint nil
                                     :after-exit
                                     (if (eq major-mode 'ibuffer-mode)
                                         (hydra-ibuffer/body)))
  "Sort"
  ("SPC" nil)
  ("i" ibuffer-invert-sorting "invert")
  ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
  ("v" ibuffer-do-sort-by-recency "recently used")
  ("s" ibuffer-do-sort-by-size "size")
  ("f" ibuffer-do-sort-by-filename/process "filename")
  ("m" ibuffer-do-sort-by-major-mode "mode"))

(defhydra hydra-ibuffer-filter (:color teal :columns 4 :hint nil
                                       :after-exit
                                       (if (eq major-mode 'ibuffer-mode)
                                           (hydra-ibuffer/body)))
  "Filter"
  ("SPC" nil)
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("SPC" nil "Bye"))

(bind-keys :map ibuffer-mode-map
           ("M-o" . nil)             ; ibuffer-visit-buffer-1-window
           ("SPC" . hydra-ibuffer/body))

;; ------------------------------------------------------------ [hydra seryh menu]


(defhydra hydra-seryh-menu (:color pink :columns 4 :hint nil)
  "
  ^Mode^             ^Tools^           ^Actions^          ^Search             ^JS          
  ^^^^^^^^-------------------------------------------------------------------------------------------------
  _1_: RGB-show      _b_: bookmark    _u_: untab       _;_: region         _3_: indium-scratch         
  _2_: line-show     _g_: GIT         _c_: copy-line   _f_: files          _4_: indium-connect-to-chrome 
  _w_: whitespace    _t_: gulp        _d_: duble-line  _r_: replace               
  _l_: trun-lines    _i_: imenu       _p_: pretty-region"
  
  ("ESC" ser/my-revert-buffer-noconfirm "reopen" :color blue)
  ("1" ser/hRGB nil   :color blue)    ;; подстветка #RGB
  ("2" linum-mode nil :color blue)
  
  ("3" indium-scratch nil :color blue)
  ("4" indium-connect-to-chrome nil :color blue)
  
  (";" iedit-mode nil :color blue)
  ("w" whitespace-mode nil :color blue)
  ("b" hydra-bookmark/body nil :color blue)
  ("u" untabify            nil :color blue) ;; убрать табы
  ("f" helm-find-files     nil :color blue)
  ("c" ser/copy-line       nil :color blue)
  ("g" magit-status        nil :color blue)
  ("r" replace-string      nil :color blue)
  ("l" toggle-truncate-lines nil :color blue)
  ("t" gulpjs-start-task     nil :color blue)
  ("d" ser/duplicate-line    nil :color blue)
  ("i" imenu                 nil :color blue)
  ("p" ser/pretty-text       nil :color blue)
  ("x" save-buffers-kill-terminal "Save-and-Exit")
  ("q" nil "hide menu")

  ;; русская раскладка
  ("и" hydra-bookmark/body nil :color blue)
  ("г" untabify            nil :color blue) ;; убрать табы
  ("а" helm-find-files     nil :color blue)
  ("с" ser/copy-line       nil :color blue)
  ("п" magit-status        nil :color blue)
  ("к" replace-string      nil :color blue)
  ("д" toggle-truncate-lines nil :color blue)
  ("е" gulpjs-start-task     nil :color blue)
  ("в" ser/duplicate-line    nil :color blue)
  ("ш" imenu                 nil :color blue)
  ("з" ser/pretty-text       nil :color blue)
  ("ч" save-buffers-kill-terminal nil)
  ("й" nil)
  
  ("SPC" nil))

(defhydra hydra-bookmark (:color teal :columns 3 :hint nil)
  "bookmarks"
  ("l" bookmark-bmenu-list "list" :color blue)
  ("j" bookmark-jump "jump to" :color blue)
  ("s" bookmark-set "bookmark set" :color blue)
  ("q" nil "hide menu")
  ("SPC" nil))

(global-set-key (kbd "M-m") 'hydra-seryh-menu/body)


;; ------------------------------------------------------------ [hydra dired]

;; TODO: if unix system use another shell command
(defun ser/browse-dired ()
  "Run explorer on the directory of the current buffer."
   (interactive)
   (shell-command
    (concat "explorer "
     (replace-regexp-in-string "/" "\\"
      (file-name-directory (expand-file-name default-directory)) t t))))

(eval-after-load 'dired
  '(progn
     (defhydra hydra-dired (:color blue)
       "?"
       ("cp" dired-do-copy "copy file")
       ("cf" my-dired-create-file "create file")
       ("mv" diredp-do-move-recursive "mv")
       ("mk" dired-create-directory "mkdir")
       ("b"  ser/browse-dired "browse")
       ("q"  nil "Bye")
       ("SPC" nil))))

(defun dired-mode-hook-hydra-setup ()
  (local-unset-key (kbd "<SPC>"))
  (local-set-key (kbd "<SPC>") 'hydra-dired/body))
(add-hook 'dired-mode-hook 'dired-mode-hook-hydra-setup)

;; -------------------------------------------------------- [helm kdb]
(global-set-key (kbd "C-f") 'helm-swoop)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
