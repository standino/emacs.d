(add-to-list 'auto-mode-alist '("\\.list\\'" . sh-mode))  
(autoload 'cmd-mode "cmd-mode" "CMD mode." t)
(setq auto-mode-alist (append '(("\\.\\(cmd\\|bat\\)$" . cmd-mode))
                              auto-mode-alist))

(setq my-shebang-patterns
      (list "^#!/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
        "^#!/usr/.*/sh"
        "^#!/usr/.*/bash"
        "^#!/bin/sh"
        "^#!/.*/perl"
        "^#!/.*/awk"
        "^#!/.*/sed"
        "^#!/bin/bash"))
(add-hook
 'after-save-hook
 (lambda ()
 (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
     (progn
       ;; This puts message in *Message* twice, but minibuffer
       ;; output looks better.
       (message (concat "Wrote " (buffer-file-name)))
       (save-excursion
         (goto-char (point-min))
         ;; Always checks every pattern even after
         ;; match.  Inefficient but easy.
         (dolist (my-shebang-pat my-shebang-patterns)
           (if (looking-at my-shebang-pat)
               (if (= (shell-command
                       (concat "chmod u+x " (buffer-file-name)))
                      0)
                   (message (concat
                             "Wrote and made executable "
                             (buffer-file-name))))))))
   ;; This puts message in *Message* twice, but minibuffer output
   ;; looks better.
   (message (concat "Wrote " (buffer-file-name))))))

(define-auto-insert 'cperl-mode  "perl.tpl" )
(define-auto-insert 'sh-mode '(nil "#!/bin/bash\n\n"))
; 也可以是,不过我没有试过
; (define-auto-insert "\\.pl"  "perl.tpl" )
(add-hook 'find-file-hooks 'auto-insert)

;
;;;(shell "startsvn")
;;;(rename-buffer "+svn")

;;;(cd "c:/dsw/quote/head/QuoteLocal/2008")
;;;;(cd "c:/standino/ideas")
;;(shell)
;;(rename-buffer "+sql")
;;
;;(shell)
;;(rename-buffer "+build")
;;(shell)
;;(rename-buffer "+test")
;;;show matched brackets
;;(show-paren-mode)
;;;Set the color of screen
;;(set-background-color "DarkSlateGrey")
;;(set-foreground-color "wheat")
;;(set-cursor-color "gold1¡å)
;;(set-mouse-color "gold1¡å)
;;;set font
;;;(set-default-font "-misc-vera sans yuanti mono-medium-r-normal¨C16-0-0-0-p-0-gb2312.1980-0¡å)
;




(provide 'cw-shell)
