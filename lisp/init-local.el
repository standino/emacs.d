;;; key
(global-set-key "\C-z" 'set-mark-command)

(set-language-environment 'utf-8)
(prefer-coding-system 'gb2312)
;;(prefer-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'gb2312)
(set-buffer-file-coding-system 'utf-8)

;;; path
(setq my-idea-home "~/ideas/")
(setq my-emacs-home "~/ideas/emacs/")
(add-to-list 'load-path (concat my-emacs-home "lib"))



(defun cw/open-host-file ()
   (interactive)
   (find-file (concat "/cygdrive/c/Windows/System32/drivers/etc/"  "hosts"))
 )

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

(require 'init-reminder)
(require 'init-hotkey)
(require 'cw-nxhml)
(require 'cw-load-path)
(require 'cw-file)
(require 'cw-muse)

(provide 'init-local)