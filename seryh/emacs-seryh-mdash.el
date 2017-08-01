;; http://mdash.ru
;;(require 'request)
(load (ser/get-config-dir "seryh/request/request.el"))
(require 'xml)

(defun decode-entities (html)
  (with-temp-buffer
    (save-excursion (insert html))
    (xml-parse-string)))

(defun ser/pretty-text (start end)
  (interactive "r")
  (let ((o-text (buffer-substring start end)))
    (kill-region start end)
    (request
     "http://mdash.ru/api.v1.php?Text.paragraphs=off"
     :type "POST"
     ;;:data (concat "text=" (decode-entities o-text))
     :data (concat "text=" o-text)
     :parser 'json-read
     :success
     (cl-function
      (lambda (&key data &allow-other-keys)
        (insert (assoc-default 'result data))
        )))))


(defun ser/php-gettext (start end)
  (interactive "r")
  (let ((o-text (buffer-substring start end)))
    (kill-region start end)
    (insert (concat "<?= __(\"" o-text "\") ?>") )
    ))

;; kdb
;;(define-prefix-command 'seryh-menu)
;;(global-set-key "\M-m" 'seryh-menu)
;;(define-key seryh-menu "p" 'ser/pretty-text)



