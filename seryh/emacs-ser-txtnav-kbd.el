(bind-keys*
 ("M-i" . previous-line)
 ("M-k" . next-line)
 ("M-j" . backward-char)
 ("M-l" . forward-char)
 ("M-I" . scroll-down-command)
 ("M-K" . scroll-up-command)
 ("M-o" . forward-word)
 ("M-u" . backward-word)
 ("M-h" . move-end-of-line)
 ("M-H" . move-beginning-of-line)
 ("M-L" . end-of-buffer)
 ("M-J" . beginning-of-buffer)
 
 ("M-f" . delete-forward-char)  ;; Delete
 ("M-d" . delete-backward-char) ;; Backspace
 ("M-n" . reindent-then-newline-and-indent) ;; Enter
 ("M-SPC" . set-mark-command)   ;; Выделение
 )
