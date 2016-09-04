(define-key projectile-mode-map [?\s-d] 'projectile-find-dir)
(define-key projectile-mode-map [?\s-p] 'projectile-switch-project)
(define-key projectile-mode-map [?\s-f] 'projectile-find-file)
(define-key projectile-mode-map [?\s-g] 'projectile-grep)

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


(defun find-project-file (file)
  (find-file (expand-file-name file (projectile-project-root))))

;; файло диалог shift - F1
(global-set-key (kbd "M-<f1>")  
  (lambda ()
    (interactive)
    (dired "~")))

(global-set-key (kbd "M-<f2>") 'ibuffer)
(global-set-key (kbd "M-<f3>") 'projectile-ibuffer)
;;(global-set-key (kbd "M-<f4>") 'kill-emacs)

(global-set-key [f2] 'save-buffer)

;;(windmove-default-keybindings) ;; переопределить перемещение по буферу на Shift-<arrow>
;; hide/show
(global-set-key (kbd "C-.") 'hs-toggle-hiding)
(global-set-key (kbd "C-,") 'hs-hide-all)
(global-set-key (kbd "C-x C-,") 'hs-show-all)

(global-set-key (kbd "C-;") 'comment-region)
(global-set-key (kbd "C-:") 'uncomment-region)


;; Move active cursor to window
(global-set-key (kbd "<C-M-right>") 'windmove-right)
(global-set-key (kbd "<C-M-left>") 'windmove-left)
(global-set-key (kbd "<C-M-up>") 'windmove-up)            
(global-set-key (kbd "<C-M-down>") 'windmove-down)       
;;(global-set-key (kbd "<C-tab>") 'other-window)

;; Swap current buffer with buffer in direction of arrow
(global-set-key (kbd "C-x t <right>") 'buf-move-right)
(global-set-key (kbd "C-x t <left>") 'buf-move-left)
(global-set-key (kbd "C-x t <up>") 'buf-move-up)
(global-set-key (kbd "C-x t <down>") 'buf-move-down)
(global-set-key (kbd "C-0") 'toggle-window-split)

;; Resize window
(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)

(global-set-key "\C-c\C-r" 'replace-string) 

(global-set-key (kbd "C-z") 'undo) ;; по умолчанию емакс уходит в бакграунд 
(global-set-key (kbd "M-z") 'redo)


(defun ser/run-profile (profile)
  "Set cider profile."
  (interactive "sEnter profiles: ")
  (let ((cider-lein-parameters (concat "with-profile " profile " repl :headless")))
    (cider-jack-in)))

;; modes
(define-prefix-command 'seryh-menu)
(global-set-key "\M-m" 'seryh-menu)
(define-key seryh-menu "1" 'js2-mode)
(define-key seryh-menu "2" 'web-mode)
(define-key seryh-menu "3" 'conf-mode)
(define-key seryh-menu "4" 'rainbow-delimiters-mode)
(define-key seryh-menu "5" 'org-mode)
(define-key seryh-menu "l" 'toggle-truncate-lines) ;; режим word-wrap


;; projectile-mode-kbd
(defun my-projectile-mode-config ()
  "For use in `projectile-mode-hook'."
  (local-set-key (kbd "M-<f1>")  ;; открывает директорию с проектом в котором находится
                 (lambda ()
                   (interactive)
                   (projectile-dired))))

;; add to hook
(add-hook 'projectile-mode-hook 'my-projectile-mode-config)
