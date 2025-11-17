(defvar header-line-content " ")

(defun initialize-header-line ()
  (setq header-line-format '(:eval header-line-content)))

;; Create dropdown menu for File button
(defvar header-dropdown-map-file
  (let ((map (make-sparse-keymap "File Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-file)
    map))

(defun header-dropdown-show-file (event)
  "Show dropdown menu at bottom-left of File button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         ;; Calculate pixel width of initial space
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         ;; Convert character width to pixels
         (char-width (frame-char-width))
         (menu-x (* initial-space char-width))
         (menu-y (window-header-line-height window))
         (position (list (list menu-x menu-y) window)))
    (popup-menu
     '([]
       ["New File" (kde-new-file)])
     position)))

(defun kde-new-file ()
  "Open KDE Plasma file picker to create a new file and open it in a new tab."
  (interactive)
  (let ((default-directory (or (when (buffer-file-name)
                                 (file-name-directory (buffer-file-name)))
                               default-directory
                               "~/"))
        (filename nil))
    ;; Get filename from KDE file picker
    (setq filename (shell-command-to-string "kdialog --getsavefilename ."))
    ;; Remove trailing newline from the output
    (setq filename (string-trim filename))

    ;; Check if user canceled the dialog (empty string)
    (when (and filename (not (string-empty-p filename)))
      ;; Create the file if it doesn't exist
      (unless (file-exists-p filename)
        (write-region "" nil filename))
      ;; Open the file in a new tab
      (tab-bar-new-tab)
      (find-file filename)
      (message "Created and opened in new tab: %s" filename))))

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
         ;; Calculate pixel position after File button
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                           (string-width "File")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         ;; Convert character width to pixels
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width) char-width))
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
         ;; Calculate pixel position after both previous buttons
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                           (string-width "File")))
         (first-button-width (with-selected-window window
                               (string-width "Menu")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         ;; Convert character width to pixels
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width first-button-width gap-width) char-width))
         (menu-y (window-header-line-height window))
         (position (list (list menu-x menu-y) window)))
    (popup-menu
     '([]
       ["Option 1" (message "Option 1 selected from second menu")]
       ["Option 2" (message "Option 2 selected from second menu")]
       ["Option 3" (message "Option 3 selected from second menu")])
     position)))

;; Set header content with all dropdown triggers
(defvar header-initial-space "  ")
(defvar header-button-gap "  ")

(setq header-line-content
      (concat
       header-initial-space
       (propertize "File"
                   'help-echo "Click for file operations"
                   'keymap header-dropdown-map-file
                   'mouse-face 'highlight)
       header-button-gap
       (propertize "Menu"
                   'help-echo "Click for menu"
                   'keymap header-dropdown-map
                   'mouse-face 'highlight)
       header-button-gap
       (propertize "Menu 2"
                   'help-echo "Click for menu 2"
                   'keymap header-dropdown-map-2
                   'mouse-face 'highlight)))

(add-hook 'emacs-startup-hook #'initialize-header-line)