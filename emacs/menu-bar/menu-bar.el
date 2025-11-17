(defvar header-line-content " ")

(defun initialize-header-line ()
  (setq header-line-format '(:eval header-line-content)))

;; Create dropdown menu
(defvar header-dropdown-map
  (let ((map (make-sparse-keymap "Header Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show)
    map))

(defun header-dropdown-show (event)
  "Show dropdown menu at mouse position."
  (interactive "e")
  (popup-menu
   '(["Switch to Scratch" (switch-to-buffer "*scratch*")]
     ["Open File" (call-interactively 'find-file)]
     ["Show Buffer List" (list-buffers)]
     ["Open Config" (find-file user-init-file)]
     ["Reload Init" (load-file user-init-file)])
   (if (listp event) (car (last event)) event)))

;; Set header content with dropdown trigger
(setq header-line-content
      (propertize " Menu "
                  'face '(:background "blue" :foreground "white")
                  'mouse-face '(:background "dark blue")
                  'help-echo "Click for menu"
                  'keymap header-dropdown-map))

(add-hook 'emacs-startup-hook #'initialize-header-line)