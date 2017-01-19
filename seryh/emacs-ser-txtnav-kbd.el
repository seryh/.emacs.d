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

 ("M-(" . move-backward-paren)
 ("M-)" . move-forward-paren)
 ("M-[" . move-backward-sqrParen)
 ("M-]" . move-forward-sqrParen)
 ("M-{" . move-backward-curlyParen)
 ("M-}" . move-forward-curlyParen)

 ("M-f" . delete-forward-char)  ;; Delete
 ("M-d" . delete-backward-char) ;; Backspace
 ("M-F" . kill-word)            ;; Delete
 ("M-D" . backward-kill-word)   ;; Backspace

 ("M-n" . reindent-then-newline-and-indent) ;; Enter
 
 ("M-SPC" . set-mark-command)  
 ("M-=" . mark-defun)
 ("C-=" . er/expand-region)
 )


;; ("<delete>" . delete-forward-char)


;; ---------------------------------------------------------- [ hydra ]
(defun hydra-vi/pre ()
  (set-cursor-color "turquoise1"))
(defun hydra-vi/post ()
  (set-cursor-color "magenta"))


(defhydra hydra-vi (:pre hydra-vi/pre :post hydra-vi/post :color amaranth)
  "vi"
  ("SPC" hydra-vi-moves/body "moves" :color blue)
  ("l" forward-char)
  ("h" backward-char)
  ("j" next-line)
  ("k" previous-line)
  ("m" set-mark-command "mark")
  ("a" move-beginning-of-line "beg")
  ("e" move-end-of-line "end")
  ("d" delete-region "del" :color blue)
  ("y" kill-ring-save "yank" :color blue)
  ("q" nil "quit"))


(defhydra hydra-vi-moves (:pre hydra-vi/pre :post hydra-vi/post :color amaranth)
  "vi moves"
  ("j" move-line-down "line-down")
  ("k" move-line-up "line-up")
  ("q" nil "quit"))


(define-key global-map (kbd "M-i") 'hydra-vi/body)
