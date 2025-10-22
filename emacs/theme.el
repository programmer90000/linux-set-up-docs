;; Basic faces
(set-face-attribute 'default nil :foreground "#e0e0e0" :background "#1e1e1e")
(set-face-attribute 'cursor nil :background "#569cd6")

;; Syntax highlighting
(set-face-attribute 'font-lock-comment-face nil :foreground "#6a9955" :italic t)
(set-face-attribute 'font-lock-keyword-face nil :foreground "#569cd6" :bold t)
(set-face-attribute 'font-lock-string-face nil :foreground "#ce9178")
(set-face-attribute 'font-lock-function-name-face nil :foreground "#dcdcaa")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "#9cdcfe")
(set-face-attribute 'font-lock-type-face nil :foreground "#4ec9b0")

;; Line numbers
(set-face-attribute 'line-number nil :foreground "#5a5a5a" :background "#1e1e1e")
(set-face-attribute 'line-number-current-line nil :foreground "#ffffff" :background "#2d2d30")

;; UI elements
(set-face-attribute 'mode-line nil :foreground "#ffffff" :background "#0078d4" :box nil)
(set-face-attribute 'region nil :background "#264f78")
(set-face-attribute 'show-paren-match nil :background "#0f3d5c" :bold t)

(provide 'theme)
