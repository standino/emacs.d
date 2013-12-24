(setq backup-directory-alist '(("" . "~/backup/emacs/backup")))
(setq-default make-backup-file t)
(setq make-backup-file t)

(setq make-backup-files t)
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 10)
(setq delete-old-versions t)


(provide 'cw-backup)
