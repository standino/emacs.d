;;; custom display options
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(tool-bar-mode nil))

(set-language-environment 'utf-8)
(prefer-coding-system 'gb2312)
;;(prefer-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'gb2312)
(set-buffer-file-coding-system 'utf-8) 

(setq visible-bell t)
(setq tab-width 4)
(fset 'yes-or-no-p 'y-or-n-p)
(require 'hl-line)
(global-hl-line-mode t)
;;use space instead of tab
(setq-default indent-tabs-mode nil) 



;;(require 'tabbar)
;;(setq tabbar-speedkey-use t)
;;(setq tabbar-speedkey-prefix (kbd "<f1>"))
;;(tabbar-mode 1)
;;(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

;;Enable Auto Fill mode
(setq-default fill-column 130)
;;(setq auto-fill-mode 1)




;;(custom-set-faces
;;'(tabbar-default-face
;;((t (:inherit variable-pitch
;;:background "gray90"
;;:foreground "gray60"
;;:height 0.8))))
;;'(tabbar-selected-face
;;((t (:inherit tabbar-default-face
;;:foreground "darkred"
;;:box (:line-width 2 :color "white" :style pressed-button)))))
;;'(tabbar-unselected-face
;;((t (:inherit tabbar-default-face
;;:foreground "black"
;;:box (:line-width 2 :color "white" :style released-button))))))
;;


(show-paren-mode t)

; add more hooks here(toggle-uniquify-buffer-names)
(toggle-uniquify-buffer-names)
(setq-default abbrev-mode t)

(setq-default truncate-lines t)
;;;Server option
;;(server-start)


;;;for high-lighting
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
;
;; (mouse-wheel-mode 1)
;;;make yes/no to y/n
(fset 'yes-or-no-p 'y-or-n-p)
;;; display time
;;(setq display-time-24hr-format t)
;;(setq display-time-day-and-date t)
;;(setq display-time-use-mail-icon t)
;;(setq display-time-interval 10)
;;(display-time)
;;; display colum number
(column-number-mode t)
;;; high-light the select area
(transient-mark-mode t)
;;;make big area copy quick
(setq lazy-lock-defer-on-scrolling t)
;;(setq font-lock-support-mode 'lazy-lock-mode)
(setq font-lock-maximum-decoration t)
;;; disable welcome screen
(setq inhibit-startup-message t)
;
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)


(setq time-stamp-format "%:y-%02m-%02d %3a %02H:%02M:%02S Will")

;; ;; Support for marking a rectangle of text with highlighting.
;; (define-key ctl-x-map "r\C-z" 'rm-set-mark)
;; (define-key ctl-x-map [?r ?\C-\ ] 'rm-set-mark)
;; (define-key ctl-x-map "r\C-x" 'rm-exchange-point-and-mark)
;; (define-key ctl-x-map "r\C-w" 'rm-kill-region)
;; (define-key ctl-x-map "r\M-w" 'rm-kill-ring-save)
;; (define-key global-map [S-down-mouse-1] 'rm-mouse-drag-region)
;; (autoload 'rm-set-mark "rect-mark"
;;   "Set mark for rectangle." t)
;; (autoload 'rm-exchange-point-and-mark "rect-mark"
;;   "Exchange point and mark for rectangle." t)
;; (autoload 'rm-kill-region "rect-mark"
;;   "Kill a rectangular region and save it in the kill ring." t)
;; (autoload 'rm-kill-ring-save "rect-mark"
;;   "Copy a rectangular region to the kill ring." t)
;; (autoload 'rm-mouse-drag-region "rect-mark"
;;   "Drag out a rectangular region with the mouse." t)

(setq x-select-enable-clipboard t) 
(setq frame-title-format "%n%F/%b")

(setq kill-ring-max 200) 

(desktop-save-mode 1)

(my-require 'dtrt-indent)
(dtrt-indent-mode 1)
;;(my-require 'maxframe)
;;(defun x-maximize-frame ()
;;             "Maximize the current frame (x or mac only)"
;;             (interactive)
;;             (mf-set-frame-pixel-size (selected-frame)
;;                                      (display-pixel-width)
;;                                      (display-pixel-height))
;;             (set-frame-position (selected-frame) 0 0))
;;

(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

(defun ui-for23()
;;  (create-fontset-from-fontset-spec
;;   "-*-*-medium-r-normal-*-17-*-*-*-*-*-fontset-courier")
;;  (set-frame-font "fontset-courier")
;;  (setq default-frame-alist
;;		(append
;;		 '((font . "fontset-courier")) default-frame-alist))
;;  
;;  
;;  (set-fontset-font
;;   "fontset-default" nil
;;   "-*-simsun-*-*-*-*-14-*-*-*-*-*-gb2312.1980-*" nil 'prepend)
;;  (set-fontset-font
;;   "fontset-courier" 'kana
;;   "-*-simsun-*-*-*-*-14-*-*-*-*-*-gbk-0" nil 'prepend)
;;  (set-fontset-font
;;   "fontset-courier" 'han
;;   "-*-simsun-*-*-*-*-14-*-*-*-*-*-gbk-0" nil 'prepend)
;;  (set-fontset-font
;;   "fontset-courier" 'cjk-misc
;;   "-*-simsun-*-*-*-*-14-*-*-*-*-*-gbk-0" nil 'prepend)
  
  (setq split-width-threshold most-positive-fixnum)
  )




;;TODO
;;(idle-highlight)

(linux-do
 (lambda()
   (ui-for23)
 )
)
;;(cygwin-or-linux
;; (lambda()
;;           (fullscreen)
;;   )
 
;;)

(defun cw/run-on-laptop()
;;      (set-frame-font "Monaco-10")
	 ;; (zone-leave-me-alone)
  (setq split-width-threshold most-positive-fixnum)
)

(defun cw/do-when-window-system ()

  (message "system name : %s" (system-name))
  (when window-system
    (if (or
         (string= (system-name) "BJXX-CHANGWEI")
         (string= (system-name) "ian-home"))
		  (cw/run-on-laptop)
;;     (set-frame-font "Monaco-10") )
;;(set-fontset-font (frame-parameter nil 'font)
;;    'han '("Microsoft YaHei-12" . "unicode-bmp")
)

)
)

(cw/do-when-window-system)
(provide 'cw-ui)
