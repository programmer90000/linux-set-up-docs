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

;; No backup files
(setq make-backup-files nil)

;; No auto-save files  
(setq auto-save-default nil)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Highlight matching parentheses
(show-paren-mode 1)

;; Word wrap
(global-visual-line-mode 1)
(setq word-wrap t)
(setq truncate-lines nil)
(setq visual-line-fringe-indicators '(nil right-curly-arrow))

;; Theme
(load-file "~/.emacs.d/theme.el")

;; Enable current line highlighting
(global-hl-line-mode 1) 
(set-face-attribute 'hl-line nil :background "#2d2d30")