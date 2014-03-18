(defun djcb-duplicate-line (&optional commentfirst)
  "comment line at point; if COMMENTFIRST is non-nil, comment the original"
  (interactive)
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (let ((str (buffer-substring (region-beginning) (region-end))))
    (when commentfirst
      (comment-region (region-beginning) (region-end)))
    (insert-string
     (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
    (forward-line -1)))

;; or choose some better bindings....

;; duplicate a line
(global-set-key (kbd "C-c y") 'djcb-duplicate-line)

;; duplicate a line and comment the first
(global-set-key (kbd "C-c c") (lambda()(interactive)(djcb-duplicate-line t)))


;; 当backspace用
(keyboard-translate ?\C-h ?\C-?)

(defun cygwin-or-linux (cyg ln)
  "cyg is the function for cygwin, ln is the function for linux."
  (interactive)
  (if (equal system-type 'cygwin)
      (if cyg (funcall cyg))
    )
  (if (equal system-type 'windows-nt)
      (if cyg (funcall cyg))
    )
  (if (equal system-type 'gnu/linux)
      (if ln (funcall ln))
    )

  )

(defun cygwin-do (fn)
  " only run for cygwin"
  (interactive)
  (if (equal system-type 'cygwin)
      (if fn (funcall fn))
    )
  )

(defun win-do (fn)
  " only run for win"
  (interactive)
  (if (equal system-type 'windows-nt)
      (if fn (funcall fn))
    )
  )

(defun linux-do (fn)
  " only run for linux"
  (interactive)

  (if (equal system-type 'gnu/linux)
      (if fn (funcall fn))
    )

  )
;;上下分屏
;;(setq split-width-threshold most-positive-fixnum)

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (indent-buffer))

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))
;;启动调试信息
;;(setq debug-on-error t)

;;(require 'pretty-mode)
;;(global-pretty-mode 1)

(require 'init-reminder)
(require 'init-hotkey)
(require 'cw-nxhml)
(require 'cw-load-path)
(require 'cw-file)
(require 'cw-backup)
(require 'cw-mysql)
(require 'init-org-page)
(require 'init-dict)
(org-agenda nil  "a")

(provide 'init-local)
