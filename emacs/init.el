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
(add-to-list 'load-path "~/.emacs.d/lisp/neotree") ; Add neotree to load path
(require 'neotree) ; Require neotree
(global-set-key (kbd "<f8>") 'neotree-toggle) ; Set F8 key to toggle neotree
(setq neo-window-width 35) ; Initial width of neotree
(setq neo-smart-open t) ; Smart file opening inside neotree
(setq neo-show-hidden-files t) ; Show hidden files inside neotree
(setq neotree-enable-arrow-and-mouse-support t) ; Enable mouse support inside neotree
(setq neo-auto-indent-point t) ; Auto-indent neotree
(setq neo-show-updir-line t) ; Show ".." for parent directory inside neotree
;; Neotree width keybindings
(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key neotree-mode-map (kbd "C-+") 'neotree-increase-width)
            (define-key neotree-mode-map (kbd "C--") 'neotree-decrease-width)
            (define-key neotree-mode-map (kbd "C-0") 'neotree-reset-width)))
(defun neotree-increase-width ()
  "Increase neotree window width by 5 columns."
  (interactive)
  (setq neo-window-width (+ neo-window-width 5))
  (let ((current-dir (if (and (boundp 'neo-buffer--start-node) neo-buffer--start-node)
                         neo-buffer--start-node
                       default-directory)))
    (neotree-hide)
    (neotree-dir current-dir)))
(defun neotree-decrease-width ()
  "Decrease neotree window width by 5 columns (minimum 20)."
  (interactive)
  (setq neo-window-width (max 20 (- neo-window-width 5)))
  (let ((current-dir (if (and (boundp 'neo-buffer--start-node) neo-buffer--start-node)
                         neo-buffer--start-node
                       default-directory)))
    (neotree-hide)
    (neotree-dir current-dir)))
(defun neotree-reset-width ()
  "Reset neotree window width to default 35 columns."
  (interactive)
  (setq neo-window-width 35)
  (let ((current-dir (if (and (boundp 'neo-buffer--start-node) neo-buffer--start-node)
                         neo-buffer--start-node
                       default-directory)))
    (neotree-hide)
    (neotree-dir current-dir)))