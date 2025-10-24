;; test-cmds.el --- test cases

(require 'neotree)
(require 'neotree-test)


(ert-deftest neo-test-neotree-startup ()
  (neotree)
  (should (neo-global--window-exists-p)))

(ert-deftest neo-test-neotree-toggle ()
  (neotree-toggle)
  (should (neo-global--window-exists-p))
  (neotree-show)
  (should (neo-global--window-exists-p))
  (neotree-toggle)
  (should (not (neo-global--window-exists-p)))
  (neotree-hide)
  (should (not (neo-global--window-exists-p)))
  (neotree-show)
  (should (neo-global--window-exists-p)))

(ert-deftest neo-test-neotree-dir ()
  (neo-test--with-temp-dir
   (neotree-dir temp-cwd)
   (neo-global--with-buffer
    (should (string-equal neo-buffer--start-node temp-cwd)))
   (neotree-toggle)
   (neo-global--with-buffer
    (should (string-equal neo-buffer--start-node temp-cwd)))
   (neotree-toggle)
   (neo-global--with-buffer
    (should (string-equal neo-buffer--start-node temp-cwd)))))