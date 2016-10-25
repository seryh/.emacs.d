;; http://mdash.ru

(require 'request)

(defun ser/pretty-text (start end)
  (interactive "r")
  (let ((o-text (buffer-substring start end)))
    (kill-region start end)
    (request
     "http://mdash.ru/api.v1.php?Text.paragraphs=off"
     :type "POST"
     :data (concat "text=" o-text)
     :parser 'json-read
     :success (function*
               (lambda (&key data &allow-other-keys)
                 (insert (assoc-default 'result data)))))))

