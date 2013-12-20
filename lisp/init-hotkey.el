;;; Hotkey options
(defalias 'tt 'toggle-truncate-lines)
(defalias 'yas  'yas/expand)
(defalias 'sql-org-table 'org-table-create-or-convert-from-region)
(defalias 'sql-org-next  'orgtbl-tab)
(global-set-key "\C-z" 'set-mark-command)
(global-set-key (kbd "C-c t") 'org-table-create-or-convert-from-region)
(global-set-key (kbd "C-c n") 'orgtbl-tab)

(global-set-key "\C-o" 'scroll-down)
;;(global-set-key "\C-i" 'my-tab)
(global-set-key [(f3)] 'dired)
(global-set-key [(f4)] 'eshell)
(global-set-key [(f8)] 'highlight-symbol-at-point)

(global-set-key (kbd "<f9>") 'list-bookmarks)
(global-set-key [(f10)] 'bookmark-set)
(global-set-key [(f11)] 'fullscreen)

;;(define-key global-map (kbd "C-c f") 'wy-go-to-char)
;;(define-key global-map (kbd "C-c b") 'my-back-to-char)
;;
;;(global-set-key [(control ?\.)] 'ska-point-to-register)
;;(global-set-key [(control ?\,)] 'ska-jump-to-register)
;;(global-set-key (kbd "M-X") 'anything)
;;
;;(keyboard-translate ?\C-h ?\C-?)
;;(global-set-key (kbd "M-8") 'extend-selection)
;;(global-set-key (kbd "M-*") 'select-text-in-quote)

(provide 'init-hotkey)
