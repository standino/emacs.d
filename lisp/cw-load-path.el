;;; package --- 设置路径
;;; code

(setq my-idea-home "~/ideas/")
(setq my-emacs-home "~/ideas/emacs/")
(add-to-list 'load-path (concat my-emacs-home "lib"))

(defun cw/open-host-file ()
   (interactive)
   (find-file (concat "/cygdrive/c/Windows/System32/drivers/etc/"  "hosts"))
 )

(require 'require-or-install)

(defun my-require-or-install (feature)
  (require-or-install feature  (format "%s.el" feature) )
  )

(defun my-require (feature)
  " put the ~/.emacs.d/$feature to path"
    (add-to-list 'load-path  (format "~/.emacs.d/%s"   feature) )
  (my-require-or-install feature)
)

(require 'wc)


(provide 'cw-load-path)
