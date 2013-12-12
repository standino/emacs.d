;;; key
(global-set-key "\C-z" 'set-mark-command)

;;; path
(setq my-idea-home "~/ideas/")
(setq my-emacs-home "~/ideas/emacs/")
(add-to-list 'load-path (concat my-emacs-home "lib"))

;;; org-pages

(require 'org-page)
(setq op/repository-directory "~/orgpage")
(setq op/site-domain "http://your.personal.site.com/")
(setq op/personal-disqus-shortname "your_disqus_shortname")

(provide 'init-local)
