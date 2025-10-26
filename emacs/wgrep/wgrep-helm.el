(require 'wgrep)

(declare-function helm-grep-split-line "helm-grep")

(defun wgrep-helm-setup ()
  (set (make-local-variable 'wgrep-header&footer-parser)
       'wgrep-helm-prepare-header&footer)
  (set (make-local-variable 'wgrep-results-parser)
       'wgrep-helm-parse-command-results)
  (wgrep-setup-internal))

(defun wgrep-helm-prepare-header&footer ()
  (let (beg end)
    ;; Set read-only grep result header
    (setq beg (point-min))
    (setq end (next-single-property-change
               (point-min) 'helm-realvalue))
    (put-text-property beg end 'read-only t)
    (put-text-property beg end 'wgrep-header t)
    ;; helm-grep-mode have NO footer.
    ))

(defun wgrep-helm-parse-command-results ()
  (while (not (eobp))
    (when (looking-at wgrep-line-file-regexp)
      (let* ((start (match-beginning 0))
             (end (match-end 0))
             (dispname (match-string 1))
             (namelen (length dispname)))
        (let* ((value (get-text-property (point) 'helm-realvalue))
               (data  (when (eq major-mode 'helm-grep-mode)
                        (helm-grep-split-line value)))
               (bufname (get-text-property (point) 'buffer-name))
               (fn    (or (and bufname (buffer-file-name (get-buffer bufname)))
                          (get-text-property (point) 'helm-grep-fname)))
               (line  (if data
                          (string-to-number (nth 1 data))
                        ;; Real value of candidate is now the line number in helm-occur.
                        value))
               (fprop (wgrep-construct-filename-property fn)))
          (put-text-property start end 'wgrep-line-filename fn)
          (put-text-property start end 'wgrep-line-number line)
          (put-text-property start (+ start namelen) fprop fn))))
    (forward-line 1)))

(add-hook 'helm-grep-mode-hook 'wgrep-helm-setup)

(add-hook 'helm-occur-mode-hook 'wgrep-helm-setup)

(defun wgrep-helm-unload-function ()
  (remove-hook 'helm-grep-mode-hook 'wgrep-helm-setup)
  (remove-hook 'helm-occur-mode-hook 'wgrep-helm-setup))

(provide 'wgrep-helm)