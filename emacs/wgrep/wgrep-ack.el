(require 'wgrep)

(defun wgrep-ack-and-a-half-setup ()
  ;; ack-and-a-half-mode prints a column number too, so we catch that
  ;; if it exists.  Here \2 is a colon + whitespace separator.  This
  ;; might need to change if (caar grep-regexp-alist) does.
  (set (make-local-variable 'wgrep-line-file-regexp)
       (concat
        wgrep-default-line-header-regexp
        "\\(?:\\([1-9][0-9]*\\)\\2\\)?"))
  (wgrep-setup-internal))

(defun wgrep-ack-setup ()
  (set (make-local-variable 'wgrep-results-parser)
       'wgrep-ack-prepare-command-results)
  (wgrep-setup-internal))

(defun wgrep-ack-prepare-command-results ()
  (let (fprop fn)
    (while (not (eobp))
      (cond
       ((null fn)
        ;; index of filename
        (let ((bol (line-beginning-position))
              (eol (line-end-position)))
          (when (/= bol eol)
            (setq fn (buffer-substring-no-properties bol eol))
            (setq fprop (wgrep-construct-filename-property fn))
            (put-text-property bol eol fprop fn)
            (put-text-property bol eol 'wgrep-ignore t))))
       ((looking-at "^\\([0-9]+\\)[:-]")
        (let ((start (match-beginning 0))
              (end (match-end 0))
              (line (string-to-number (match-string 1))))
          (put-text-property start end 'wgrep-line-filename fn)
          (put-text-property start end 'wgrep-line-number line)))
       ((looking-at "^$")
        (setq fn nil)))
      (forward-line 1))))

(add-hook 'ack-and-a-half-mode-hook 'wgrep-ack-and-a-half-setup)

(add-hook 'ack-mode-hook 'wgrep-ack-setup)

;; For `unload-feature'
(defun wgrep-ack-unload-function ()
  (remove-hook 'ack-and-a-half-mode-hook 'wgrep-ack-and-a-half-setup)
  (remove-hook 'ack-mode-hook 'wgrep-ack-setup))

(provide 'wgrep-ack)