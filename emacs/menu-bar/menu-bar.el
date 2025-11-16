(defun header-menu ()
  "Show a dropdown menu when header is clicked."
  (interactive)
  (let ((menu (easy-menu-create-menu
               nil
               '(["Option 1" (message "You chose Option 1")]
                 ["Option 2" (message "You chose Option 2")]
                 "---"
                 ["Reload Config" (load-file "~/.emacs.d/init.el")]
                 ["Exit Emacs" save-buffers-kill-emacs]))))
    (x-popup-menu (list (list 0 0) (selected-window)) menu)))

(defun header2-menu ()
  "Show a dropdown menu when header 2 is clicked."
  (interactive)
  (let ((menu (easy-menu-create-menu
               nil
               '(["Option 1" (message "Header 2 - Option 1")]
                 ["Option 2" (message "Header 2 - Option 2")]
                 "---"
                 ["Reload Config" (load-file "~/.emacs.d/init.el")]
                 ["Exit Emacs" save-buffers-kill-emacs]))))
    (x-popup-menu (list (list (* 9 (frame-char-width)) 0)
                       (selected-window))
                 menu)))

(setq header-line-format
    (list
        (propertize "HEADER 1"
            'face '(:background "red" :foreground "white" :bold t :height 1.0)
            'local-map (let ((map (make-sparse-keymap)))
                         (define-key map [header-line mouse-1] 'header-menu)
                         (define-key map [header-line down-mouse-1] 'header-menu)
                         map)
            'help-echo "Click for menu 1")
        (propertize " "
            'face '(:background "red"))
        (propertize "HEADER 2"
            'face '(:background "red" :foreground "white" :bold t :height 1.0)
            'local-map (let ((map (make-sparse-keymap)))
                         (define-key map [header-line mouse-1] 'header2-menu)
                         (define-key map [header-line down-mouse-1] 'header2-menu)
                         map)
            'help-echo "Click for menu 2")
        (propertize (make-string 1000 ? )
            'face '(:background "red"))))

(setq-default header-line-format header-line-format)

(provide 'header)