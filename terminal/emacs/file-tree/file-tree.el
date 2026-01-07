(defvar file-tree--root-directory nil
  "The root directory for the file tree.")

(defvar file-tree--expanded-nodes nil
  "A list of expanded directory paths and their expansion state.")

(defvar file-tree--clipboard nil
  "Stores copied/cut files for paste operations.")

(defvar file-tree--buffer-name "*File Tree*"
  "Name of the file tree buffer.")

(defvar file-tree--sidebar-width 40
  "Width of the sidebar in characters.")

;; Core data functions
(defun file-tree--get-files (directory)
  "Get all files and directories in DIRECTORY, sorted."
  (let ((files (directory-files directory t "^[^.]")))
    (sort files (lambda (a b)
                  (if (eq (file-directory-p a) (file-directory-p b))
                      (string-lessp (file-name-nondirectory a)
                                   (file-name-nondirectory b))
                    (file-directory-p a))))))

(defun file-tree--create-buffer ()
  "Create and setup the file tree buffer."
  (let ((buffer (get-buffer-create file-tree--buffer-name)))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (file-tree-mode))
    buffer))

;; Header implementation
(defun file-tree--create-buffer ()
  "Create and setup the file tree buffer."
  (let ((buffer (get-buffer-create file-tree--buffer-name)))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (file-tree-mode))
    buffer))

