;; jdee
(add-to-list 'load-path "~/.emacs.d/jdee-2.4.1/lisp")
(load "jde")



(require 'eclim)
(global-eclim-mode)

(require 'eclimd)

(custom-set-variables
 '(eclim-eclipse-dirs '("/usr/lib64/eclipse"))
 '(eclimd-default-workspace "/home/Will/JD/projects" )
 '(eclim-executable "/usr/lib64/eclipse/eclim" )
 )
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

(require 'flymake)
(defun my-flymake-init ()
  (list "my-java-flymake-checks"
        (list (flymake-init-create-temp-buffer-copy
               'flymake-create-temp-with-folder-structure))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.java$" my-flymake-init flymake-simple-cleanup))


(defun eclim-run-test ()
  (interactive)
  (if (not (string= major-mode "java-mode"))
    (message "Sorry cannot run current buffer."))
  (compile (concat eclim-executable " -command java_junit -p " eclim--project-name " -t " (eclim-package-and-class))))
(provide 'init-java)
