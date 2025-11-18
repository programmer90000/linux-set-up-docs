(defgroup undo-fu nil
  "Configure default behavior for undo-fu wrapper."
  :group 'undo)

(defcustom undo-fu-allow-undo-in-region nil
  "When non-nil, use `undo-in-region' when a selection is present.
Otherwise `undo-in-region' is never used, since it doesn't support `undo-only',
causing undo-fu to work with reduced functionality when a selection exists."
  :type 'boolean)

(defcustom undo-fu-ignore-keyboard-quit nil
  "When non-nil, don't use `keyboard-quit' to disable linear undo/redo behavior.

Instead, explicitly call `undo-fu-disable-checkpoint'."
  :type 'boolean)

(defvar-local undo-fu--respect t)
(defvar-local undo-fu--in-region nil)
(defvar-local undo-fu--was-redo nil)
(defconst undo-fu--commands
  '(undo-fu-only-undo undo-fu-only-redo-all undo-fu-only-redo undo-fu-disable-checkpoint))

(defun undo-fu--backport-undo--last-change-was-undo-p (undo-list)
  "Return the last changed undo step in UNDO-LIST."
  (declare (important-return-value t))
  (while (and (consp undo-list) (eq (car undo-list) nil))
    (setq undo-list (cdr undo-list)))
  (gethash undo-list undo-equiv-table))

(defun undo-fu--backport-undo-redo (&optional arg)
  "Undo the last ARG undos."
  (declare (important-return-value nil))
  (interactive "*p")
  (cond
   ((not (undo-fu--backport-undo--last-change-was-undo-p buffer-undo-list))
    (user-error "No undone changes to redo"))
   (t
    (let* ((ul buffer-undo-list)
           (new-ul
            (let ((undo-in-progress t))
              (while (and (consp ul) (eq (car ul) nil))
                (setq ul (cdr ul)))
              (primitive-undo (or arg 1) ul)))
           (new-pul (undo-fu--backport-undo--last-change-was-undo-p new-ul)))
      (message "Redo%s"
               (cond
                (undo-in-region
                 " in region")
                (t
                 "")))
      (setq this-command 'undo)
      (setq pending-undo-list new-pul)
      (setq buffer-undo-list new-ul)))))

(defun undo-fu--checkpoint-disable ()
  "Disable using the checkpoint.

This allows the initial boundary to be crossed when redoing."
  (declare (important-return-value nil))
  (setq undo-fu--respect nil)
  (setq undo-fu--in-region nil))

(defmacro undo-fu--with-advice (advice &rest body)
  "Execute BODY with ADVICE temporarily enabled.

Advice are triplets of (SYMBOL HOW FUNCTION),
see `advice-add' documentation."
  (declare (indent 1))
  (let ((advice-list advice)
        (body-let nil)
        (body-advice-add nil)
        (body-advice-remove nil)
        (item nil))
    (unless (listp advice-list)
      (error "Advice must be a list"))
    (cond
     ((null advice-list)
      (error "Advice must be a list containing at least one item"))
     (t
      (while (setq item (pop advice-list))
        (unless (and (listp item) (eq 3 (length item)))
          (error "Each advice must be a list of 3 items"))
        (let ((fn-sym (gensym))
              (fn-advise (pop item))
              (fn-advice-ty (pop item))
              (fn-body (pop item)))
          (push (list fn-sym fn-body) body-let)
          (push (list 'advice-add fn-advise fn-advice-ty fn-sym) body-advice-add)
          (push (list 'advice-remove fn-advise fn-sym) body-advice-remove)))
      (setq body-let (nreverse body-let))
      (setq body-advice-add (nreverse body-advice-add))

      `(let ,body-let
         (unwind-protect
             (progn
               ,@body-advice-add
               ,@body)
           ,@body-advice-remove))))))

(defmacro undo-fu--with-message-suffix (suffix &rest body)
  "Add text after the message output.
Argument SUFFIX is the text to add at the start of the message.
Optional argument BODY runs with the message suffix."
  (declare (indent 1))
  `(undo-fu--with-advice ((#'message
                           :around
                           (lambda (fn-orig arg &rest args)
                             (apply fn-orig
                                    (append (list (concat arg "%s")) args (list ,suffix))))))
     ,@body))

(defmacro undo-fu--with-messages-as-non-repeating-list (message-list &rest body)
  "Run BODY adding any message call to the MESSAGE-LIST list."
  (declare (indent 1))
  `(let ((temp-message-list (list)))
     (undo-fu--with-advice ((#'message
                             :around
                             (lambda (_ &rest args)
                               (when message-log-max
                                 (let ((message-text (apply #'format-message args)))
                                   (unless (equal message-text (car temp-message-list))
                                     (push message-text temp-message-list)))))))
       (unwind-protect
           (progn
             ,@body)
         (setq ,message-list (append ,message-list (nreverse temp-message-list)))))))

(defun undo-fu--undo-enabled-or-error ()
  "Raise a user error when undo is disabled."
  (declare (important-return-value nil))
  (when (eq t buffer-undo-list)
    (user-error "Undo has been disabled!")))

(defun undo-fu--was-undo-or-redo ()
  "Return t when the last destructive action was undo or redo."
  (declare (important-return-value t))
  (cond
   ((undo-fu--backport-undo--last-change-was-undo-p buffer-undo-list)
    t)
   (t
    nil)))

(defun undo-fu-disable-checkpoint ()
  "Remove the undo-fu checkpoint, making all future actions unconstrained.

This command is needed when `undo-fu-ignore-keyboard-quit' is t,
since in this case `keyboard-quit' cannot be used
to perform unconstrained undo/redo actions."
  (declare (important-return-value nil))
  (interactive)
  (cond
   ((not (undo-fu--was-undo-or-redo))
    (message "Undo checkpoint disabled for next undo action!"))
   ((not undo-fu--respect)
    (message "Undo checkpoint already cleared!"))
   (t
    (message "Undo checkpoint cleared!")))

  (undo-fu--checkpoint-disable))

(defun undo-fu-only-redo-all ()
  "Redo all actions until the initial undo step.

wraps the `undo' function."
  (declare (important-return-value nil))
  (interactive "*")
  (undo-fu--undo-enabled-or-error)
  (let ((message-list (list)))
    (undo-fu--with-messages-as-non-repeating-list message-list
      (while (undo-fu--was-undo-or-redo)
        (undo-fu--backport-undo-redo 1)))
    (dolist (message-text message-list)
      (message "%s All" message-text)))
  (setq this-command 'undo-fu-only-redo)
  (setq undo-fu--was-redo t))

(defun undo-fu-only-redo (&optional arg)
  "Redo an action until the initial undo action.

wraps the `undo' function.

Optional argument ARG The number of steps to redo."
  (declare (important-return-value nil))
  (interactive "*p")
  (undo-fu--undo-enabled-or-error)

  (let* ((was-undo-or-redo (undo-fu--was-undo-or-redo))
         (was-redo (and was-undo-or-redo undo-fu--was-redo))
         (was-undo (and was-undo-or-redo (null was-redo)))
         (undo-fu-quit-command
          (cond
           (undo-fu-ignore-keyboard-quit
            'undo-fu-disable-checkpoint)
           (t
            'keyboard-quit))))

    (unless undo-fu--respect
      (unless was-undo-or-redo
        (when undo-fu-allow-undo-in-region
          (setq undo-fu--in-region nil))
        (setq undo-fu--respect t)))

    (when (region-active-p)
      (cond
       (undo-fu-allow-undo-in-region
        (message "Undo in region in use. Undo checkpoint ignored!")
        (undo-fu--checkpoint-disable)
        (setq undo-fu--in-region t))
       (t
        (deactivate-mark))))

    (when undo-fu--respect
      (when (memq last-command (list undo-fu-quit-command 'undo-fu-disable-checkpoint))
        (undo-fu--checkpoint-disable)
        (message "Redo checkpoint stepped over!")))

    (when undo-fu--respect
      (when (null was-undo-or-redo)
        (user-error "Redo without undo step (%s to ignore)"
                    (substitute-command-keys
                     (format "\\[%s]" (symbol-name undo-fu-quit-command))))))

    (let* ((steps
            (cond
             ((numberp arg)
              arg)
             (t
              1)))
           (last-command
            (cond
             (was-undo
              'ignore)
             (was-redo
              'undo)
             ((string-equal last-command 'keyboard-quit)
              'ignore)
             (t
              last-command)))
           (success
            (condition-case err
                (progn
                  (cond
                   (undo-fu--respect
                    (undo-fu--backport-undo-redo steps))
                   (t
                    (undo-fu--with-message-suffix " (unconstrained)"
                      (let ((undo-no-redo nil))
                        (undo steps)))))
                  t)
              (error
               (progn
                 (message "%s" (error-message-string err))
                 nil)))))

      (when success
        (setq undo-fu--was-redo t))

      (setq this-command 'undo-fu-only-redo)
      success)))

(defun undo-fu-only-undo (&optional arg)
  "Undo the last action.

wraps the `undo-only' function.

Optional argument ARG the number of steps to undo."
  (declare (important-return-value nil))
  (interactive "*p")
  (undo-fu--undo-enabled-or-error)

  (let* ((was-undo-or-redo (undo-fu--was-undo-or-redo))
         (was-redo (and was-undo-or-redo undo-fu--was-redo))
         (undo-fu-quit-command
          (cond
           (undo-fu-ignore-keyboard-quit
            'undo-fu-disable-checkpoint)
           (t
            'keyboard-quit))))

    (unless undo-fu--respect
      (unless was-undo-or-redo
        (when undo-fu-allow-undo-in-region
          (setq undo-fu--in-region nil))
        (setq undo-fu--respect t)))

    (when (region-active-p)
      (cond
       (undo-fu-allow-undo-in-region
        (message "Undo in region in use. Undo checkpoint ignored!")
        (undo-fu--checkpoint-disable)
        (setq undo-fu--in-region t))
       (t
        (deactivate-mark))))

    (when undo-fu--respect
      (when (memq last-command (list undo-fu-quit-command 'undo-fu-disable-checkpoint))
        (undo-fu--checkpoint-disable)
        (message "Undo checkpoint ignored!")))

    (let* ((steps (or arg 1))
           (last-command
            (cond
             ((and was-redo (null undo-fu--respect) (eq t pending-undo-list))
              'ignore)
             (was-undo-or-redo
              'undo)
             (t
              last-command)))
           (success
            (condition-case err
                (progn
                  (cond
                   ((and undo-fu--respect (not undo-fu--in-region))
                    (undo-only steps))
                   (t
                    (undo-fu--with-message-suffix " (unconstrained)"
                      (let ((undo-no-redo nil))
                        (undo steps)))))
                  t)
              (error
               (progn
                 (message "%s" (error-message-string err))
                 nil)))))

      (when success
        (setq undo-fu--was-redo nil))

      (setq this-command 'undo-fu-only-undo)
      success)))

(defun undo-fu-clear-all ()
  "Clear all undo/redo steps."
  (interactive)
  (setq buffer-undo-list nil)
  (setq pending-undo-list nil)
  (clrhash undo-equiv-table))


(defvar aggressive-indent-protected-commands)
(with-eval-after-load 'aggressive-indent
  (nconc aggressive-indent-protected-commands undo-fu--commands))

(provide 'undo-fu)