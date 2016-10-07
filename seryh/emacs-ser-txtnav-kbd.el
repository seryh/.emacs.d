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

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))


(bind-keys*
 ("M-i" . previous-line)
 ("M-k" . next-line)
 ("M-j" . backward-char)
 ("M-l" . forward-char)
 ("C-M-i" . move-line-up)
 ("C-M-k" . move-line-down)

 
 ("M-o" . move-forward-paren)
 ("M-u" . move-backward-paren)

 ("M-C-j" . backward-sexp)
 ("M-C-l" . forward-sexp)
 
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
 
 ("M-SPC" . set-mark-command)  
 ("M-=" . mark-defun)
 ("C-=" . er/expand-region)
 )


;; ("<delete>" . delete-forward-char)
