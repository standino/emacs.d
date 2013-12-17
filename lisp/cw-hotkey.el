;;; Hotkey options
(defalias 'tt 'toggle-truncate-lines)
(defalias 'yas  'yas/expand)
(defalias 'sql-org-table 'org-table-create-or-convert-from-region)
(defalias 'sql-org-next  'orgtbl-tab)
(global-set-key "\C-z" 'set-mark-command)
(global-set-key (kbd "C-c t") 'org-table-create-or-convert-from-region)
(global-set-key (kbd "C-c n") 'orgtbl-tab)

(global-set-key (kbd "M-[") 'tabbar-backward-group)
(global-set-key (kbd "M-]") 'tabbar-forward-group)
(global-set-key (kbd "M-p") 'tabbar-backward-tab)
(global-set-key (kbd "M-n") 'tabbar-forward-tab)

(global-set-key (quote [C-S-down]) 'tabbar-backward-group)  
(global-set-key (quote [C-S-up]) 'tabbar-forward-group)  
(global-set-key (quote [C-S-left]) 'tabbar-backward)  
(global-set-key (quote [C-S-right]) 'tabbar-forward)  
(global-set-key (kbd "C-`") 'tabbar-backward-tab) 
;;(global-set-key (kbd "C-<tab>") 'tabbar-forward)

;; 热键设置
;; 用WIN键和j,k,n,p,鼠标来转换tab
;; WIN+j或WIN+鼠标左键: 左tab
;; WIN+k或WIN+鼠标右键: 右tab
;; WIN+p或WIN+鼠标滚轮上滚: 上一个组
;; WIN+n或WIN+鼠标滚轮下滚: 下一个组

;; move to previous group
;;(global-set-key (kbd "s-p") 'tabbar-backward-group)
;;(global-set-key [s-mouse-4] 'tabbar-backward-group)
;;
;;;; move to next group
;;(global-set-key (kbd "s-n") 'tabbar-forward-group)
;;(global-set-key [s-mouse-5] 'tabbar-forward-group)
;;
;;;; move to the left tab
;;(global-set-key (kbd "s-j") 'tabbar-backward)
;;(global-set-key [s-mouse-1] 'tabbar-backward)
;;
;;;; move to the right tab
;;(global-set-key (kbd "s-k") 'tabbar-forward)
;;(global-set-key [s-mouse-3] 'tabbar-forward)
;;
;;;; 组内循环滚动tab
;;(setq tabbar-cycling-scope (quote tabs))

(global-set-key "\C-o" 'scroll-down)
(global-set-key "\C-i" 'my-tab)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key [(f3)] 'dired)
(global-set-key [(f4)] 'eshell)
(global-set-key [(f5)] 'gtd)
(global-set-key [(f6)] 'my-dired-to-jd)
(global-set-key [(f7)] 'my-dired-to-standino)
;;(global-set-key [(f8)] 'highlight-symbol-at-point)

(global-set-key (kbd "<f9>") 'list-bookmarks)
(global-set-key [(f10)] 'bookmark-set)
(global-set-key [(f11)] 'fullscreen)

(global-set-key [(control tab)] 'my-indent-or-complete)

(global-set-key (kbd "C-x C-b") 'ibuffer)

;;(global-set-key [(meta ?/)] 'hippie-expand)

(define-key global-map (kbd "C-c f") 'wy-go-to-char)
(define-key global-map (kbd "C-c b") 'my-back-to-char)

(global-set-key [(control ?\.)] 'ska-point-to-register)
(global-set-key [(control ?\,)] 'ska-jump-to-register)
(global-set-key (kbd "M-X") 'anything)

(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "M-8") 'extend-selection)
(global-set-key (kbd "M-*") 'select-text-in-quote)


(defun start-eclipse ()
  "open eclipse"
  (interactive)
  (shell-command  "d:/JD/ideas/bin/startEclipse.bat &")

)


(provide 'cw-hotkey)
