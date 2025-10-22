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
(blink-cursor-mode 1)                         ; Enable cursor blinking

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