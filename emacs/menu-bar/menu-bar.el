(defun file-menu ()
  "Show file operations dropdown menu"
  (interactive)
  (let ((menu (easy-menu-create-menu
               nil
               '(["Option 1" (message "You chose Option 1")]
                 ["Option 2" (message "You chose Option 2")]
                 "---"
                 ["Reload Config" (load-file "~/.emacs.d/init.el")]
                 ["Exit Emacs" save-buffers-kill-emacs]))))
    (x-popup-menu (list (list 0 (frame-char-height))
                       (selected-window))
                 menu)))

(defun edit-menu ()
  "Show edit operations dropdown menu"
  (interactive)
  (let ((menu (easy-menu-create-menu
               nil
               '(["Option 1" (message "Header 2 - Option 1")]
                 ["Option 2" (message "Header 2 - Option 2")]
                 "---"
                 ["Reload Config" (load-file "~/.emacs.d/init.el")]
                 ["Exit Emacs" save-buffers-kill-emacs]))))
    (x-popup-menu (list (list (* 7 (frame-char-width))
                            (frame-char-height))
                       (selected-window))
                 menu)))

(setq header-line-format
    (list
        (propertize "File"
            'face '(:background "red" :foreground "white" :bold t :height 1.0)
            'local-map (let ((map (make-sparse-keymap)))
                         (define-key map [header-line mouse-1] 'file-menu)
                         (define-key map [header-line down-mouse-1] 'file-menu)
                         map)
            'help-echo "Click for file menu")
        (propertize "   "
            'face '(:background "red"))
        (propertize "Edit"
            'face '(:background "red" :foreground "white" :bold t :height 1.0)
            'local-map (let ((map (make-sparse-keymap)))
                         (define-key map [header-line mouse-1] 'edit-menu)
                         (define-key map [header-line down-mouse-1] 'edit-menu)
                         map)
            'help-echo "Click for edit menu")
        (propertize (make-string 1000 ? )
            'face '(:background "red"))))

(setq-default header-line-format header-line-format)

(provide 'header)