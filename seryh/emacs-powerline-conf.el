(use-package powerline)

(defun my-mode-line-coding-format ()
  (let* ((code (symbol-name buffer-file-coding-system))
         (encoding (cond ((string-match "1251\\|win" code)
                          "1251")
                         ((string-match "utf-8" code)
                          "UTF8")
                         (code)))
         (eol-type (coding-system-eol-type buffer-file-coding-system))
         (eol (if (eq 0 eol-type) "UNIX"
                (if (eq 1 eol-type) "DOS"
                  (if (eq 2 eol-type) "MAC"
                    "???")))))
    (concat encoding "|" eol)))

(setq-default mode-line-format
              '("%e"
                (:eval
                 (let* ((active (eq (frame-selected-window) (selected-window)))
                        (face1 (if active 'powerline-active1 'powerline-inactive1))
                        (face2 (if active 'powerline-active2 'powerline-inactive2))
                        (lhs (list
                              (powerline-raw "%*" nil 'l)
                              ;; (powerline-buffer-size nil 'l)
                              (powerline-buffer-id nil 'l)

                              (powerline-raw " ")
                              (powerline-arrow-right nil face1)
                              (powerline-raw (my-mode-line-coding-format) face1 'l)
                              (powerline-raw " " face1)
                              (powerline-arrow-left face1 nil)
                              
                              (powerline-raw "%4l" nil 'r)
                              (powerline-raw ":" nil)
                              (powerline-raw "%3c" nil 'r)

                              (powerline-raw " ")
                              (powerline-arrow-right nil face1)

                              (powerline-raw mode-line-process face1 'l)

                              (powerline-narrow face1 'l)

                              (powerline-vc face1)
                              ))
                        (rhs (list
                              (powerline-raw global-mode-string face2 'r)
                              
                              (powerline-arrow-left face1 nil)
                              (powerline-raw " ")
                              (powerline-raw "%6p" nil 'r)
                              (powerline-hud face2 face1)))
                        (center (list
                                 (powerline-raw " " face1)
                                 (powerline-arrow-right face1 face2)
                                 (powerline-major-mode face2 'l)
                                 (powerline-raw " :" face2)
                                 (powerline-minor-modes face2 'l)
                                 (powerline-raw " " face2)
                                 (powerline-arrow-left face2 face1))))

                   (concat
                   (powerline-render lhs)
                    (powerline-fill-center face1 (/ (powerline-width center) 2.0))
                    (powerline-render center)
                    (powerline-fill face1 (powerline-width rhs))
                    (powerline-render rhs))))))

(provide 'emacs-powerline-conf)
