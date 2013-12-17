
 
(my-require-or-install 'dropdown-list)
(my-require 'yasnippet)
(yas/initialize)
;;(yas/load-directory "~/.emacs.d/yasnippet/snippets")
(yas/load-directory "~/mysnippet")
;;(setq yas/root-directory "~/bin/emacs/mysnippet")
;;(yas/load-directory yas/root-directory)

(setq yas/text-popup-function 'yas/dropdown-list-popup-for-template)
(setq yas/window-system-popup-function 'yas/dropdown-list-popup-for-template)
(require 'snippet)


;;(add-hook 'org-mode-hook
;;          '(lambda ()
;;             (make-variable-buffer-local 'yas/trigger-key)
;;             (setq yas/trigger-key [tab])))
;;
;;(add-hook 'muse-mode-hook
;;          '(lambda ()
;;             (make-variable-buffer-local 'yas/trigger-key)
;;             (setq yas/trigger-key [tab])))
;;
;;(add-hook 'org-mode-hook
;;          '(lambda ()
;;             (make-variable-buffer-local 'yas/next-field-group)
;;             (setq yas/trigger-key [tab])))
;;
;;(add-hook 'muse-mode-hook
;;          '(lambda ()
;;             (make-variable-buffer-local 'yas/next-field-group)
;;             (setq yas/trigger-key [tab])))

(provide 'cw-snippet)
