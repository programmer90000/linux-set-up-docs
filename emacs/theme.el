;; Basic faces
(set-face-attribute 'default nil :foreground "#e0e0e0" :background "#1e1e1e") ; Text and background colour
(set-face-attribute 'cursor nil :background "#0078d4") ; Cursor colour

;; Syntax highlighting
(set-face-attribute 'font-lock-comment-face nil :foreground "#5a8a45" :italic t) ; Colour of comments
(set-face-attribute 'font-lock-keyword-face nil :foreground "#d4832d" :bold t) ; Colour of keywords
(set-face-attribute 'font-lock-string-face nil :foreground "#6bab6a") ; Colour of strings
(set-face-attribute 'font-lock-function-name-face nil :foreground "#dcdcaa")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "#9cdcfe")
(set-face-attribute 'font-lock-type-face nil :foreground "#4ec9b0")

;; Line numbers
(set-face-attribute 'line-number nil :foreground "#5a5a5a" :background "#1e1e1e") ; Regular line numbers colour
(set-face-attribute 'line-number-current-line nil :foreground "#ffffff" :background "#2d2d30") // Current line number colour

;; UI elements
(set-face-attribute 'mode-line nil :foreground "#ffffff" :background "#0078d4" :box nil) // Colour of status bar
(set-face-attribute 'region nil :background "#264f78") // Background colour of selected text
(set-face-attribute 'show-paren-match nil :background "#0f3d5c" :bold t) // Background colour of matching parentheses

(provide 'theme)
