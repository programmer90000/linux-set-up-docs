;; test-vc.el --- test cases

(require 'neotree)
(require 'neotree-test)

(neo-test--try-open
 neo-test-vc-mode-with-face
 (shell-command-to-string "git init")
 (setq neo-vc-integration '(face)))

(neo-test--try-open
 neo-test-vc-mode-with-char
 (shell-command-to-string "git init")
 (setq neo-vc-integration '(char)))

(neo-test--try-open
 neo-test-vc-mode-with-char-face
 (shell-command-to-string "git init")
 (setq neo-vc-integration '(char face)))