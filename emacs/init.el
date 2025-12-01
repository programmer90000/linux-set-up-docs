(setq inhibit-startup-screen t) ;Disable startup screen
(global-display-line-numbers-mode 1) ;Enable line numbers
(setq scroll-step 1) ; Scroll one line at a time with keyboard
(setq scroll-margin 3) ; Keep 3 lines margin when scrolling
(setq scroll-conservatively 101) ; Smooth scrolling behavior
(setq mouse-wheel-scroll-amount '(3 ((shift) . 5))) ; Mouse wheel scroll amount is set to 3 normally and 5 when holding shift
(setq mouse-wheel-progressive-speed t) ; Scrolling speed based upon mouse scrolling speed
(setq mouse-wheel-follow-mouse 't) ; Scroll window under mouse instead of selected window
(setq next-line-add-newlines nil) ; Don't create new lines when moving down at EOF
(setq line-move-visual t) ; Move by logical lines, not visual
(delete-selection-mode 1) ; Typing whilst text selected deletes selected text instead of typing after it
(global-auto-revert-mode 1) ; Auto-reload files on external change
(electric-pair-mode 1) ; Auto-close brackets and quotes
(show-paren-mode 1) ; Highlight matching parentheses
(setq show-paren-delay 0) ; Instant parenthesis highlighting
(setq show-paren-style 'parenthesis) ; Highlight entire expression
(blink-cursor-mode 1) ; Enable cursor blinking
(setq backward-delete-char-untabify-method nil) ; Delete all whitespace with backspace
(setq require-final-newline t) ; Ensure files end with newline
(setq delete-by-moving-to-trash t) ; Move deleted files to trash instead of permenant deletion
(setq case-fold-search t) ; Case-insensitive search by default
(setq isearch-lazy-count t) ; Show match count in search
(setq lazy-count-prefix-format "(%s/%s) ") ; Format for match counter
(setq isearch-allow-scroll 'unlimited) ; Allow scrolling during search
(global-set-key (kbd "C-M-s") 'isearch-forward-regexp) ; Regex search
(global-set-key (kbd "C-M-r") 'isearch-backward-regexp) ; Backward regex search
(save-place-mode 1) ; Remember cursor position in files
(setq-default indent-tabs-mode nil) ; Use spaces, not tabs
(setq-default tab-width 4) ; Tab width = 4 spaces
(setq c-basic-offset 4) ; C-style language indent
(setq python-indent-offset 4) ; Python indent
(setq js-indent-level 4) ; JavaScript indent
(setq css-indent-offset 4) ; CSS indent
(setq standard-indent 4) ; Default indent
(setq c-tab-always-indent t) ; Always indent in C modes
(electric-indent-mode 1) ; Auto-indent new lines
(recentf-mode 1) ; Keep track of recent files
(setq recentf-max-menu-items 15) ; Number of recent files to remember
(setq recentf-max-saved-items 30) ; Max recent files to save
(tool-bar-mode 1) ; Enable toolbar
(menu-bar-mode 1) ; Enable menu bar
(scroll-bar-mode 1) ; Enable scroll bars
(setq frame-title-format "%b - Emacs") ; Window title format
(setq icon-title-format frame-title-format) ; Icon title format
(setq use-dialog-box nil) ; Don't use dialog boxes for prompts
(setq redisplay-dont-pause t) ; Smoother redisplay
(column-number-mode 1) ; Show column number in mode line
(size-indication-mode 1) ; Show file size in mode line
(setq kill-whole-line nil) ; C-k kills line only not including newline
(global-font-lock-mode 1) ; Enable syntax highlighting
(setq font-lock-maximum-decoration t) ; Maximum syntax highlighting
(add-hook 'prog-mode-hook 'imenu-add-menubar-index) ; Add imenu to menu bar
(setq search-upper-case 'not-yanks) ; Case-sensitive only if search contains uppercase
(setq compilation-scroll-output nil) ; Don't scroll to error
(setq compilation-always-kill nil) ; Don't kill old compilation before new
(setq compilation-ask-about-save t) ; Save all before compile
(setq undo-limit 800000) ; Undo limit
(setq undo-strong-limit 12000000) ; Strong undo limit
(setq undo-outer-limit 120000000) ; Outer undo limit
(setq comment-auto-fill-only-comments t) ; Wrap comments
(add-hook 'prog-mode-hook 'display-line-numbers-mode) ; Line numbers for code
(setq gdb-many-windows t) ; Use many windows in GDB
(setq gdb-show-main t) ; Show main function in GDB
(setq mode-line-format '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification " " mode-line-position " " mode-line-modes mode-line-misc-info mode-line-end-spaces))
(set-fringe-mode 10) ; Set fringe width
(line-number-mode 1) ; Show line numbers in mode line
(column-number-mode 1) ; Show column numbers in mode line
(size-indication-mode 1) ; Show file size in mode line
(display-time-mode 1) ; Show time in mode line
(setq display-time-format "%H:%M") ; Time format
(setq display-time-day-and-date t) ; Show day and date
(global-hl-line-mode 1) ; Highlight current line
(blink-cursor-mode 1) ; Enable cursor blinking
(setq visible-cursor t) ; Show cursor in inactive windows
(setq x-stretch-cursor t) ; Stretch cursor to character width
(setq line-spacing 0.0) ; Set line spacing to default
(setq word-wrap t) ; Enable word wrap
(set-face-attribute 'default nil :height 100) ; Set default font size
(set-frame-font "Fira Code-10" nil t) ; Set font to Fira Code size 10
(set-face-attribute 'region nil :background "#264f78") ; Selection color
(set-face-attribute 'fringe nil :background "#1e1e1e") ; Fringe color
(setq redisplay-skip-fontification-on-input nil) ; Apply fontification during input
(setq jit-lock-defer-time 0.1) ; Wait 0.1 seconds after typing. If nothing is typed, apply fontification
(setq gc-cons-threshold 100000000) ; Wait until 100MB used before garbage collection
(setq gc-cons-percentage 0.6) ; Garbage collection when heap is 60% full  
(run-with-idle-timer 5 t (lambda () (garbage-collect))) ; Garbage collection every 5s when idle
(setq fast-but-imprecise-scrolling nil) ; Disable faster scrolling
(setq inhibit-compacting-font-caches nil) ; Compact font caches
(setq large-file-warning-threshold 50000000) ; Warn for files > 50MB
(setq inhibit-startup-message t) ; Disable startup message
(setq initial-scratch-message nil) ; Empty scratch message
(setq frame-inhibit-implied-resize nil) ; Allow auto resizing
(setq package--init-file-ensured nil) ; Check for all package initialization
(setq mode-require-final-newline t) ; Add newline at end of files
(setq inhibit-splash-screen t) ; Disable splash screen
(setq create-lockfiles nil) ; Disable lock files (Allow the same file to be opened multiple times)
(setq read-process-output-max (* 1024 1024)) ; Increase read process output
(setq initial-major-mode 'fundamental-mode) ; Disable lisp specific features on startup
(setq process-adaptive-read-buffering t) ; Enable adaptive read buffering
(setq bidi-inhibit-bpa nil) ; Enable bidirectional text support
(setq ring-bell-function nil) ; Enable bell sound
(setq visible-bell nil) ; Disable visible bell
(setq make-backup-files nil) ; No backup files
(setq auto-save-default nil) ; No auto-save files  
(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs
(setq-default tab-width 4) ; Set the tab width to 4
(show-paren-mode 1) ; Highlight matching parentheses
(global-visual-line-mode 1) ; Enable visual line wrapping
(setq word-wrap t) ; Allow words to wrap at line boundaries
(setq truncate-lines nil) ; Don't truncate long lines with $
(setq visual-line-fringe-indicators '(nil right-curly-arrow)) ; Show wrap indicator in right fringe as a right curly arrow
(load-file "~/.emacs.d/theme.el") ; Load theme file
(global-hl-line-mode 1) ; Enable highlight current line globally
(set-face-attribute 'hl-line nil :background "#2d2d30") ; Set highlight color to dark gray
(global-set-key (kbd "C-s") 'save-buffer) ; Shortcut to save file using Ctrl + S
(global-set-key (kbd "C-c") 'kill-ring-save) ; Shortcut to copy text using Ctrl + C
(global-set-key (kbd "C-v") 'yank) ; Shortcut to pate text using Ctrl + V
(global-set-key (kbd "C-x") 'kill-region) ; Shortcut to cut text using Ctrl + X
(global-set-key (kbd "C-z") 'undo-only) ; Shortcut to undo using Ctrl + Z
(global-set-key (kbd "C-y") 'undo-redo) ; Shortcut to redo using Ctrl + Y
(menu-bar-mode -1) ; Remove menu bar
(tool-bar-mode -1) ; Remove tool bar
(setq-default mode-line-format nil) ; Remove the mode line
(modify-all-frames-parameters '((mode-line-format . none))) ; Remove the mode line from all frames
(setq window-divider-default-places t) ; Enable window dividers
(setq window-divider-default-bottom-width 1) ; Set bottom divider width
(setq window-divider-default-right-width 1) ; Set right divider width
;; =============== Save File If It Matches Saved State ===============
(defvar my-change-log-buffer "*File Change Log*"
  "Name of the change log buffer.")
(defvar my-pending-deletion nil
  "Store deleted text before it's removed.")
(defvar my-edit-counter 0
  "Counter for edit numbers. Resets on file open/save.")
(defvar my-change-history nil
  "List of changes stored with markers. Each element is (TYPE MARKER TEXT OLD-TEXT).")
(defvar my-original-content nil
  "Store original buffer content when file is opened.")
(defvar my-verification-timer nil
  "Timer for delayed content verification.")
(defun my-get-change-log-buffer ()
  "Get or create the change log buffer."
  (get-buffer-create my-change-log-buffer))
(defun my-log-change-with-marker (type text position &optional old-text)
  "Log change using a marker that auto-adjusts."
  (let ((marker (copy-marker position))) ; Create a new marker at this position
    (push (list type marker text old-text) my-change-history)
    (my-display-change-in-log type marker text old-text)))
(defun my-display-change-in-log (type marker text old-text)
  "Display the change in your log buffer using the marker's current position."
  (let ((buffer (my-get-change-log-buffer))
        (time-str (format-time-string "%H:%M:%S"))
        (file-name (buffer-name))
        (current-pos (marker-position marker)))
    (with-current-buffer buffer
      (goto-char (point-max))
      (insert (format "%3d. [%s] %s: %s at position %d" 
                      my-edit-counter time-str file-name type current-pos))
      (when old-text
        (insert (format " (replaced '%s')" (my-escape-text old-text))))
      (insert (format " -> '%s'\n" (my-escape-text text)))
      (set-buffer-modified-p nil)))) ; Keep log buffer clean
(defun my-escape-text (text)
  "Escape special characters for display."
  (if (string= text "")
      "[empty]"
    (replace-regexp-in-string 
     "\n" "\\\\n"
     (replace-regexp-in-string
      "\t" "\\\\t" text))))
(defun my-capture-deletion (beg end)
  "Capture text about to be deleted."
  (when (and (buffer-file-name) 
             (not (minibufferp))
             (> (- end beg) 0))
    (setq my-pending-deletion (buffer-substring beg end))))

(defun my-track-all-changes (beg end &optional pre-change-length)
  "Track all changes made to a file buffer using markers."
  (when (and (buffer-file-name) 
             (not (minibufferp)))
    ;; Handle deletions (text being removed)
    (when (and pre-change-length (> pre-change-length 0) my-pending-deletion)
      (setq my-edit-counter (1+ my-edit-counter))
      (my-log-change-with-marker "DELETE" my-pending-deletion beg)
      (setq my-pending-deletion nil))
    ;; Handle insertions (text being added)
    (when (> (- end beg) 0)
      (let ((inserted-text (buffer-substring beg end)))
        (if (and pre-change-length (> pre-change-length 0) my-pending-deletion)
            ;; This was a replacement
            (progn
              (setq my-edit-counter (1+ my-edit-counter))
              (my-log-change-with-marker "REPLACE" inserted-text beg my-pending-deletion)
              (setq my-pending-deletion nil))
          ;; Regular insertion
          (setq my-edit-counter (1+ my-edit-counter))
          (my-log-change-with-marker "INSERT" inserted-text beg))))))
(defun my/store-original-content ()
  "Store the original buffer content when file is opened."
  (when (buffer-file-name)
    (setq my-original-content (buffer-string))))
(defun my/verify-content-match ()
  "Check if current buffer matches original content."
  (when (and my-original-content
             (buffer-file-name)
             (buffer-modified-p))
    (if (equal (buffer-string) my-original-content)
        (progn
          (message "✓ Buffer content now matches original file")
          (set-buffer-modified-p nil)
          (my-log-change-with-marker "MATCH" "All changes cancelled out - matches original" (point-min)))
      )))

(defun my/smart-verify-trigger (beg end &optional pre-change-length)
  "Trigger verification after changes, but only when useful."
  (ignore beg end pre-change-length)
  (when (and (buffer-file-name)
             (buffer-modified-p))

    ;; Cancel previous pending verification
    (when my-verification-timer
      (cancel-timer my-verification-timer))

    ;; Schedule verification for when user stops typing
    (setq my-verification-timer
          (run-with-idle-timer 0.5 nil #'my/verify-content-match))))

(defun my-reset-change-log ()
  "Reset change tracking when a file is saved."
  (when (buffer-file-name)
    (setq my-edit-counter 0)
    ;; Store the new original content (the saved state)
    (my/store-original-content)
    ;; Clear old markers to prevent memory leaks
    (setq my-change-history nil)
    (my-log-change-with-marker "SAVE" "File saved - tracking reset" (point-min))
    (message "File saved and change tracking reset")))

(defun my-log-file-open ()
  "Log when a file is opened."
  (when (buffer-file-name)
    (setq my-edit-counter 0)
    (setq my-change-history nil) ; Clear any old markers
    (my/store-original-content) ; Store original content when opening
    (my-log-change-with-marker "OPEN" (format "Started tracking %s" (buffer-file-name)) (point-min))))

(defun my-show-change-log ()
  "Display the change log buffer."
  (interactive)
  (let ((buffer (my-get-change-log-buffer)))
    (display-buffer buffer)
    (with-current-buffer buffer
      (goto-char (point-max))
      (recenter -1))))

(defun my-clear-change-log ()
  "Clear the change log buffer and all markers."
  (interactive)
  (let ((buffer (my-get-change-log-buffer)))
    (with-current-buffer buffer
      (erase-buffer)
      (insert "=== File Change Log ===\n")
      (insert "All file changes will be logged here.\n")
      (insert "Edit numbers reset on file open/save.\n")
      (insert "Positions auto-adjust using markers.\n\n")
      (set-buffer-modified-p nil)))
  ;; Clear all markers to prevent memory leaks
  (setq my-change-history nil)
  (setq my-edit-counter 0)
  (setq my-original-content nil))

(defun my-cleanup-buffer-markers ()
  "Clean up markers when a buffer is killed."
  (when (buffer-file-name)
    ;; Remove all markers associated with this buffer
    (setq my-change-history
          (cl-remove-if (lambda (change)
                         (and (markerp (nth 1 change))
                              (eq (marker-buffer (nth 1 change)) (current-buffer))))
                       my-change-history))
    (setq my-original-content nil)))
(defun my-setup-change-tracking ()
  "Setup change tracking for file buffer."
  (when (and (buffer-file-name)
             (not (minibufferp)))
    (setq my-edit-counter 0)
    (setq my-change-history nil)
    ;; Add hooks
    (add-hook 'before-change-functions #'my-capture-deletion nil t)
    (add-hook 'after-change-functions #'my-track-all-changes nil t)
    (add-hook 'after-change-functions #'my/smart-verify-trigger nil t)
    (add-hook 'after-save-hook #'my-reset-change-log nil t)
    (add-hook 'kill-buffer-hook #'my-cleanup-buffer-markers nil t)
    ;; Log file opening
    (my-log-file-open)))
(defun my-initialize-change-log ()
  "Initialize the change log system."
  (my-clear-change-log) ; Start with clean log
  (add-hook 'find-file-hook #'my-setup-change-tracking))
;; Initialize the system
(my-initialize-change-log)
(message "File change logger with markers loaded. Use M-x my-show-change-log to view changes.")
;; Display file save status on every key press
(defun my/show-save-status ()
  "Display a message indicating if the current file is saved or not."
  (let ((file-name (buffer-file-name))
        (modified (buffer-modified-p)))
    (if file-name
      (message "No file associated with buffer: %s" (buffer-name)))))
;; Add to post-command-hook to run after every command
(add-hook 'post-command-hook 'my/show-save-status)
(load "~/.emacs.d/lisp/menu-bar/menu-bar") ; Add menu bar
(load "~/.emacs.d/lisp/undo-redo/undo-redo") ; Add undo/ redo functionality

;; =============== Mouse Actions ===============
(defun my-select-entire-word ()
  "Select the entire word at cursor."
  (interactive)
  (let (p1 p2)
    (save-excursion
      (skip-chars-backward "[:alnum:]_-")
      (setq p1 (point))
      (skip-chars-forward "[:alnum:]_-")
      (setq p2 (point)))
    (set-mark p1)
    (goto-char p2)))

(defun mouse-set-point-and-select-line (event)
  "Move cursor to click position and select the line."
  (interactive "e")
  (mouse-set-point event)
  (mouse-set-region event)
  (activate-mark))

(defun my-drag-region (start-event)
  "Select region by dragging like default behavior."
  (interactive "e")
  (mouse-drag-track start-event))

(global-set-key [mouse-1] 'mouse-set-point) ; Move cursor to click location
(global-set-key [double-mouse-1] (lambda (event) (interactive "e") (mouse-set-point event) (my-select-entire-word)))
(global-set-key [triple-mouse-1] 'mouse-set-point-and-select-line)
(global-set-key [down-mouse-1] 'my-drag-region)
(define-key global-map [menu-bar mouse-1] nil)
(define-key global-map [tool-bar mouse-1] 'ignore)
(with-eval-after-load 'dired (define-key dired-mode-map [mouse-1] 'dired-find-file))
(with-eval-after-load 'info (define-key Info-mode-map [mouse-1] nil))
(global-set-key [drag-mouse-2] 'ignore)
(global-set-key [down-mouse-2] 'ignore)
(with-eval-after-load 'compile (define-key compilation-mode-map [mouse-2] 'ignore))
(global-unset-key [mouse-3])

;; =============== Search And Replace ===============
(defvar search-and-replace-buffer "*search-and-replace*")
(defvar search-and-replace-width 35 "Default width for search-and-replace sidebar")

(defun my-search-and-replace-is-open-p ()
  "Check if search-and-replace sidebar is open."
  (get-buffer-window search-and-replace-buffer))

(defun search-and-replace-increase-width ()
  "Increase search-and-replace window width by 5 columns."
  (interactive)
  (setq search-and-replace-width (+ search-and-replace-width 5))
  (when (my-search-and-replace-is-open-p)
    (my-close-search-and-replace)
    (search-and-replace)))

(defun search-and-replace-decrease-width ()
  "Decrease search-and-replace window width by 5 columns (minimum 20)."
  (interactive)
  (setq search-and-replace-width (max 20 (- search-and-replace-width 5)))
  (when (my-search-and-replace-is-open-p)
    (my-close-search-and-replace)
    (search-and-replace)))

(defun search-and-replace-reset-width ()
  "Reset search-and-replace window width to default 35 columns."
  (interactive)
  (setq search-and-replace-width 35)
  (when (my-search-and-replace-is-open-p)
    (my-close-search-and-replace)
    (search-and-replace)))

(defun my-close-search-and-replace ()
  "Close the search-and-replace sidebar."
  (interactive)
  (when (get-buffer-window search-and-replace-buffer)
    (delete-window (get-buffer-window search-and-replace-buffer)))
  (when (get-buffer search-and-replace-buffer)
    (kill-buffer search-and-replace-buffer)))

(defun my-close-sidebars ()
  "Close all sidebars."
  (interactive)
  (my-close-search-and-replace))

(defun search-and-replace ()
  "Open search-and-replace sidebar"
  (interactive)

  ;; If already open, just close it (toggle behavior)
  (if (my-search-and-replace-is-open-p)
      (my-close-search-and-replace)
    ;; Otherwise open it
    (when (get-buffer-window search-and-replace-buffer)
      (delete-window (get-buffer-window search-and-replace-buffer)))
    (split-window-horizontally search-and-replace-width)
    (with-current-buffer (get-buffer-create search-and-replace-buffer)
      (switch-to-buffer search-and-replace-buffer)
      (erase-buffer)
      (let ((inhibit-read-only t))
        ;; Header line with button on the right
        (widget-insert (propertize " SEARCH-AND-REPLACE" 'face '(:weight bold :height 1.2)))
        (widget-insert "   ")
        (widget-create 'push-button
                       :notify (lambda (&rest ignore) 
                                 (my-close-search-and-replace))
                       "Close")
        (widget-insert "\n")
        (widget-insert "=====================\n\n")
        ;; Add resize instructions
        (widget-insert "Resize: C-+ / C-- / C-0\n")
        (widget-insert "Close: C-c C-c\n\n")

        (widget-insert "Add content here...\n\n")
        (use-local-map (let ((map (copy-keymap widget-keymap)))
                         ;; Add resize keybindings
                         (define-key map (kbd "C-+") 'search-and-replace-increase-width)
                         (define-key map (kbd "C--") 'search-and-replace-decrease-width)
                         (define-key map (kbd "C-0") 'search-and-replace-reset-width)
                         ;; Add close keybinding
                         (define-key map (kbd "C-c C-c") 'my-close-sidebars)
                         map))
        (widget-setup)
        (setq-local cursor-type nil)
        (setq-local truncate-lines t)
        (setq-local window-size-fixed 'width)
        (read-only-mode 1)))))