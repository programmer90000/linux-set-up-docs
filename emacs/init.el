;; Disable startup screen
(setq inhibit-startup-screen t)

;; Enable line numbers
(global-display-line-numbers-mode 1)

;; Smooth scrolling
(setq scroll-step 1)
(setq scroll-margin 3)

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