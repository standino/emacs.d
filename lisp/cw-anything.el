(my-require-or-install 'anything)
(my-require-or-install 'anything-config)
(my-require-or-install 'anything-match-plugin)
(my-require-or-install 'anything-adaptive)
(my-require-or-install 'anything-obsolete)
;;(my-require-or-install 'anything-complete)
;;(my-require-or-install 'anything-dabbrev-expand)
(my-require-or-install 'descbinds-anything)
;;(my-require-or-install 'anything-gtags)
;;(my-require-or-install 'anything-migemo)
;;(my-require-or-install 'anything-rcodetools)
;;(global-set-key (kbd "M-y")
;;                '(lambda ()
;;                   (interactive)
;;                   (let ((anything-enable-digit-shortcuts nil))
;;                     (anything-show-kill-ring))))
(global-set-key (kbd "M-%") 'anything-query-replace-regexp)
(require 'anything)
(require 'anything-config)
(setq anything-sources
      (list anything-c-source-imenu
		anything-c-source-locate 
		anything-c-source-buffers
		anything-c-source-file-name-history
;;		anything-c-source-gtags-select
		anything-c-source-file-cache
		anything-c-source-emacs-commands
		anything-c-source-info-pages
		anything-c-source-man-pages
		)
		)

(global-set-key (kbd "M-X") 'anything)


(provide 'cw-anything)
