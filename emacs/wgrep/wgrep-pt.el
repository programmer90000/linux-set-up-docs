(require 'wgrep)

(defun wgrep-pt-setup ()
  (wgrep-setup-internal))

(add-hook 'pt-search-mode-hook 'wgrep-pt-setup)

;; For `unload-feature'
(defun wgrep-pt-unload-function ()
  (remove-hook 'pt-search-mode-hook 'wgrep-pt-setup))

(provide 'wgrep-pt)