;; Header implementation
(defun file-tree--insert-header ()
  "Insert the file tree header with action buttons."
  (let ((inhibit-read-only t)
        (header-width (1- file-tree--sidebar-width)))

    ;; Log the display widths to a custom buffer
    (with-current-buffer (get-buffer-create "*file-tree-debug*")
      (erase-buffer)
      (insert (format "Header width: %d\n" header-width))
      (insert (format "📄 width: %d\n" (string-width "📄")))
      (insert (format "📁 width: %d\n" (string-width "📁")))
      (insert (format "🔄 width: %d\n" (string-width "🔄")))
      (insert (format "📂 width: %d\n" (string-width "📂")))
      (insert (format "Space width: %d\n" (string-width " ")))
      (insert (format "Two spaces width: %d\n" (string-width "  ")))
      (insert (format "Directory name: %s\n" (file-name-nondirectory 
                     (directory-file-name file-tree--root-directory))))
      (insert (format "Directory name width: %d\n" (string-width (file-name-nondirectory
                     (directory-file-name file-tree--root-directory))))))

    (let ((dir-name (file-name-nondirectory 
                     (directory-file-name file-tree--root-directory))))
      (insert (propertize (file-tree--truncate-dirname dir-name (- header-width 18))
                         'face 'bold
                         'help-echo file-tree--root-directory)))

    (insert " ") ; Add space between the dir name and icons
    
    ;; Action buttons
    (insert (propertize "📄"
                       'mouse-face 'highlight
                       'help-echo "Create new file"
                       'action 'file-tree--create-file)
            "  ")  ; Two spaces after
    
    (insert (propertize "📁"
                       'mouse-face 'highlight
                       'help-echo "Create new folder"
                       'action 'file-tree--create-folder)
            "  ")  ; Two spaces after
    
    (insert (propertize "🔄"
                       'mouse-face 'highlight
                       'help-echo "Refresh view"
                       'action 'file-tree-refresh)
            "  ")  ; Two spaces after
    
    (insert (propertize "📂"
                       'mouse-face 'highlight
                       'help-echo "Collapse all directories"
                       'action 'file-tree--collapse-all))
    (insert "\n\n")))

(defun file-tree--truncate-dirname (dirname max-width)
  "Truncate DIRNAME to fit within MAX-WIDTH."
  (if (> (length dirname) max-width)
      (concat (substring dirname 0 (- max-width 3)) "...")
    dirname))

(defun file-tree--truncate-filename (filename max-width)
  "Truncate FILENAME to fit within MAX-WIDTH."
  (if (> (length filename) max-width)
      (concat (substring filename 0 (- max-width 7)) "...")
    filename))

(defun file-tree--header-action (pos)
  "Execute header button action at POS."
  (let ((action (get-text-property pos 'action)))
    (when action
      (funcall action))))

;; Tree rendering engine
(defun file-tree--insert-tree (directory &optional depth)
  "Insert file tree starting from DIRECTORY at DEPTH level."
  (setq depth (or depth 0))
  (let ((files (file-tree--get-files directory))
        (prefix (make-string (* depth 2) ?\s)))
    
    (dolist (file files)
      (let ((relative-name (file-name-nondirectory file))
            (is-dir (file-directory-p file))
            (expanded (assoc-default file file-tree--expanded-nodes)))
        
        (insert prefix)
        (if is-dir
            (insert (if expanded "📂 " "📁 "))
          (insert "📄 "))
        
        ;; Truncate long filenames for sidebar
        (let ((display-name (file-tree--truncate-filename
                            relative-name
                            (- file-tree--sidebar-width
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
          (file-tree--insert-tree file (1+ depth)))))))

(defun file-tree--toggle-expand (pos)
  "Toggle expansion state of directory at POS."
  (let ((file-path (get-text-property pos 'file-path))
        (is-dir (get-text-property pos 'directory-p)))
    (when is-dir
      (let ((current-state (assoc-default file-path file-tree--expanded-nodes)))
        (setq file-tree--expanded-nodes
              (assoc-delete-all file-path file-tree--expanded-nodes))
        (unless current-state
          (push (cons file-path t) file-tree--expanded-nodes)))
      (file-tree-refresh))))

;; Window resize functions
(defun file-tree-increase-width ()
  "Increase the file tree sidebar window width."
  (interactive)
  (let ((window (get-buffer-window file-tree--buffer-name)))
    (when window
      (window-resize window 5 t) ; Increase by 5 columns, horizontally
      (setq file-tree--sidebar-width (window-width window))
      (file-tree-refresh)
      (message "File tree width: %d" (window-width window)))))

(defun file-tree-decrease-width ()
  "Decrease the file tree sidebar window width."
  (interactive)
  (let ((window (get-buffer-window file-tree--buffer-name)))
    (when window
      (window-resize window -5 t) ; Decrease by 5 columns, horizontally
      (setq file-tree--sidebar-width (window-width window))
      (file-tree-refresh)
      (message "File tree width: %d" (window-width window)))))

(defun file-tree-reset-width ()
  "Reset file tree sidebar window width to default."
  (interactive)
  (let ((window (get-buffer-window file-tree--buffer-name)))
    (when window
      (let ((current-width (window-width window))
            (target-width 40))
        (window-resize window (- target-width current-width) t)
        (setq file-tree--sidebar-width target-width)
        (file-tree-refresh)
        (message "File tree width reset to %d" target-width)))))

;; Context menu system
(defun file-tree--context-menu (event)
  "Show context menu for mouse EVENT."
  (interactive "e")
  (let ((pos (posn-point (event-end event)))
        (file-path)
        (is-dir)
        (name))
    (when pos
      (save-excursion
        (goto-char pos)
        (setq file-path (get-text-property pos 'file-path))
        (setq is-dir (get-text-property pos 'directory-p))
        (setq name (get-text-property pos 'filename))

        (let ((menu (make-sparse-keymap)))
          (if file-path
              ;; File/directory context menu
              (progn
                (define-key menu [open]
                  `(menu-item ,(if is-dir "Open Directory" "Open")
                             file-tree--menu-open))
                (define-key menu [cut] '(menu-item "Cut" file-tree--menu-cut))
                (define-key menu [copy] '(menu-item "Copy" file-tree--menu-copy))
                (define-key menu [rename] '(menu-item "Rename" file-tree--menu-rename))
                (define-key menu [delete] '(menu-item "Delete" file-tree--menu-delete))
                (define-key menu [sep1] '(menu-item "--"))  ;; Separator
                (define-key menu [abs-path] '(menu-item "Copy Absolute Path" file-tree--menu-copy-path))
                (define-key menu [rel-path] '(menu-item "Copy Relative Path" file-tree--menu-copy-relative-path)))
            
            ;; Empty area context menu
            (define-key menu [paste]
              `(menu-item "Paste" file-tree--menu-paste
                         :enable ,(and file-tree--clipboard t))))

          ;; Show the menu
          (popup-menu menu event))))))


(defun file-tree--menu-paste ()
  "Paste clipboard files from context menu."
  (interactive)
  (file-tree--paste-file))

(defun file-tree--menu-open ()
  "Open file/directory from context menu."
  (interactive)
  (file-tree--open-file))

(defun file-tree--menu-cut ()
  "Cut file from context menu."
  (interactive)
  (file-tree--cut-file))

(defun file-tree--menu-copy ()
  "Copy file from context menu."
  (interactive)
  (file-tree--copy-file))

(defun file-tree--menu-rename ()
  "Rename file from context menu."
  (interactive)
  (let ((file-path (get-text-property (point) 'file-path))
        (inhibit-read-only t))  ; Temporarily disable read-only
    (when file-path
      (let ((new-name (read-string "New name: " (file-name-nondirectory file-path))))
        (when (and new-name (not (string-blank-p new-name)))
          (let ((new-path (expand-file-name new-name (file-name-directory file-path))))
            ;; Perform the rename operation
            (rename-file file-path new-path)
            ;; Refresh the file tree to show changes
            (file-tree-refresh)))))))

(defun file-tree--menu-delete ()
  "Delete file from context menu."
  (interactive)
  (file-tree--delete-file))

(defun file-tree--menu-copy-path ()
  "Copy absolute path from context menu."
  (interactive)
  (file-tree--copy-path))

(defun file-tree--menu-copy-relative-path ()
  "Copy relative path from context menu."
  (interactive)
  (file-tree--copy-relative-path))

(defun file-tree--get-file-at-point ()
  "Get file properties at current point."
  (let ((pos (point)))
    (list :path (get-text-property pos 'file-path)
          :name (get-text-property pos 'filename)
          :is-dir (get-text-property pos 'directory-p)
          :pos pos)))

;; Widget integration
(defun file-tree--start-rename ()
  "Start renaming the file at point using a widget."
  (interactive)
  (let* ((props (file-tree--get-file-at-point))
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
                                (file-tree--finish-rename 
                                 (widget-value widget) 
                                 file-path 
                                 is-dir))
                      file-tree--root-directory)))))

(defun file-tree--create-file ()
  "Create a new file."
  (interactive)
  (let ((default-directory file-tree--root-directory)
        (file-name (read-file-name "Create file: " default-directory)))
    ;; Create the file immediately with empty content
    (write-region "" nil file-name)
    ;; Refresh file tree to show the new file
    (file-tree-refresh)
    ;; Switch to main window and open file
    (select-window (window-main-window))
    (tab-bar-new-tab)
    (find-file file-name)))

(defun file-tree--create-folder ()
  "Create a new folder."
  (interactive)
  (let ((default-directory file-tree--root-directory)
        (folder-name (read-string "Create folder: ")))
    (when (and folder-name (not (string-empty-p folder-name)))
      (let ((folder-path (expand-file-name folder-name)))
        (condition-case err
            (progn
              (make-directory folder-path t)
              (file-tree-refresh)
              (message "Created folder: %s" folder-name))
          (error
           (message "Folder creation failed: %s" (error-message-string err))
           (file-tree-refresh)))))))

(defun file-tree--create-item (is-dir)
  "Create a new file or folder using widget input."
  (goto-char (point-max))
  (insert "\n")
  (widget-create 'editable-field
                :size 20
                :value ""
                :action (lambda (widget &rest ignore)
                          (file-tree--finish-create 
                           (widget-value widget) 
                           is-dir))
                (if is-dir "New folder: " "New file: ")))

;; File operations
(defun file-tree--finish-rename (new-name old-path is-dir)
  "Finish renaming operation from OLD-PATH to NEW-NAME."
  (let ((dir (file-name-directory old-path))
        (new-path (expand-file-name new-name dir)))
    (condition-case err
        (progn
          (rename-file old-path new-path)
          (file-tree-refresh)
          (message "Renamed to: %s" new-name))
      (error 
       (message "Rename failed: %s" (error-message-string err))
       (file-tree-refresh)))))

(defun file-tree--finish-create (name is-dir)
  "Finish creating new file or folder NAME."
  (let ((new-path (expand-file-name name file-tree--root-directory)))
    (condition-case err
        (progn
          (if is-dir
              (make-directory new-path)
            (write-region "" nil new-path))
          (file-tree-refresh)
          (message "Created: %s" name))
      (error
       (message "Creation failed: %s" (error-message-string err))
       (file-tree-refresh)))))

(defun file-tree--open-file ()
  "Open the file at point."
  (interactive)
  (let* ((props (file-tree--get-file-at-point))
         (path (plist-get props :path))
         (is-dir (plist-get props :is-dir))
         (pos (plist-get props :pos)))
    (cond (is-dir (file-tree--toggle-expand pos))
          (path 
           (progn
             ;; Switch to main window and open in new tab
             (select-window (window-main-window))
             (tab-bar-new-tab)
             (find-file path))))))

(defun file-tree--open-directory ()
  "Open the directory at point in file tree."
  (interactive)
  (let ((path (plist-get (file-tree--get-file-at-point) :path)))
    (when path
      (setq file-tree--root-directory path)
      (file-tree-refresh))))

(defun file-tree--copy-file ()
  "Copy file at point to clipboard."
  (interactive)
  (let ((path (plist-get (file-tree--get-file-at-point) :path)))
    (setq file-tree--clipboard (list :action 'copy :files (list path)))
    (message "Copied: %s" (file-name-nondirectory path))))

(defun file-tree--cut-file ()
  "Cut file at point to clipboard."
  (interactive)
  (let ((path (plist-get (file-tree--get-file-at-point) :path)))
    (setq file-tree--clipboard (list :action 'cut :files (list path)))
    (message "Cut: %s" (file-name-nondirectory path))))

(defun file-tree--paste-file ()
  "Paste clipboard files to current directory."
  (interactive)
  (when file-tree--clipboard
    (let ((action (plist-get file-tree--clipboard :action))
          (files (plist-get file-tree--clipboard :files))
          (pasted-count 0))

      (dolist (file files)
        (let* ((original-name (file-name-nondirectory file))
               (new-name (file-tree--generate-unique-filename
                         original-name
                         file-tree--root-directory)))
          (cond ((eq action 'copy)
                 (condition-case err
                     (progn
                       (copy-file file new-name)
                       (setq pasted-count (1+ pasted-count)))
                   (error
                    (message "Copy failed: %s" (error-message-string err)))))

                ((eq action 'cut)
                 (condition-case err
                     (progn
                       (rename-file file new-name)
                       (setq pasted-count (1+ pasted-count))
                       (setq file-tree--clipboard nil)) ; Clear clipboard after successful move
                   (error
                    (message "Move failed: %s" (error-message-string err))
                    (setq file-tree--clipboard nil)))))))

      (file-tree-refresh)
      (if (> pasted-count 0)
          (message "Pasted %d files" pasted-count)
        (message "Paste failed")))))


(defun file-tree--generate-unique-filename (filename directory)
  "Generate a unique filename in DIRECTORY based on FILENAME by appending -COPY.
If the filename already exists, appends -COPY before the extension.
If that also exists, appends -COPY-2, -COPY-3, etc."
  (let* ((base (file-name-sans-extension filename))
         (extension (file-name-extension filename))
         (counter 1)
         (new-filename filename)
         (full-path))

    (while (file-exists-p (setq full-path (expand-file-name new-filename directory)))
      ;; Always use the original base name for numbering, not the current new-filename
      (setq new-filename (if extension
                           (format "%s-COPY-%d.%s" base counter extension)
                         (format "%s-COPY-%d" base counter)))
      (setq counter (1+ counter)))

    full-path))

(defun file-tree--delete-file ()
  "Delete file at point after confirmation."
  (interactive)
  (let ((path (plist-get (file-tree--get-file-at-point) :path))
        (name (plist-get (file-tree--get-file-at-point) :name)))
    (when (yes-or-no-p (format "Delete '%s'? " name))
      (if (file-directory-p path)
          (delete-directory path t)
        (delete-file path))
      (file-tree-refresh)
      (message "Deleted: %s" name))))

(defun file-tree--copy-path ()
  "Copy absolute path of file at point."
  (interactive)
  (let ((path (plist-get (file-tree--get-file-at-point) :path)))
    (kill-new path)
    (message "Copied path: %s" path)))

(defun file-tree--copy-relative-path ()
  "Copy relative path of file at point from root directory."
  (interactive)
  (let ((path (plist-get (file-tree--get-file-at-point) :path)))
    (kill-new (file-relative-name path file-tree--root-directory))
    (message "Copied relative path")))

;; Keymaps
(defvar file-tree-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'file-tree--open-file)
    (define-key map (kbd "TAB") 'file-tree--toggle-expand)
    (define-key map (kbd "C") 'file-tree--copy-file)
    (define-key map (kbd "X") 'file-tree--cut-file)
    (define-key map (kbd "V") 'file-tree--paste-file)
    (define-key map (kbd "R") 'file-tree--start-rename)
    (define-key map (kbd "D") 'file-tree--delete-file)
    (define-key map (kbd "g") 'file-tree-refresh)
    (define-key map (kbd "q") 'file-tree-quit)
    ;; Resize keys
    (define-key map (kbd "M-+") 'file-tree-increase-width)
    (define-key map (kbd "M--") 'file-tree-decrease-width)
    (define-key map (kbd "M-=") 'file-tree-reset-width)
    (define-key map [mouse-1] 'file-tree--handle-click)
    (define-key map [mouse-3] 'file-tree--context-menu)
    map)
  "Keymap for file-tree-mode.")

;; Major mode
(define-derived-mode file-tree-mode special-mode "File Tree"
  "Major mode for the file tree."
  (setq-local widget-keymap nil)
  (use-local-map file-tree-mode-map)
  (setq truncate-lines t)
  (setq cursor-type nil)
  (setq show-trailing-whitespace nil)
  (setq buffer-face-mode `(:family "Monospace" :height 100)))

(defun file-tree--handle-click (event)
  "Handle mouse click EVENT in file tree."
  (interactive "e")
  (let ((pos (posn-point (event-end event))))
    (goto-char pos)
    (cond
     ;; Header button click
     ((get-text-property pos 'action)
      (funcall (get-text-property pos 'action)))
     ;; Directory click - expand/collapse
     ((get-text-property pos 'directory-p)
      (file-tree--toggle-expand pos))
     ;; File click - open file
     ((get-text-property pos 'file-path)
      (file-tree--open-file))
     (t
      (message "Click not on a file or directory")))))

;; Sidebar window management
(defun file-tree--setup-sidebar-window (buffer)
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
      (window-resize window (- file-tree--sidebar-width (window-width window)) t)
      window)))

;; Main interface functions
(defun file-tree-refresh ()
  "Refresh the file tree view."
  (interactive)
  (let ((buffer (get-buffer file-tree--buffer-name)))
    (when buffer
      (with-current-buffer buffer
        (let ((inhibit-read-only t)
              (current-line (line-number-at-pos))
              (current-file (get-text-property (point) 'file-path)))
          (erase-buffer)
          (file-tree--insert-header)
          (file-tree--insert-tree file-tree--root-directory)
          (read-only-mode 1)
          
          ;; Try to restore cursor position
          (when current-file
            (goto-char (point-min))
            (when (search-forward (file-name-nondirectory current-file) nil t)
              (beginning-of-line)))
          (when (> current-line 1)
            (forward-line (1- current-line))))))))

(defun file-tree--collapse-all ()
  "Collapse all expanded directories."
  (interactive)
  (setq file-tree--expanded-nodes nil)
  (file-tree-refresh))

(defun file-tree-quit ()
  "Quit the file tree sidebar."
  (interactive)
  (let ((window (get-buffer-window file-tree--buffer-name)))
    (when window
      (delete-window window))
    (kill-buffer file-tree--buffer-name)))

(defun file-tree-toggle ()
  "Toggle the file tree sidebar."
  (interactive)
  (if (get-buffer-window file-tree--buffer-name)
      (file-tree-quit)
    (file-tree default-directory)))

;;;###autoload
(defun file-tree (directory)
  "Open file tree for DIRECTORY as sidebar."
  (interactive "DDirectory: ")
  (setq file-tree--root-directory (expand-file-name directory))
  (setq file-tree--expanded-nodes nil)
  (let ((buffer (file-tree--create-buffer)))
    (file-tree--setup-sidebar-window buffer)
    (file-tree-refresh)))

;; Global keybindings for resize (optional)
(global-set-key (kbd "M-+") 'file-tree-increase-width)
(global-set-key (kbd "M--") 'file-tree-decrease-width)
(global-set-key (kbd "M-=") 'file-tree-reset-width)

(provide 'file-tree)