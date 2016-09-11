;; Крестовина
;;
;; unsets
(global-unset-key (kbd "M-SPC"))
(global-unset-key (kbd "M-m"))
(global-unset-key (kbd "M-n"))
(global-unset-key (kbd "M-d"))
(global-unset-key (kbd "M-f"))
(global-unset-key (kbd "M-J"))
(global-unset-key (kbd "M-L"))
(global-unset-key (kbd "M-H"))
(global-unset-key (kbd "M-h"))
(global-unset-key (kbd "M-u"))
(global-unset-key (kbd "M-o"))
(global-unset-key (kbd "M-K"))
(global-unset-key (kbd "M-I"))
(global-unset-key (kbd "M-l"))
(global-unset-key (kbd "M-j"))
(global-unset-key (kbd "M-k"))
(global-unset-key (kbd "M-i"))

;; Вверх
(global-set-key (kbd "M-i") 'previous-line)
;; Вниз
(global-set-key (kbd "M-k") 'next-line)
;; Влево
(global-set-key (kbd "M-j") 'backward-char)
;; Вправо
(global-set-key (kbd "M-l") 'forward-char)
;; Page Up
(global-set-key (kbd "M-I") 'scroll-down-command)
;; Page Down
(global-set-key (kbd "M-K") 'scroll-up-command)
;; Forward word
(global-set-key (kbd "M-o") 'forward-word)
;; Backward word
(global-set-key (kbd "M-u") 'backward-word)
;; Beginnning of line
(global-set-key (kbd "M-h") 'move-end-of-line)
;; End of line
(global-set-key (kbd "M-H") 'move-beginning-of-line)
;; End of buffer
(global-set-key (kbd "M-L") 'end-of-buffer)
;; Beginning of buffer
(global-set-key (kbd "M-J") 'beginning-of-buffer)

;; Редактирование
;;
;; Delete
(global-set-key (kbd "M-f") 'delete-forward-char)
;; Backspace
(global-set-key (kbd "M-d") 'delete-backward-char)
;; Enter
(global-set-key (kbd "M-n") 'reindent-then-newline-and-indent)
(global-set-key (kbd "M-m") 'reindent-then-newline-and-indent)
;; Выделение
(global-set-key (kbd "M-SPC") 'set-mark-command)
