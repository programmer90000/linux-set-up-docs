(defvar header-line-content " ")

(defun initialize-header-line ()
  (setq header-line-format '(:eval header-line-content)))

;; Create dropdown menu for first button
(defvar header-dropdown-map
  (let ((map (make-sparse-keymap "Header Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show)
    map))

(defun header-dropdown-show (event)
  "Show dropdown menu at bottom-left of button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         (menu-x 0)
         (menu-y (window-header-line-height window))
         (position (list (list menu-x menu-y) window)))
    (popup-menu
     '([]
       ["Option 1" (message "Option 1 selected from first menu")]
       ["Option 2" (message "Option 2 selected from first menu")] 
       ["Option 3" (message "Option 3 selected from first menu")])
     position)))

;; Create dropdown menu for second button
(defvar header-dropdown-map-2
  (let ((map (make-sparse-keymap "Header Dropdown 2")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-2)
    map))

(defun header-dropdown-show-2 (event)
  "Show dropdown menu at bottom-left of second button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         ;; Calculate pixel width of first button text
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (first-button-width (with-selected-window window
                               (string-width "Menu")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         ;; Convert character width to pixels (approximate)
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space first-button-width gap-width) char-width))
         (menu-y (window-header-line-height window))
         (position (list (list menu-x menu-y) window)))
    (popup-menu
     '([]
       ["Option 1" (message "Option 1 selected from second menu")]
       ["Option 2" (message "Option 2 selected from second menu")]
       ["Option 3" (message "Option 3 selected from second menu")])
     position)))

;; Set header content with both dropdown triggers
(defvar header-initial-space "  ")
(defvar header-button-gap "  ")

(setq header-line-content
      (concat
       header-initial-space
       (propertize "Menu"
                   'help-echo "Click for menu"
                   'keymap header-dropdown-map)
       header-button-gap
       (propertize "Menu 2"
                   'help-echo "Click for menu 2"
                   'keymap header-dropdown-map-2)))

(add-hook 'emacs-startup-hook #'initialize-header-line)