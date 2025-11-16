(setq header-line-format
    '(:eval (propertize "HEADER"
        'face '(:background "red" :foreground "white" :bold t
            :height 0.8))))

;; Force header line to be visible in all buffers
(setq-default header-line-format header-line-format)

(provide 'header)