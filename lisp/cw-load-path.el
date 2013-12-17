
(cygwin-or-linux 
        (lambda()
          (add-to-list 'load-path 
                       (concat my-emacs-home "lib/muse-3.12/lisp")
                       )
          (add-to-list 'load-path  
                       (concat my-emacs-home  "eim-2.4"
                               )
                       )
          )
        nil
 )

(linux-do (lambda()(add-to-list 'load-path  "~/.emacs.d/muse/lisp"
                               
                       )
			)
)

(add-to-list 'load-path  "~/.emacs.d/muse/lisp")
;;(add-to-list 'load-path "~/bin/emacs/emacs-w3m")
;;(require 'byte-code-cache)
(add-to-list 'load-path "~/.emacs.d/emacs-rails")
(add-to-list 'load-path "~/.emacs.d/ruby")
(require 'require-or-install)
(defun my-require-or-install (feature)
(require-or-install feature  (format "%s.el" feature) )
)

(defun my-require (feature)
  " put the ~/.emacs.d/$feature to path"
  (add-to-list 'load-path  (format "%s/%s" emacs-d  feature) )
    (add-to-list 'load-path  (format "~/.emacs.d/%s"   feature) )
  (my-require-or-install feature)
)





;;(require-or-install 'icicles-install)

(my-require-or-install 'wc)


(my-require-or-install 'sql-indent)
(provide 'cw-load-path)
