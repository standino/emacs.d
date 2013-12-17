;;; cw-tags.el --- xtags

;; Copyright (C) 2009  Will

;; Author: Will <will@will-laptop>
;; Keywords: abbrev

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; use tags ;;
;; cw-tags.el
;; 
;; Made by Will
;; Login   <will@will-laptop>
;; 
;; Started on  Fri Oct 23 22:44:00 2009 Will
;; Last update Wed Dec 23 13:47:49 2009 Will
;;


;;; Code:
;; wget -c  http://hi.chinaunix.net/attachments/2009/04/20600316_200904172238001MulC.attach -O xgtags.el 

(require 'xgtags)
(require 'xgtags-extension)

(add-hook
 'c-mode-common-hook
 (lambda ()

   (xgtags-mode 1)

   ;; c base mode keys
   ;; 
   (define-key c-mode-base-map [f7] 'sucha-generate-gtags-files)
   (define-key c-mode-base-map [(meda .)] 'xgtags-find-symbol)
   (define-key c-mode-base-map (kbd "M-p") 'xgtags-pop-stack))
t)

(defun sucha-generate-gtags-files ()
  "Generate gtags reference file for global."
  (interactive)
  (cd
   (read-from-minibuffer
    "directory: "
    default-directory))
  (shell-command "gtags --gtagslabel gtags")
  (xgtags-make-complete-list))

;; xgtags mode map
;; 
(define-key xgtags-mode-map [(control .)] 'xgtags-find-tag-from-here)
(define-key xgtags-mode-map [(control ,)] 'delete-other-windows)
(define-key xgtags-mode-map [(meta .)] 'xgtags-find-symbol)
(define-key xgtags-mode-map [(meta ,)] 'xgtags-find-pattern)
(define-key xgtags-mode-map (kbd "C-M-.") 'xgtags-find-rtag)
(define-key xgtags-mode-map (kbd "C-M-,") 'grep-find)
(define-key xgtags-mode-map (kbd "C-M-/") 'xgtags-find-tag)
(define-key xgtags-mode-map (kbd "M-p") 'xgtags-pop-stack)


;; xgtags-select-mode-hook
;; 
(add-hook
 'xgtags-select-mode-hook
 '(lambda ()
    (define-key xgtags-select-mode-map [(control f)] 'forward-char)
    (define-key xgtags-select-mode-map [(control b)] 'backward-char)
    (define-key xgtags-select-mode-map [(meta p)] 'xgtags-pop-stack)
    (define-key xgtags-select-mode-map (kbd "SPC")
      'sucha-xgtags-select-tag-other-window))
 )

(defun sucha-xgtags-select-tag-other-window ()
  "Selete gtag tag other window."
  (interactive)
  (xgtags-select-tag-near-point)
  (delete-other-windows)
  (split-window-vertically 12)
  (switch-to-buffer "*xgtags*"))

(custom-set-faces

 ;; xgtags faces
 ;; 
 '(xgtags-file-face ((t (:foreground "salmon3" :weight bold))))
 '(xgtags-match-face ((((class color) (background dark)) (:foreground "green3"))))
 '(xgtags-line-number-face ((((class color) (background dark)) (:foreground "maroon3"))))
 '(xgtags-line-face ((((class color) (background dark)) (:foreground "yellow3"))))
 '(xgtags-file-selected-face ((t (:foreground "salmon3" :weight bold))))
 '(xgtags-match-selected-face ((t (:foreground "green2" :weight bold))))
 '(xgtags-line-selected-face ((t (:foreground "yellow2" :weight bold))))
 '(xgtags-line-number-selected-face ((t (:foreground "maroon2" :weight bold))))
)

;; company mode, better completion
;; 
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/elpa/company-0.4.3/"))
(autoload 'company-mode "company" nil t)
;;(require 'company)
;;(require 'company-bundled-completions)  ; mass install
;;(require 'company-gtags-completions)
(setq company-idle-delay t)
(setq company-minimum-prefix-length 1)
;; 我自己的 completion rules
;;
(defun sucha-install-company-completion-rules ()
  "gtags and dabbref completions for C and C++ mode"
  (company-clear-completion-rules)
   (company-install-dabbrev-completions)
  (company-install-file-name-completions)
  (eval-after-load 'company-gtags-completions
    '(company-install-gtags-completions))
  )

(add-hook
 'c-mode-common-hook
 (lambda ()

   (company-mode 1)
   (sucha-install-company-completion-rules) ; refers to the function
 )
t)

;;(dolist (hook (list
;;
;;               'emacs-lisp-mode-hook
;;
;;               'lisp-mode-hook
;;
;;               'lisp-interaction-mode-hook
;;
;;               'scheme-mode-hook
;;
;;               'c-mode-common-hook
;;
;;               'python-mode-hook
;;
;;               'haskell-mode-hook
;;
;;               'asm-mode-hook
;;
;;               'emms-tag-editor-mode-hook
;;			   'sql-mode-hook
;;               'sh-mode-hook))
;;
;;  (add-hook hook (lambda ()
;;
;;   (company-mode 1)
;;   (sucha-install-company-completion-rules) ; refers to the function
;; ) t ))

;; company mode map
;; 
;;(define-key company-mode-map [(tab)] 'indent-for-tab-command)
;;(define-key company-mode-map [(meta j)] 'company-cycle)
;;(define-key company-mode-map [(meta k)] 'company-cycle-backwards)
;;(define-key company-mode-map [(backtab)] 'company-expand-common)
;;(define-key company-mode-map (kbd "M-SPC") 'company-expand-anything)
;;(define-key company-mode-map [(meta return)] 'company-expand-common) 

;;;; 生成 TAGS, adong 提供 (in LinuxForum GNU Emacs/XEmacs)
;;;; find -name "*.[ch]*" | xargs etags -a
;;
;;;; 查找 TAGS 文件
;;(global-set-key [(f7)] 'visit-tags-table)
;;
;;;; 以下由 zslevin 提供(LinuxForum GNU Emacs/XEmacs)
;;
;;;; C-. 在另一窗口处查看光标处的 tag
;;;; C-, 只留下当前查看代码的窗口（关闭查看 tag 的小窗）
;;;; M-. 查找光标处的 tag，并跳转
;;;; M-, 跳回原来查找 tag 的地方
;;;; C-M-, 提示要查找的 tag，并跳转
;;;; C-return, 查找 tag 自动补全
;;
;;(global-set-key [(control .)] '(lambda () (interactive) (lev/find-tag t)))
;;(global-set-key [(control ,)] 'delete-other-windows)
;;(global-set-key [(meta .)] 'lev/find-tag)
;;(global-set-key [(meta ,)] 'pop-tag-mark)
;;(global-set-key (kbd "C-M-,") 'find-tag)
;;(global-set-key [(shift return)] 'complete-tag)
;;
;;(defun lev/find-tag (&optional show-only)
;;  "Show tag in other window with no prompt in minibuf."
;;  (interactive)
;;  (let ((default (funcall (or find-tag-default-function
;;                              (get major-mode 'find-tag-default-function)
;;                              'find-tag-default))))
;;    (if show-only
;;        (progn (find-tag-other-window default)
;;               (shrink-window (- (window-height) 12)) ;; 限制为 12 行
;;               (recenter 1)
;;               (other-window 1))
;;      (find-tag default))))

(provide 'cw-tags)
;;; cw-tags.el ends here
