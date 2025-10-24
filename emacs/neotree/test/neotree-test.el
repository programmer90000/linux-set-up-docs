;; neotree-test.el --- test utilities

(defmacro neo-test--with-temp-dir (&rest body)
  (declare (indent 0) (debug t))
  `(let* ((temp-cwd (file-name-as-directory (make-temp-file "dir" t)))
          (temp-pd (neo-path--join temp-cwd "neo-test" "./")))
     (mkdir temp-pd)
     (unwind-protect
         (let ((default-directory temp-cwd)) ,@body)
       (delete-directory temp-cwd t))))

(defun neo-test--with-temp-dir-open ()
  (neo-test--with-temp-dir
    (write-region "" nil "file-1")
    (write-region "hello" nil "file-2")
    (neotree-dir temp-cwd)))

(defmacro neo-test--try-open (name &rest body)
  (declare (indent 0) (debug t))
  `(ert-deftest ,name ()
     ,@body
     (neo-test--with-temp-dir-open)))

(provide 'neotree-test)