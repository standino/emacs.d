
; auto completion
;;;;;;;;;;;;;;;;;
(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")


(my-require-or-install 'auto-complete)

(global-auto-complete-mode t)

(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
;;(setq ac-auto-start 3)
;;(require 'auto-complete-ruby)
(require 'init-auto-complete)
(setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))

(add-to-list 'ac-modes 'shell-mode)
(add-to-list 'ac-modes 'sql-mode)
(add-to-list 'ac-modes 'xml-mode)

;;(add-hook 'emacs-lisp-mode-hook
;;          (lambda ()
;;            (make-local-variable 'ac-sources)
;;            (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer ac-source-symbols))))
;;
;;(add-hook 'eshell-mode-hook
;;          (lambda ()
;;            (make-local-variable 'ac-sources)
;;            (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-files-in-current-dir ac-source-words-in-buffer))))
;;


(defun my-tab (&optional pre-arg)
  "If preceeding character is part of a word then dabbrev-expand,
else if right of non whitespace on line then tab-to-tab-stop or
indent-relative, else if last command was a tab or return then dedent
one step, else indent 'correctly'"
  (interactive "*P")
  (cond ((= (char-syntax (preceding-char)) ?w)
         (let ((case-fold-search t)) (dabbrev-expand pre-arg)))
        ((> (current-column) (current-indentation))
         (indent-relative))
        (t (indent-according-to-mode)))
  (setq this-command 'my-tab))

(add-hook 'html-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'sgml-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'perl-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'text-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))


(defun my-indent-or-complete ()
   (interactive)
   (if (looking-at "\\>")
 	  (hippie-expand nil)
 	  (indent-for-tab-command))
)



(autoload 'senator-try-expand-semantic "senator")

(setq hippie-expand-try-functions-list
 	  '(
		senator-try-expand-semantic
		try-expand-dabbrev
		try-expand-dabbrev-visible
		try-expand-dabbrev-all-buffers
		try-expand-dabbrev-from-kill
		try-expand-list
		try-expand-list-all-buffers
		try-expand-line
        try-expand-line-all-buffers
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-whole-kill
        )
)

;;(add-hook 'sql-mode-hook
;;          (lambda ()
;;            (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer ac-source-symbols hippie-expand-try-functions-list))))
;;
;;             C  mode
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'sql-mode-hook 'hs-minor-mode)
 (autoload 'company-mode "company" nil t)
(provide 'cw-auto-complete)
