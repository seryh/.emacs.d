(require 'projectile)
(setq max-lisp-eval-depth 10000) ;; для индексации жирных проектов
(setq projectile-indexing-method 'native) ; force the use of native indexing in operating systems other than Windows)
(setq projectile-enable-caching t)
(setq projectile-require-project-root nil)
(setq projectile-completion-system 'ido)
(setq projectile-find-dir-includes-top-level nil)

(setq projectile-globally-ignored-directories
      (append '(
       ".cache" 
       "var"
       "build"
       "vendor"
       "kendoui"
       "angularLibs"
       "images"
       ".git" 
       ".idea"
       "node_modules" 
       "bower_components"
       "css"
        ) projectile-globally-ignored-directories))

(setq projectile-globally-ignored-files
      (append '(
                ".min.js"
                ".png"
                ".jpg"
                ".php"
        ) projectile-globally-ignored-files))

(projectile-global-mode)
