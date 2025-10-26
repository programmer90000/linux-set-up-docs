(require 'dash)

(eval-and-compile
  (let ((msg "Package dash-functional is obsolete; use dash 2.18.0 instead"))
    (if (and noninteractive (fboundp 'byte-compile-warn))
        (byte-compile-warn msg)
      (message "%s" msg))))

(provide 'dash-functional)