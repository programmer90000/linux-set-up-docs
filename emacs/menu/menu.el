(defvar header-line-content " ")
(defvar header-initial-space "  ")
(defvar header-button-gap "  ")

;; Create dropdown menu for File button
(defvar header-dropdown-map-file
  (let ((map (make-sparse-keymap "File Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-file)
    map))

;; Create dropdown menu for Edit button
(defvar header-dropdown-map-edit
  (let ((map (make-sparse-keymap "Edit Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-edit)
    map))

;; Create dropdown menu for View button
(defvar header-dropdown-map-view
  (let ((map (make-sparse-keymap "View Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-view)
    map))

;; Create dropdown menu for Navigate button
(defvar header-dropdown-map-navigate
  (let ((map (make-sparse-keymap "Navigate Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-navigate)
    map))

;; Create dropdown menu for Help button
(defvar header-dropdown-map-help
  (let ((map (make-sparse-keymap "Help Dropdown")))
    (define-key map [header-line mouse-1] #'header-dropdown-show-help)
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

(defun kde-save-as ()
  "Open KDE Plasma file picker to save current buffer with a new name."
  (interactive)
  (let ((default-directory (or (when (buffer-file-name)
                                 (file-name-directory (buffer-file-name)))
                               default-directory
                               "~/"))
        (filename nil))
    (condition-case err
        (setq filename (string-trim
                       (shell-command-to-string "kdialog --getsavefilename .")))
      (error
       (message "Error calling KDE file picker: %s" err)
       (setq filename nil)))

    (when (and filename (not (string-empty-p filename)))
      (write-file filename)
      (message "Saved as: %s" filename))))

(defun menu-debug-logger (message)
  "Log MESSAGE to debug buffer and display at bottom."
  (let ((buffer (get-buffer-create "*debug-log*")))
    ;; Insert the message into the buffer
    (with-current-buffer buffer
      ;; Initialize buffer with just a simple separator if empty
      (when (zerop (buffer-size))
        (insert "--- Debug Log Started ---\n\n"))

      (goto-char (point-max))
      (insert (format "%s\n" message)))
    ;; Always display at bottom
    (display-buffer-at-bottom buffer '((window-height . 10)))
    buffer))

(defun menu-debug-log ()
  "Demonstrate the debug log functionality."
  (interactive)
  (menu-debug-logger "Debug system initialized"))

(when (called-interactively-p 'any)
  (menu-debug-log))

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
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame)))
         (recent-files (get-recent-files-list))
         (recent-count (length recent-files)))
    
    (popup-menu
     `([]
       ["New File" (kde-new-file)]
       ["Open File" (kde-open-file-new-tab)]
       ["Open Directory" ()]
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
       ["Save As" kde-save-as]
       ["Save All" (lambda () (interactive) (save-some-buffers t))]
       "---"
       ["Close File" kill-this-buffer]
       "---"
       ["Copy Path" (lambda () (interactive)
                      (kill-new (buffer-file-name))
                      (message "Copied: %s" (buffer-file-name)))]
       ["Show File Info" (lambda () (interactive)
                           (message "File: %s | Size: %d bytes | Mode: %s"
                                    (buffer-file-name)
                                    (buffer-size)
                                    major-mode))])
     position)))


(defun header-dropdown-show-edit (event)
  "Show dropdown menu at bottom-left of Edit button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                       (string-width "File")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width) char-width))
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame)))
         (region-active-p (region-active-p)))
    (popup-menu
     `([]
       ["Undo" undo-fu-only-undo :help "Undo last change" :active (and buffer-undo-list (not (eq buffer-undo-list t)))]
       ["Redo" undo-fu-only-redo :help "Redo last undone change" :active (undo-fu--backport-undo--last-change-was-undo-p buffer-undo-list)]
       "---"
       ["Cut" kill-region :help "Cut selected text" :active ,region-active-p]
       ["Copy" kill-ring-save :help "Copy selected text" :active ,region-active-p]
       ["Paste" yank :help "Paste from clipboard"]
       "---"
       ["Select All" mark-whole-buffer :help "Select all text in buffer"]
       ["Comment Highlighted Code" comment-region]
       ["Uncomment Highlighted Code" uncomment-region]
       "---"
       ["Uppercase Highlighted Code" upcase-region]
       ["Lowercase Highlighted Code" downcase-region]
       ["Capitalize Highlighted Code" capitalize-region]
       ["Delete Trailing Whitespace" delete-trailing-whitespace])
     position)))

(defun header-dropdown-show-view (event)
  "Show dropdown menu at bottom-left of View button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                       (string-width "File")))
         (edit-width (with-selected-window window
                       (string-width "Edit")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width edit-width gap-width) char-width))
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame))))
    (popup-menu
     '([]
       ["Show Whitespace" whitespace-mode]
       "---"
       ["Line Numbers" display-line-numbers-mode])
     position)))

(defun header-dropdown-show-navigate (event)
  "Show dropdown menu at bottom-left of Navigate button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                       (string-width "File")))
         (edit-width (with-selected-window window
                       (string-width "Edit")))
         (view-width (with-selected-window window
                       (string-width "View")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width edit-width gap-width view-width gap-width) char-width))
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame))))
    (popup-menu
     '([]
       ["Go To Line" goto-line]
       ["Go To Beginning Of File" beginning-of-buffer]
       ["Go To End Of File" end-of-buffer])
     position)))

