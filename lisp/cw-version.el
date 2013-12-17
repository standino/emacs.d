;;(add-hook 'find-file-hooks 'my-vc-update)

(defun my-vc-update()
  (condition-case nil
      (if (vc-registered (buffer-file-name))
           (vc-update))
    (error nil))
)

(defun my-start-svn-sever()
  (interactive)
;;  (shell-command "startsvn &" )
  (start-process-shell-command 
         "svn server" 
         "*scratch*" 
         "desktopsvn")

)

(defun vc-ediff ()
 (interactive)
 (require 'ediff)
 (require 'vc)
 (vc-buffer-sync)
 (ediff-load-version-control)
 (ediff-vc-internal "" ""))
;;(my-start-svn-sever)


(provide 'cw-version)
