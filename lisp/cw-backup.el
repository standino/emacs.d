(setq backup-directory-alist '(("" . "~/../../backup/emacs/backup")))
(setq-default make-backup-file t)
(setq make-backup-file t)

(setq make-backup-files t)
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 10)
(setq delete-old-versions t)

;;;back up options
;(setq backup-directory-alist (quote (("." . "~/backups")))) 
;(setq version-control t)
;(setq kept-old-versions 2)
;(setq kept-new-versions 5)
;(setq delete-old-versions t)


;;;backup files
;(setq make-backup-files t)
;(setq version-control t)
;(setq kept-old-versions 2)
;(setq kept-new-versions 5)
;(setq delete-old-versions t)
;(setq backup-directory-alist '(("." . "~/emacs/backup")))
;(setq backup-by-copying t)
(provide 'cw-backup)
