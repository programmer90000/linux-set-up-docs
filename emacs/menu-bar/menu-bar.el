(defvar header-line-content " ")
(defvar header-initial-space "  ")
(defvar header-button-gap "  ")

;; Create dropdown menu for File button
(defvar header-dropdown-map-file
  (let ((map (make-sparse-keymap "File Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-file)
    map))

(defun get-recent-files-list ()
  "Get list of recent files."
  (cond
   ((fboundp 'recentf-list) (recentf-list))
   ((fboundp 'recentf-get-list) (recentf-get-list))
   ((boundp 'recentf-list) recentf-list)
   (t nil)))

(defun ensure-recentf-mode ()
  "Safely enable recentf-mode if available."
  (when (fboundp 'recentf-mode)
    (unless recentf-mode
      (recentf-mode 1))))

(defun header-dropdown-show-file (event)
  "Show dropdown menu at bottom-left of File button."
  (interactive "e")
  (ensure-recentf-mode)
  (let* ((posn (event-start event))
         (window (posn-window posn))
         ;; Calculate pixel width of initial space
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         ;; Convert character width to pixels
         (char-width (frame-char-width))
         (menu-x (* initial-space char-width))
         (menu-y (window-header-line-height window))
         (position (list (list menu-x menu-y) window))
         (recent-files (get-recent-files-list))
         (recent-count (length recent-files)))
    
    (popup-menu
     `([]
       ["New File" (kde-new-file)]
       ["Open File" (kde-open-file-new-tab)]
       ,(if (and recent-files (> recent-count 0))
            `("Recent Files"
              ,@(mapcar (lambda (file)
                          (let ((display-name (abbreviate-file-name file)))
                            `[,display-name
                              (progn (tab-bar-new-tab) (find-file ,file))
                              :help ,file]))
                        (seq-take recent-files 10)))
          ["Recent Files (none)" nil :active nil])
       "---"
       ["Save" save-buffer]
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
    (condition-case err
        (setq filename (string-trim
                       (shell-command-to-string "kdialog --getsavefilename .")))
      (error
       (message "Error calling KDE file picker: %s" err)
       (setq filename nil)))

    ;; Check if user canceled the dialog (empty string or nil)
    (when (and filename (not (string-empty-p filename)))
      ;; Create the file if it doesn't exist
      (unless (file-exists-p filename)
        (write-region "" nil filename))
      ;; Open the file in a new tab
      (tab-bar-new-tab)
      (find-file filename)
      (message "Created and opened in new tab: %s" filename))))

(defun kde-open-file-new-tab ()
  "Open KDE Plasma file picker to select and open a file in new tab."
  (interactive)
  (let ((default-directory (or (when (buffer-file-name)
                                 (file-name-directory (buffer-file-name)))
                               default-directory
                               "~/"))
        (filename nil))
    (condition-case err
        (setq filename (string-trim
                       (shell-command-to-string "kdialog --getopenfilename .")))
      (error
       (message "Error calling KDE file picker: %s" err)
       (setq filename nil)))

    (when (and filename (not (string-empty-p filename)))
      ;; Open in new tab
      (tab-bar-new-tab)
      (find-file filename)
      (message "Opened in new tab: %s" filename))))

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
         ;; Calculate pixel position after all previous buttons
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

(define-minor-mode custom-header-line-mode
  "Toggle custom header line mode."
  :global t
  :init-value nil
  :lighter ""
  :keymap nil
  (if custom-header-line-mode
      (progn
        (setq-default header-line-format '(:eval header-line-content))
        (dolist (buffer (buffer-list))
          (with-current-buffer buffer
            (setq header-line-format '(:eval header-line-content))))
        (message "Custom header line mode enabled"))
    (setq-default header-line-format nil)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (setq header-line-format nil)))
    (message "Custom header line mode disabled")))

;; Enable the custom header line mode
(custom-header-line-mode 1)

;; Additional hook to ensure header line is set for new buffers
(add-hook 'after-change-major-mode-hook
          (lambda ()
            (when custom-header-line-mode
              (setq header-line-format '(:eval header-line-content)))))

;; Hook for new buffers created via find-file
(add-hook 'find-file-hook
          (lambda ()
            (when custom-header-line-mode
              (setq header-line-format '(:eval header-line-content)))))

;; Hook for tab-bar new tab creation
(add-hook 'tab-bar-tab-post-open-functions
          (lambda (tab)
            (when custom-header-line-mode
              (setq header-line-format '(:eval header-line-content)))))