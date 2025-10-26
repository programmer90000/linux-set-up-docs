(require 'wgrep)

(defun wgrep-deadgrep-prepare-header&footer ()
  "Prepare header in `deadgrep' buffer for `wgrep'.
Since `deadgrep' does not have footer, only header is handled."
  ;; `deadgrep' uses "deadgrep-filename" property for filename.
  (let ((pos (next-single-property-change (point-min) 'deadgrep-filename)))
    (if pos
        (add-text-properties (point-min) pos '(read-only t wgrep-header t))
      (add-text-properties (point-min) (point-max)
                           '(read-only t wgrep-header t)))))

(defun wgrep-deadgrep-parse-command-results ()
  "Parse `deadgrep' results for `wgrep'."
  (unless (bobp)
    (error "Expected to be called with point at beginning of buffer"))
  (save-excursion
    (while (not (eobp))
      (let* ((pos (point))
             (filename (get-text-property pos 'deadgrep-filename))
             (line (get-text-property pos 'deadgrep-line-number)))
        (when filename
          (if line
              (let* ((eol (line-end-position))
                     (end (next-single-property-change
                           pos 'deadgrep-line-number nil eol)))
                (add-text-properties pos end
                                     (list 'wgrep-line-filename filename
                                           'wgrep-line-number line)))
            ;; Ignore the line that introduces matches from a file, so that wgrep doesn't let you edit it.
            (add-text-properties
             pos (line-end-position)
             (list 'wgrep-ignore t
                   (wgrep-construct-filename-property filename)
                   filename)))))
      (forward-line 1))))

(defun wgrep-deadgrep-setup ()
  "Setup `wgrep-deadgrep' for `deadgrep'."
  (setq wgrep-prepared nil)
  (set (make-local-variable 'wgrep-header&footer-parser)
       'wgrep-deadgrep-prepare-header&footer)
  (set (make-local-variable 'wgrep-results-parser)
       'wgrep-deadgrep-parse-command-results)
  (wgrep-setup-internal))

(add-hook 'deadgrep-finished-hook 'wgrep-deadgrep-setup)

(defun wgrep-deadgrep-unload-function ()
  "Unload `wgrep-deadgrep' setup."
  (remove-hook 'deadgrep-finished-hook 'wgrep-deadgrep-setup))

(provide 'wgrep-deadgrep)