(defun header-dropdown-show-help (event)
  "Show dropdown menu at bottom-left of Help button."
  (interactive "e")
  (let* ((posn (event-start event))
         (window (posn-window posn))
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                       (string-width "File")))
         (edit-width (with-selected-window window
                       (string-width "Edit")))
         (view-width (with-selected-window window
                       (string-width "View")))
         (navigate-width (with-selected-window window
                           (string-width "Navigate")))
         (help-width (with-selected-window window
                       (string-width "Help")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width edit-width gap-width view-width gap-width navigate-width gap-width help-width) char-width))
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame))))
    (popup-menu
     '(["Emacs Manual" info-emacs-manual]
       ["Describe Key" describe-key]
       ["Emacs Tutorial" help-with-tutorial])
     position)))

(defun kde-new-file ()
  "Open KDE Plasma file picker to create a new file and open it in a new tab."
  (interactive)
  (let ((default-directory (or (when (buffer-file-name)
                                 (file-name-directory (buffer-file-name)))
                               default-directory
                               "~/"))
        (filename nil))
    (condition-case err
        (setq filename (string-trim
                       (shell-command-to-string "kdialog --getsavefilename .")))
      (error
       (message "Error calling KDE file picker: %s" err)
       (setq filename nil)))

    (when (and filename (not (string-empty-p filename)))
      (unless (file-exists-p filename)
        (write-region "" nil filename))
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
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                           (string-width "File")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width) char-width))
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame))))
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
         (initial-space (with-selected-window window
                          (string-width header-initial-space)))
         (file-width (with-selected-window window
                           (string-width "File")))
         (first-button-width (with-selected-window window
                               (string-width "Menu")))
         (gap-width (with-selected-window window
                      (string-width header-button-gap)))
         (char-width (frame-char-width))
         (menu-x (* (+ initial-space file-width gap-width first-button-width gap-width) char-width))
         (menu-y (frame-char-height))
         (position (list (list menu-x menu-y) (selected-frame))))
    (popup-menu
     '([]
       ["Option 1" (message "Option 1 selected from second menu")]
       ["Option 2" (message "Option 2 selected from second menu")]
       ["Option 3" (message "Option 3 selected from second menu")])
     position)))

(defvar *global-menu-window* nil
  "Window displaying the global menu bar.")

(defun create-global-menu-window ()
  "Create a single global menu window at the top of the frame."
  (unless (and *global-menu-window* (window-live-p *global-menu-window*))
    ;; Create a special buffer for the menu
    (let ((menu-buffer (get-buffer-create "*Global Menu*")))
      (with-current-buffer menu-buffer
        (let ((inhibit-read-only t))
          (erase-buffer)
          ;; Insert the menu bar content
          (insert (concat
                   header-initial-space
                   (propertize "File"
                               'help-echo "Click for file operations"
                               'keymap header-dropdown-map-file
                               'mouse-face 'highlight)
                   header-button-gap
                   (propertize "Edit"
                               'help-echo "Click for edit operations"
                               'keymap header-dropdown-map-edit
                               'mouse-face 'highlight)
                   header-button-gap
                   (propertize "View"
                               'help-echo "Click for view options"
                               'keymap header-dropdown-map-view
                               'mouse-face 'highlight)
                   header-button-gap
                   (propertize "Navigate"
                               'help-echo "Click for navigation options"
                               'keymap header-dropdown-map-navigate
                               'mouse-face 'highlight)
                   header-button-gap
                   (propertize "Help"
                               'help-echo "Click for help"
                               'keymap header-dropdown-map-help
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
                   'mouse-face 'highlight))))
        ;; Configure the buffer
        (setq-local cursor-type nil)
        (setq-local mode-line-format nil)
        (setq-local header-line-format nil)
        (setq-local truncate-lines t)
        (setq-local window-size-fixed 'height)
        (read-only-mode 1))

      (setq *global-menu-window*
            (display-buffer-in-side-window
             menu-buffer
             '((side . top)
               (slot . 0)
               (window-height . 1)
               (preserve-size . (nil . t)))))
      (set-window-dedicated-p *global-menu-window* t))))

(defun remove-all-header-lines ()
  "Remove header lines from all buffers."
  (setq-default header-line-format nil)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (setq-local header-line-format nil))))

(remove-all-header-lines)
(create-global-menu-window)

;; Ensure new buffers don't get header lines
(add-hook 'find-file-hook
          (lambda () (setq-local header-line-format nil)))
(add-hook 'after-change-major-mode-hook
          (lambda () (setq-local header-line-format nil)))

(message "Single global menu bar created. No per-buffer menus.")

;; Remove the old custom-header-line-mode and its hooks since we're using frame-level approach
;; The original custom-header-line-mode definition and hooks are no longer needed

(message "Custom frame-level menu bar enabled")