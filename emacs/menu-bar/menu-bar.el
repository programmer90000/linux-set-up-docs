(setq header-line-format
    (list
        (propertize (concat "HEADER" (make-string 1000 ? ))
            'face '(:background "red" :foreground "white" :bold t :height 1.0))))

(setq-default header-line-format header-line-format)

(provide 'header)