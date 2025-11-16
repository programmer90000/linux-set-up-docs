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
    (popup-menu menu)))

(setq header-line-format
    (list
        (propertize (concat "HEADER" (make-string 1000 ? ))
            'face '(:background "red" :foreground "white" :bold t :height 1.0)
            'local-map (let ((map (make-sparse-keymap)))
                         (define-key map [header-line mouse-1] 'header-menu)
                         (define-key map [header-line down-mouse-1] 'header-menu)
                         map)
            'help-echo "Click for menu")))

(setq-default header-line-format header-line-format)

(provide 'header)