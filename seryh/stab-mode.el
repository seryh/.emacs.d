;; ------------------------------------------------------------ [tab fix]
(defun ser/indent-region(numSpaces)
  (progn 
                                        ; default to start and end of current line
    (setq regionStart (line-beginning-position))
    (setq regionEnd (line-end-position))

                                        ; if there's a selection, use that instead of the current line
    (when (use-region-p)
      (setq regionStart (region-beginning))
      (setq regionEnd (region-end))
      )

    (save-excursion ; restore the position afterwards            
      (goto-char regionStart) ; go to the start of region
      (setq start (line-beginning-position)) ; save the start of the line
      (goto-char regionEnd) ; go to the end of region
      (setq end (line-end-position)) ; save the end of the line

      (indent-rigidly start end numSpaces) ; indent between start and end
      (setq deactivate-mark nil) ; restore the selected region
      )
    )
  )

(defun untab-region (N)
  (interactive "p")
  (ser/indent-region -4)
  )

(defun tab-region (N)
  (interactive "p")
  (if (use-region-p)
      (ser/indent-region 4) ; region was selected, call indent-region
    (insert "    ") ; else insert four spaces as expected
    )
  )

;;;###autoload
(define-minor-mode stab-mode
  "stab-mode"
  :lighter " STab"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<backtab>") 'untab-region)
            (define-key map (kbd "<tab>") 'tab-region)
            (define-key map (kbd "<C-tab>") 'indent-region)
            (define-key map (kbd "C-j") 'yas-expand)
            map))

(add-hook 'clojure-mode-hook 'stab-mode)
(add-hook 'js2-mode-hook 'stab-mode)
(add-hook 'web-mode-hook 'stab-mode)
(add-hook 'scss-mode-hook 'stab-mode)
(add-hook 'emacs-lisp-mode-hook 'stab-mode)

(provide 'stab-mode)
