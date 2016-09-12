(defun move-forward-paren (&optional arg)
  "Move forward parenthesis"
  (interactive "P")
  (if (looking-at ")") (forward-char 1))
  (while (not (looking-at ")")) (forward-char 1))
  ) 

(defun move-backward-paren (&optional arg)
  "Move backward parenthesis"
  (interactive "P")
  (if (looking-at "(") (forward-char -1))
  (while (not (looking-at "(")) (backward-char 1))
  ) 

(defun move-forward-sqrParen (&optional arg)
  "Move forward square brackets"
  (interactive "P")
  (if (looking-at "]") (forward-char 1))
  (while (not (looking-at "]")) (forward-char 1))
  ) 

(defun move-backward-sqrParen (&optional arg)
  "Move backward square brackets"
  (interactive "P")
  (if (looking-at "[[]") (forward-char -1))
  (while (not (looking-at "[[]")) (backward-char 1))
  ) 

(defun move-forward-curlyParen (&optional arg)
  "Move forward curly brackets"
  (interactive "P")
  (if (looking-at "}") (forward-char 1))
  (while (not (looking-at "}")) (forward-char 1))
  ) 

(defun move-backward-curlyParen (&optional arg)
  "Move backward curly brackets"
  (interactive "P")
  (if (looking-at "{") (forward-char -1))
  (while (not (looking-at "{")) (backward-char 1))
  ) 

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

 ("M-J" . backward-sexp)
 ("M-L" . forward-sexp)
 
 ("M-(" . move-backward-paren)
 ("M-)" . move-forward-paren)
 ("M-[" . move-backward-sqrParen)
 ("M-]" . move-forward-sqrParen)
 ("M-{" . move-backward-curlyParen)
 ("M-}" . move-forward-curlyParen)
 
 ("M-f" . delete-forward-char)  ;; Delete
 ("M-d" . delete-backward-char) ;; Backspace
 ("M-F" . kill-word)  ;; Delete
 ("M-D" . backward-kill-word) ;; Backspace

 ("M-n" . reindent-then-newline-and-indent) ;; Enter
 ("M-SPC" . set-mark-command)   ;; Выделение
 )
