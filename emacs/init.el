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
(tab-bar-mode) ; Enable the line showing tabs at the top of the editor
(setq tab-bar-new-tab-choice "*scratch*") ; Open an empty tab when the new tab button is pressed
(menu-bar-mode -1) ; Remove menu bar
(tool-bar-mode -1) ; Remove tool bar
(setq-default mode-line-format nil) ; Remove the mode line
(modify-all-frames-parameters '((mode-line-format . none))) ; Remove the mode line from all frames
(load "~/.emacs.d/lisp/menu-bar/menu-bar") ; Add menu bar
(add-hook 'neo-after-create-hook
          (lambda (&rest _)
            (setq-local mode-line-format nil))) ; Remove mode line from Neotree

;; =============== Neotree ===============
(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key neotree-mode-map (kbd "C-+") 'neotree-increase-width)
            (define-key neotree-mode-map (kbd "C--") 'neotree-decrease-width)
            (define-key neotree-mode-map (kbd "C-0") 'neotree-reset-width)
            ;; Add close button to neotree
            (define-key neotree-mode-map (kbd "C-c C-c") 'my-close-sidebars)))

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

;; Function to check if neotree is open
(defun my-neotree-is-open-p ()
  "Return t if neotree is currently open and visible."
  (catch 'found
    (dolist (frame (frame-list))
      (dolist (window (window-list frame))
        (let ((buffer (window-buffer window)))
          (when (and (buffer-live-p buffer)
                     (string-match "\\*NeoTree\\*" (buffer-name buffer)))
            (throw 'found t)))))
    nil))

;; Function to check if search-and-replace is open
(defun my-search-and-replace-is-open-p ()
  "Return t if search-and-replace sidebar is currently open and visible."
  (catch 'found
    (dolist (frame (frame-list))
      (dolist (window (window-list frame))
        (let ((buffer (window-buffer window)))
          (when (and (buffer-live-p buffer)
                     (string= (buffer-name buffer) search-and-replace-buffer))
            (throw 'found t)))))
    nil))

;; Function to close both sidebars
(defun my-close-sidebars ()
  "Close both neotree and search-and-replace sidebars."
  (interactive)
  (when (my-neotree-is-open-p)
    (neotree-hide))
  (when (my-search-and-replace-is-open-p)
    (my-close-search-and-replace)))

;; Function to save sidebar states
(defun my-save-sidebar-states ()
  "Save neotree and search-and-replace sidebar states."
  (let ((state-file "~/.emacs.d/sidebar-states.el")
        (neotree-open (my-neotree-is-open-p))
        (search-replace-open (my-search-and-replace-is-open-p)))
    (with-temp-file state-file
      (insert ";; Sidebar states - auto-generated\n")
      (insert (format "(setq my-neotree-last-width %d)\n" neo-window-width))
      (insert (format "(setq my-search-replace-last-width %d)\n" search-and-replace-width))
      (insert (format "(setq my-neotree-was-open %s)\n" 
                      (if neotree-open "t" "nil")))
      (insert (format "(setq my-search-replace-was-open %s)\n"
                      (if search-replace-open "t" "nil"))))))

;; Function to load sidebar states  
(defun my-load-sidebar-states ()
  "Load sidebar states and restore if they were open."
  (let ((state-file "~/.emacs.d/sidebar-states.el"))
    (when (file-exists-p state-file)
      (load-file state-file)
      (when (and (boundp 'my-neotree-last-width) my-neotree-last-width)
        (setq neo-window-width my-neotree-last-width))
      (when (and (boundp 'my-search-replace-last-width) my-search-replace-last-width)
        (setq search-and-replace-width my-search-replace-last-width))
      (when (and (boundp 'my-neotree-was-open) my-neotree-was-open)
        (neotree-show))
      (when (and (boundp 'my-search-replace-was-open) my-search-replace-was-open)
        (search-and-replace)))))

;; Save state when neotree is toggled, shown, or hidden
(advice-add 'neotree-toggle :after #'my-save-sidebar-states)
(advice-add 'neotree-show :after #'my-save-sidebar-states)
(advice-add 'neotree-hide :after #'my-save-sidebar-states)

;; Save state when neotree is resized
(advice-add 'neotree-increase-width :after #'my-save-sidebar-states)
(advice-add 'neotree-decrease-width :after #'my-save-sidebar-states)
(advice-add 'neotree-reset-width :after #'my-save-sidebar-states)

;; Save state when search-and-replace is opened, closed, or resized
(advice-add 'search-and-replace :after #'my-save-sidebar-states)
(advice-add 'my-close-search-and-replace :after #'my-save-sidebar-states)
(advice-add 'search-and-replace-increase-width :after #'my-save-sidebar-states)
(advice-add 'search-and-replace-decrease-width :after #'my-save-sidebar-states)
(advice-add 'search-and-replace-reset-width :after #'my-save-sidebar-states)

;; Save state when Emacs is killed
(add-hook 'kill-emacs-hook 'my-save-sidebar-states)

;; Load state after a short delay when Emacs starts
(run-with-timer 1 nil 'my-load-sidebar-states)

(defun my-neotree-insert-header ()
  "Insert Neotree header with close button on the right side."
  (let ((header-line (if neo-banner-message
                         neo-banner-message
                       " NeoTree")))
    
    ;; Calculate padding to push close button to the right
    (let* ((available-width (- (window-width) (length header-line) 1))
           (padding (make-string (max 1 available-width) ?\s)))
      
      ;; Insert the header line with close button on the right
      (insert (propertize header-line 'face 'neo-banner-face))
      (insert padding)
      (insert (propertize "X" 
                          'face '(:foreground "red" :weight bold)
                          'mouse-face 'highlight
                          'help-echo "Close Neotree sidebar"
                          'keymap (let ((map (make-sparse-keymap)))
                                    (define-key map [mouse-1] 'neotree-hide)
                                    map)))
      (neo-buffer--newline-and-begin)
      (neo-buffer--newline-and-begin))))

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
  "Open search-and-replace sidebar, closing neotree if open."
  (interactive)
  ;; Close neotree if open
  (when (my-neotree-is-open-p)
    (neotree-hide))

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