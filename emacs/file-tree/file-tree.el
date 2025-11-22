(defvar file-explorer--root-directory nil
  "The root directory for the file explorer.")

(defvar file-explorer--expanded-nodes nil
  "A list of expanded directory paths and their expansion state.")

(defvar file-explorer--clipboard nil
  "Stores copied/cut files for paste operations.")

(defvar file-explorer--buffer-name "*File Explorer*"
  "Name of the file explorer buffer.")

(defvar file-explorer--sidebar-width 40
  "Width of the sidebar in characters.")

;; Core data functions
(defun file-explorer--get-files (directory)
  "Get all files and directories in DIRECTORY, sorted."
  (let ((files (directory-files directory t "^[^.]")))
    (sort files (lambda (a b)
                  (if (eq (file-directory-p a) (file-directory-p b))
                      (string-lessp (file-name-nondirectory a)
                                   (file-name-nondirectory b))
                    (file-directory-p a))))))

(defun file-explorer--create-buffer ()
  "Create and setup the file explorer buffer."
  (let ((buffer (get-buffer-create file-explorer--buffer-name)))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (file-explorer-mode))
    buffer))

;; Header implementation
(defun file-explorer--create-buffer ()
  "Create and setup the file explorer buffer."
  (let ((buffer (get-buffer-create file-explorer--buffer-name)))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (file-explorer-mode))
    buffer))

