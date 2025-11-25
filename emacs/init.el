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
(tab-bar-mode) ; Enable the line showing tabs at the top of the editor
(setq tab-bar-new-tab-choice "*scratch*") ; Open an empty tab when the new tab button is pressed
(menu-bar-mode -1) ; Remove menu bar
(tool-bar-mode -1) ; Remove tool bar
(setq-default mode-line-format nil) ; Remove the mode line
(modify-all-frames-parameters '((mode-line-format . none))) ; Remove the mode line from all frames
(setq window-divider-default-places t) ; Enable window dividers
(setq window-divider-default-bottom-width 1) ; Set bottom divider width
(setq window-divider-default-right-width 1) ; Set right divider width
;; Customize tab faces
(custom-set-faces
 '(tab-bar ((t :background "#1976d2" :foreground "#ffffff" :height 1.0)))
 '(tab-bar-tab-current ((t :background "#0078d4" :foreground "white" :weight bold :height 1.0)))
 '(tab-bar-tab-inactive ((t :background "#1565c0" :foreground "#e3f2fd" :height 1.0)))
 '(tab-bar-tab ((t :background "#1565c0" :foreground "#ffffff" :height 1.0))))
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

;; =============== Search And Replace ===============
(defvar search-and-replace-buffer "*search-and-replace*")
(defvar search-and-replace-width 35 "Default width for search-and-replace sidebar")

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