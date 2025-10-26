(require 'wgrep)

(defvar wgrep-ag-grouped-result-file-regexp "^File:[[:space:]]+\\(.*\\)$"
  "Regular expression for the start of results for a file in grouped results.
\"Grouped results\" are what you get from ag.el when
`ag-group-matches' is true or when you call ag with --group.")

(defvar wgrep-ag-ungrouped-result-regexp
  "^\\(.+?\\):\\([[:digit:]]+\\)\\(?:-\\|:[[:digit:]]+:\\)"
  "Regular expression for an ungrouped result.
You get \"ungrouped results\" when `ag-group-matches' is false or
when you manage to call ag with --nogroup.")

(defun wgrep-ag-prepare-header&footer ()
  (save-excursion
    (goto-char (point-min))
    ;; Look for the first useful result line.
    (if (re-search-forward (concat wgrep-ag-grouped-result-file-regexp
                                   "\\|"
                                   wgrep-ag-ungrouped-result-regexp))
        (add-text-properties (point-min) (line-beginning-position)
                             '(read-only t wgrep-header t))
      ;; No results in this buffer, let's mark the whole thing as
      ;; header.
      (add-text-properties (point-min) (point-max)
                           '(read-only t wgrep-header t)))

    (goto-char (point-max))
    (re-search-backward "^\\(?:-[^:]+?:[[:digit:]]+:[[:digit:]]+:\\)" nil t)
    (when (zerop (forward-line 1))
      (add-text-properties (point) (point-max)
                           '(read-only t wgrep-footer t)))))

(defun wgrep-ag-parse-command-results ()
  (unless (bobp)
    (error "Expected to be called with point at beginning of buffer"))
  (save-excursion
    (while (re-search-forward wgrep-ag-grouped-result-file-regexp nil t)
      (add-text-properties (match-beginning 0) (match-end 0)
                           '(wgrep-ignore t))
      (let ((file-name (match-string-no-properties 1)))
        (add-text-properties (match-beginning 1) (match-end 1)
                             (list (wgrep-construct-filename-property file-name)
                                   file-name))
        (while (and (zerop (forward-line 1))
                    (looking-at
                     (concat "^\\([[:digit:]]+\\)\\(?::[[:digit:]]+:\\|-\\)"
                             "\\|\\(^--$\\)")))
          (if (match-beginning 2)
              ;; Ignore "--" line.
              (add-text-properties (match-beginning 0) (match-end 0)
                                   '(wgrep-ignore t))
            (add-text-properties (match-beginning 0) (match-end 0)
                                 (list 'wgrep-line-filename file-name
                                       'wgrep-line-number
                                       (string-to-number (match-string 1))))))))
    (when (bobp)
      ;; Search above never moved point, so match non-grouped results
      ;; (`ag-group-matches' is/was probably false).
      (let (last-file-name)
        (while (re-search-forward (concat wgrep-ag-ungrouped-result-regexp
                                          "\\|\\(^--$\\)")
                                  nil t)
          (if (match-beginning 3)
              ;; Ignore the "--" separator.
              (add-text-properties (match-beginning 0) (match-end 0)
                                   '(wgrep-ignore t))
            (let ((file-name (match-string-no-properties 1))
                  (line-number (string-to-number (match-string 2))))
              (unless (equal file-name last-file-name)
                (let ((file-name-prop
                       (wgrep-construct-filename-property file-name)))
                  (add-text-properties (match-beginning 1) (match-end 1)
                                       (list file-name-prop file-name)))
                (setq last-file-name file-name))
              (add-text-properties (match-beginning 0) (match-end 0)
                                   (list 'wgrep-line-filename file-name
                                         'wgrep-line-number line-number)))))))))

(defun wgrep-ag-setup ()
  (set (make-local-variable 'wgrep-header&footer-parser)
       'wgrep-ag-prepare-header&footer)
  (set (make-local-variable 'wgrep-results-parser)
       'wgrep-ag-parse-command-results)
  (wgrep-setup-internal))

(add-hook 'ag-mode-hook 'wgrep-ag-setup)

;; For `unload-feature'
(defun wgrep-ag-unload-function ()
  (remove-hook 'ag-mode-hook 'wgrep-ag-setup))

(provide 'wgrep-ag)