;; Header implementation
(defun file-explorer--insert-header ()
  "Insert the file explorer header with action buttons."
  (let ((inhibit-read-only t)
        (header-width (1- file-explorer--sidebar-width)))

    ;; Log the display widths to a custom buffer
    (with-current-buffer (get-buffer-create "*file-explorer-debug*")
      (erase-buffer)
      (insert (format "Header width: %d\n" header-width))
      (insert (format "📄 width: %d\n" (string-width "📄")))
      (insert (format "📁 width: %d\n" (string-width "📁")))
      (insert (format "🔄 width: %d\n" (string-width "🔄")))
      (insert (format "📂 width: %d\n" (string-width "📂")))
      (insert (format "Space width: %d\n" (string-width " ")))
      (insert (format "Two spaces width: %d\n" (string-width "  ")))
      (insert (format "Directory name: %s\n" (file-name-nondirectory 
                     (directory-file-name file-explorer--root-directory))))
      (insert (format "Directory name width: %d\n" (string-width (file-name-nondirectory
                     (directory-file-name file-explorer--root-directory))))))

    (let ((dir-name (file-name-nondirectory 
                     (directory-file-name file-explorer--root-directory))))
      (insert (propertize (file-explorer--truncate-filename dir-name (- header-width 17))
                         'face 'bold
                         'help-echo file-explorer--root-directory)))
    
    ;; Action buttons
    (insert (propertize "📄"
                       'mouse-face 'highlight
                       'help-echo "Create new file"
                       'action 'file-explorer--create-file)
            "  ")  ; Two spaces after
    
    (insert (propertize "📁"
                       'mouse-face 'highlight
                       'help-echo "Create new folder"
                       'action 'file-explorer--create-folder)
            "  ")  ; Two spaces after
    
    (insert (propertize "🔄"
                       'mouse-face 'highlight
                       'help-echo "Refresh view"
                       'action 'file-explorer-refresh)
            "  ")  ; Two spaces after
    
    (insert (propertize "📂"
                       'mouse-face 'highlight
                       'help-echo "Collapse all directories"
                       'action 'file-explorer--collapse-all))
    (insert "\n\n")))

(defun file-explorer--truncate-filename (filename max-width)
  "Truncate FILENAME to fit within MAX-WIDTH."
  (if (> (length filename) max-width)
      (concat (substring filename 0 (- max-width 3)) "...")
    filename))

(defun file-explorer--header-action (pos)
  "Execute header button action at POS."
  (let ((action (get-text-property pos 'action)))
    (when action
      (funcall action))))

;; Tree rendering engine
(defun file-explorer--insert-tree (directory &optional depth)
  "Insert file tree starting from DIRECTORY at DEPTH level."
  (setq depth (or depth 0))
  (let ((files (file-explorer--get-files directory))
        (prefix (make-string (* depth 2) ?\s)))
    
    (dolist (file files)
      (let ((relative-name (file-name-nondirectory file))
            (is-dir (file-directory-p file))
            (expanded (assoc-default file file-explorer--expanded-nodes)))
        
        (insert prefix)
        (if is-dir
            (insert (if expanded "📂 " "📁 "))
          (insert "📄 "))
        
        ;; Truncate long filenames for sidebar
        (let ((display-name (file-explorer--truncate-filename
                            relative-name
                            (- file-explorer--sidebar-width
                               (length prefix)
                               3)))) ; Account for icon and spacing
          (insert (propertize display-name
                             'face (if is-dir 'font-lock-function-name-face
                                     'font-lock-variable-name-face)
                             'file-path file
                             'filename relative-name
                             'directory-p is-dir
                             'expandable-p is-dir
                             'expanded-p expanded
                             'mouse-face 'highlight
                             'help-echo (format "%s - Click: open, Right-click: menu"
                                               file))))
        (insert "\n")

        (when (and is-dir expanded)
          (file-explorer--insert-tree file (1+ depth)))))))

(defun file-explorer--toggle-expand (pos)
  "Toggle expansion state of directory at POS."
  (let ((file-path (get-text-property pos 'file-path))
        (is-dir (get-text-property pos 'directory-p)))
    (when is-dir
      (let ((current-state (assoc-default file-path file-explorer--expanded-nodes)))
        (setq file-explorer--expanded-nodes
              (assoc-delete-all file-path file-explorer--expanded-nodes))
        (unless current-state
          (push (cons file-path t) file-explorer--expanded-nodes)))
      (file-explorer-refresh))))

;; Window resize functions
(defun file-explorer-increase-width ()
  "Increase the file explorer sidebar window width."
  (interactive)
  (let ((window (get-buffer-window file-explorer--buffer-name)))
    (when window
      (window-resize window 5 t) ; Increase by 5 columns, horizontally
      (setq file-explorer--sidebar-width (window-width window))
      (file-explorer-refresh)
      (message "File explorer width: %d" (window-width window)))))

(defun file-explorer-decrease-width ()
  "Decrease the file explorer sidebar window width."
  (interactive)
  (let ((window (get-buffer-window file-explorer--buffer-name)))
    (when window
      (window-resize window -5 t) ; Decrease by 5 columns, horizontally
      (setq file-explorer--sidebar-width (window-width window))
      (file-explorer-refresh)
      (message "File explorer width: %d" (window-width window)))))

(defun file-explorer-reset-width ()
  "Reset file explorer sidebar window width to default."
  (interactive)
  (let ((window (get-buffer-window file-explorer--buffer-name)))
    (when window
      (let ((current-width (window-width window))
            (target-width 40))
        (window-resize window (- target-width current-width) t)
        (setq file-explorer--sidebar-width target-width)
        (file-explorer-refresh)
        (message "File explorer width reset to %d" target-width)))))

;; Context menu system
(defun file-explorer--context-menu (pos)
  "Show context menu for file/directory at POS."
  (let ((file-path (get-text-property pos 'file-path))
        (is-dir (get-text-property pos 'directory-p))
        (name (get-text-property pos 'filename)))
    (when file-path
      (let ((menu (easy-menu-create-menu
                   nil
                   `([,(format "Open: %s" name) 
                      file-explorer--open-file
                      :enable ,(not is-dir)]
                     [,(format "Open Directory: %s" name)
                      file-explorer--open-directory
                      :enable ,is-dir]
                     "---"
                     ["Cut" file-explorer--cut-file]
                     ["Copy" file-explorer--copy-file]
                     ["Paste" file-explorer--paste-file
                      :enable file-explorer--clipboard]
                     "---"
                     ["Rename" file-explorer--start-rename]
                     ["Copy Path" file-explorer--copy-path]
                     ["Copy Relative Path" file-explorer--copy-relative-path]
                     "---"
                     ["Delete" file-explorer--delete-file]))))
        (easy-menu-popup menu)))))

(defun file-explorer--get-file-at-point ()
  "Get file properties at current point."
  (let ((pos (point)))
    (list :path (get-text-property pos 'file-path)
          :name (get-text-property pos 'filename)
          :is-dir (get-text-property pos 'directory-p)
          :pos pos)))

;; Widget integration
(defun file-explorer--start-rename ()
  "Start renaming the file at point using a widget."
  (interactive)
  (let* ((props (file-explorer--get-file-at-point))
         (old-name (plist-get props :name))
         (file-path (plist-get props :path))
         (is-dir (plist-get props :is-dir))
         (pos (plist-get props :pos)))
    
    (when file-path
      (goto-char pos)
      (beginning-of-line)
      (let ((line-start (point))
            (line-end (line-end-position)))
        
        (delete-region line-start line-end)
        (insert (make-string (current-column) ?\s))
        
        (widget-create 'editable-field
                      :size (min (length old-name) 30) ; Limit size for sidebar
                      :value old-name
                      :action (lambda (widget &rest ignore)
                                (file-explorer--finish-rename 
                                 (widget-value widget) 
                                 file-path 
                                 is-dir))
                      file-explorer--root-directory)))))

(defun file-explorer--create-file ()
  "Create a new file using widget input."
  (interactive)
  (file-explorer--create-item nil))

(defun file-explorer--create-folder ()
  "Create a new folder using widget input."
  (interactive)
  (file-explorer--create-item t))

(defun file-explorer--create-item (is-dir)
  "Create a new file or folder using widget input."
  (goto-char (point-max))
  (insert "\n")
  (widget-create 'editable-field
                :size 20
                :value ""
                :action (lambda (widget &rest ignore)
                          (file-explorer--finish-create 
                           (widget-value widget) 
                           is-dir))
                (if is-dir "New folder: " "New file: ")))

;; File operations
(defun file-explorer--finish-rename (new-name old-path is-dir)
  "Finish renaming operation from OLD-PATH to NEW-NAME."
  (let ((dir (file-name-directory old-path))
        (new-path (expand-file-name new-name dir)))
    (condition-case err
        (progn
          (rename-file old-path new-path)
          (file-explorer-refresh)
          (message "Renamed to: %s" new-name))
      (error 
       (message "Rename failed: %s" (error-message-string err))
       (file-explorer-refresh)))))

(defun file-explorer--finish-create (name is-dir)
  "Finish creating new file or folder NAME."
  (let ((new-path (expand-file-name name file-explorer--root-directory)))
    (condition-case err
        (progn
          (if is-dir
              (make-directory new-path)
            (write-region "" nil new-path))
          (file-explorer-refresh)
          (message "Created: %s" name))
      (error
       (message "Creation failed: %s" (error-message-string err))
       (file-explorer-refresh)))))

(defun file-explorer--open-file ()
  "Open the file at point."
  (interactive)
  (let ((props (file-explorer--get-file-at-point))
        (path (plist-get props :path))
        (is-dir (plist-get props :is-dir)))
    (cond (is-dir (file-explorer--toggle-expand (plist-get props :pos)))
          (path 
           (find-file path)
           (file-explorer--maybe-switch-back)))))

(defun file-explorer--open-directory ()
  "Open the directory at point in file explorer."
  (interactive)
  (let ((path (plist-get (file-explorer--get-file-at-point) :path)))
    (when path
      (setq file-explorer--root-directory path)
      (file-explorer-refresh))))

(defun file-explorer--maybe-switch-back ()
  "Switch back to file explorer buffer if it's the only window."
  (when (and (get-buffer file-explorer--buffer-name)
             (= (length (window-list)) 1))
    (switch-to-buffer file-explorer--buffer-name)))

(defun file-explorer--copy-file ()
  "Copy file at point to clipboard."
  (interactive)
  (let ((path (plist-get (file-explorer--get-file-at-point) :path)))
    (setq file-explorer--clipboard (list :action 'copy :files (list path)))
    (message "Copied: %s" (file-name-nondirectory path))))

(defun file-explorer--cut-file ()
  "Cut file at point to clipboard."
  (interactive)
  (let ((path (plist-get (file-explorer--get-file-at-point) :path)))
    (setq file-explorer--clipboard (list :action 'cut :files (list path)))
    (message "Cut: %s" (file-name-nondirectory path))))

(defun file-explorer--paste-file ()
  "Paste clipboard files to current directory."
  (interactive)
  (when file-explorer--clipboard
    (let ((action (plist-get file-explorer--clipboard :action))
          (files (plist-get file-explorer--clipboard :files)))
      (dolist (file files)
        (let ((new-name (expand-file-name 
                        (file-name-nondirectory file) 
                        file-explorer--root-directory)))
          (cond ((eq action 'copy)
                 (copy-file file new-name))
                ((eq action 'cut)
                 (rename-file file new-name)
                 (setq file-explorer--clipboard nil)))))
      (file-explorer-refresh)
      (message "Pasted %d files" (length files)))))

(defun file-explorer--delete-file ()
  "Delete file at point after confirmation."
  (interactive)
  (let ((path (plist-get (file-explorer--get-file-at-point) :path))
        (name (plist-get (file-explorer--get-file-at-point) :name)))
    (when (yes-or-no-p (format "Delete '%s'? " name))
      (if (file-directory-p path)
          (delete-directory path t)
        (delete-file path))
      (file-explorer-refresh)
      (message "Deleted: %s" name))))

(defun file-explorer--copy-path ()
  "Copy absolute path of file at point."
  (interactive)
  (let ((path (plist-get (file-explorer--get-file-at-point) :path)))
    (kill-new path)
    (message "Copied path: %s" path)))

(defun file-explorer--copy-relative-path ()
  "Copy relative path of file at point from root directory."
  (interactive)
  (let ((path (plist-get (file-explorer--get-file-at-point) :path)))
    (kill-new (file-relative-name path file-explorer--root-directory))
    (message "Copied relative path")))

;; Keymaps
(defvar file-explorer-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'file-explorer--open-file)
    (define-key map (kbd "TAB") 'file-explorer--toggle-expand)
    (define-key map (kbd "C") 'file-explorer--copy-file)
    (define-key map (kbd "X") 'file-explorer--cut-file)
    (define-key map (kbd "V") 'file-explorer--paste-file)
    (define-key map (kbd "R") 'file-explorer--start-rename)
    (define-key map (kbd "D") 'file-explorer--delete-file)
    (define-key map (kbd "g") 'file-explorer-refresh)
    (define-key map (kbd "q") 'file-explorer-quit)
    ;; Resize keys
    (define-key map (kbd "M-+") 'file-explorer-increase-width)
    (define-key map (kbd "M--") 'file-explorer-decrease-width)
    (define-key map (kbd "M-=") 'file-explorer-reset-width)
    (define-key map [mouse-1] 'file-explorer--handle-click)
    (define-key map [mouse-3] 'file-explorer--context-menu)
    map)
  "Keymap for file-explorer-mode.")

;; Major mode
(define-derived-mode file-explorer-mode special-mode "File Explorer"
  "Major mode for the file explorer."
  (setq-local widget-keymap nil)
  (use-local-map file-explorer-mode-map)
  (setq truncate-lines t)
  (setq cursor-type nil)
  (setq show-trailing-whitespace nil)
  (setq buffer-face-mode `(:family "Monospace" :height 100)))

(defun file-explorer--handle-click (event)
  "Handle mouse click EVENT in file explorer."
  (interactive "e")
  (let ((pos (posn-point (event-end event))))
    (goto-char pos)
    (if (get-text-property pos 'action)
        (file-explorer--header-action pos)
      (file-explorer--open-file))))

;; Sidebar window management
(defun file-explorer--setup-sidebar-window (buffer)
  "Setup BUFFER as sidebar window."
  (let ((window (display-buffer-in-side-window
                 buffer
                 '((side . left)
                   (slot . 0)
                   (window-parameters . ((no-delete-other-windows . t)))))))
    (with-selected-window window
      (setq mode-line-format nil)
      (set-window-dedicated-p window t)
      ;; Set the initial width
      (window-resize window (- file-explorer--sidebar-width (window-width window)) t)
      window)))

;; Main interface functions
(defun file-explorer-refresh ()
  "Refresh the file explorer view."
  (interactive)
  (let ((buffer (get-buffer file-explorer--buffer-name)))
    (when buffer
      (with-current-buffer buffer
        (let ((inhibit-read-only t)
              (current-line (line-number-at-pos))
              (current-file (get-text-property (point) 'file-path)))
          (erase-buffer)
          (file-explorer--insert-header)
          (file-explorer--insert-tree file-explorer--root-directory)
          (read-only-mode 1)
          
          ;; Try to restore cursor position
          (when current-file
            (goto-char (point-min))
            (when (search-forward (file-name-nondirectory current-file) nil t)
              (beginning-of-line)))
          (when (> current-line 1)
            (forward-line (1- current-line))))))))

(defun file-explorer--collapse-all ()
  "Collapse all expanded directories."
  (interactive)
  (setq file-explorer--expanded-nodes nil)
  (file-explorer-refresh))

(defun file-explorer-quit ()
  "Quit the file explorer sidebar."
  (interactive)
  (let ((window (get-buffer-window file-explorer--buffer-name)))
    (when window
      (delete-window window))
    (kill-buffer file-explorer--buffer-name)))

(defun file-explorer-toggle ()
  "Toggle the file explorer sidebar."
  (interactive)
  (if (get-buffer-window file-explorer--buffer-name)
      (file-explorer-quit)
    (file-explorer default-directory)))

;;;###autoload
(defun file-explorer (directory)
  "Open file explorer for DIRECTORY as sidebar."
  (interactive "DDirectory: ")
  (setq file-explorer--root-directory (expand-file-name directory))
  (setq file-explorer--expanded-nodes nil)
  (let ((buffer (file-explorer--create-buffer)))
    (file-explorer--setup-sidebar-window buffer)
    (file-explorer-refresh)))

;; Global keybindings for resize (optional)
(global-set-key (kbd "M-+") 'file-explorer-increase-width)
(global-set-key (kbd "M--") 'file-explorer-decrease-width)
(global-set-key (kbd "M-=") 'file-explorer-reset-width)

(provide 'file-explorer)
;;; file-explorer.el ends here