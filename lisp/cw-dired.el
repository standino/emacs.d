;;(case system-type
;;        (darwin (require 'w32-browser))
;; )


(defun my-dired-to-standino()
  (interactive)
  (dired my-idea-home))

(defun my-dired-to-jd()
  (interactive)
  (dired "d:/JD/projects/"))

(defun my-dired-to-dsw()
  (interactive)
  (case system-type
    (gnu/linux (dired "/home/will/willATibm/quote/")) ;right for gnome (ubuntu), not for other systems
    (cygwin  (dired "/quote/head"))
    )
  )



;;; Hack dired to launch files with 'l' key.  Put this in your ~/.emacs file

(defun dired-launch-command ()
  (interactive)
  (dired-do-shell-command
   (case system-type
     (gnu/linux "gnome-open") ;right for gnome (ubuntu), not for other systems
     (darwin "open"))
   nil
   (dired-get-marked-files t current-prefix-arg)))

(setq dired-load-hook
      (lambda (&rest ignore)
        (define-key dired-mode-map
          "l" 'dired-launch-command)))

;;(my-require-or-install 'nc)
;;(autoload 'nc "nc" "Emulate MS-DOG file shell" t)
(provide 'cw-dired)
