;;
;; 26_package.el
;; 
;; Made by Will
;; Login   <will@will-laptop>
;; 
;; Started on  Mon Nov 10 17:03:55 2008 Will
;; Last update Mon Nov 10 17:06:27 2008 Will
;;

;;If you are using Emacs 22, you already have the needed url package, and you can eval this code:
;;
;;  (let ((buffer (url-retrieve-synchronously
;;	       "http://tromey.com/elpa/package-install.el")))
;;  (save-excursion
;;    (set-buffer buffer)
;;    (goto-char (point-min))
;;    (re-search-forward "^$" nil 'move)
;;    (eval-region (point) (point-max))
;;    (kill-buffer (current-buffer))))
;;  
;;
;;If you don't know what "eval" means, it means that you should copy this into your *scratch* buffer, 
;;move your cursor just after the final closing paren, and type C-j. 

;;(require 'highlight-parentheses)
;;(require 'dired-isearch)
;;(define-key dired-mode-map (kbd "C-s") 'dired-isearch-forward)
;;(define-key dired-mode-map (kbd "C-r") 'dired-isearch-backward)
;;(define-key dired-mode-map (kbd "M-C-s") 'dired-isearch-forward-regexp)
;;(define-key dired-mode-map (kbd "M-C-r") 'dired-isearch-backward-regexp)
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)


(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))

(provide 'cw-package)
