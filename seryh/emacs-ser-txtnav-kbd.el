;; Крестовина
;;

;; Вверх
(global-unset-key (kbd "M-i"))
(global-set-key (kbd "M-i") 'previous-line)

;; Вниз
(global-unset-key (kbd "M-k"))
(global-set-key (kbd "M-k") 'next-line)

;; Влево
(global-unset-key (kbd "M-j"))
(global-set-key (kbd "M-j") 'backward-char)

;; Вправо
(global-unset-key (kbd "M-l"))
(global-set-key (kbd "M-l") 'forward-char)

;; Page Up
(global-unset-key (kbd "M-I"))
(global-set-key (kbd "M-I") 'scroll-down-command)

;; Page Down
(global-unset-key (kbd "M-K"))
(global-set-key (kbd "M-K") 'scroll-up-command)

;; Forward word
(global-unset-key (kbd "M-o"))
(global-set-key (kbd "M-o") 'forward-word)

;; Backward word
(global-unset-key (kbd "M-u"))
(global-set-key (kbd "M-u") 'backward-word)

;; Beginnning of line
(global-unset-key (kbd "M-h"))
(global-set-key (kbd "M-h") 'move-end-of-line)

;; End of line
(global-unset-key (kbd "M-H"))
(global-set-key (kbd "M-H") 'move-beginning-of-line)

;; End of buffer
(global-unset-key (kbd "M-L"))
(global-set-key (kbd "M-L") 'end-of-buffer)

;; Beginning of buffer
(global-unset-key (kbd "M-J"))
(global-set-key (kbd "M-J") 'beginning-of-buffer)


;; Редактирование
;;

;; Delete
(global-unset-key (kbd "M-f"))
(global-set-key (kbd "M-f") 'delete-forward-char)

;; Backspace
(global-unset-key (kbd "M-d"))
(global-set-key (kbd "M-d") 'delete-backward-char)

;; Enter
(global-unset-key (kbd "M-n"))
(global-set-key (kbd "M-n") 'reindent-then-newline-and-indent)
(global-unset-key (kbd "M-m"))
(global-set-key (kbd "M-m") 'reindent-then-newline-and-indent)

;; Выделение
(global-unset-key (kbd "M-SPC"))
(global-set-key (kbd "M-SPC") 'set-mark-command)
