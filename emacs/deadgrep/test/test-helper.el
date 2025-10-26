(require 'ert)
(require 'f)

(let ((deadgrep-dir (f-parent (f-dirname (f-this-file)))))
  (add-to-list 'load-path deadgrep-dir))

(require 'undercover)
(undercover "deadgrep.el" (:exclude "*-test.el"))