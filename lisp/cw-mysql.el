;; 加载 mysql
(my-require-or-install 'sql)
(my-require-or-install 'mysql)

(setq sql-product 'mysql)
(add-to-list 'auto-mode-alist '("\\.sql\\'" . sql-mode))  
(add-to-list 'auto-mode-alist '("\\.SQL\\'" . sql-mode))  

;;保存历史
(add-hook 'sql-interactive-mode-hook
         (lambda ()
           (setq sql-input-ring-file-name "~/sql_history")
           (setq comint-scroll-to-bottom-on-output t)
           (setq tab-width 4)
           (set (make-local-variable 'truncate-lines) t)
           
           ))
;;

(add-hook 'sql-mode-hook
         (lambda ()
           (setq tab-width 4)
           (setq indent-tabs-mode nil) 
           ))

(setq sql-mysql-options '("-C" "-t" "-f" "-n"))

(setq sql-connection-alist
      '((pool-a
         (sql-product 'mysql)
         (sql-server "192.168.196.53")
         (sql-user "root")
         (sql-password "123456")
         (sql-database "pbs_cw")
         (sql-port 3306))
        (pool-pbs-new
         (sql-product 'mysql)
         (sql-server "10.10.224.144")
         (sql-user "test_write")
         (sql-password "test_write123")
         (sql-database "pbs_buyingPlan_new")
         (sql-port 3306))))

(defun sql-connect-preset (name)
  "Connect to a predefined SQL connection listed in `sql-connection-alist'"
  (eval `(let ,(cdr (assoc name sql-connection-alist))
           (flet ((sql-get-login (&rest what)))
             (sql-product-interactive sql-product)))))

(defun sql-pool-a ()
  (interactive)
  (sql-connect-preset 'pool-a))

(defun sql-pool-pbs-new ()
  (interactive)
  (sql-connect-preset 'pool-pbs-new))

(setq sql-send-terminator ";")

(eval-after-load "sql"
   '(load-library "sql-indent"))

(defgroup xdb-connect nil 
  "interactiv db-sessions" 
  :prefix "xdb-" 
  :group 'local) 

(defcustom xdb-mysql-sqli-file "~/mysqlSQL-log.sql"   
  "Default SQLi file for mysql-sessions"      
  :type 'string         
  :group 'xdb-connect)   

(setq global-mode-string
      (append global-mode-string
              '(" " cw-my-sql-str 
                " "))
)
 

(defun cw-update-db-name(dbname  userName)
  (setq cw-my-sql-str (format "DB:%s" dbname))

)


(defun cw-mysql-cw ()   
  "connect to a mysql server with interactiv sql-Buffer"   
  (interactive)  
  (add-to-list 'auto-mode-alist '("\\.sql\\'" . sql-mode))  
  (add-to-list 'auto-mode-alist '("\\.SQL\\'" . sql-mode))  
  (find-file-other-window xdb-mysql-sqli-file)  
  (sql-pool-a) 
  (other-window -1)
  (sql-set-sqli-buffer-generally)
  (cw-update-db-name "pbs-cw" "root")
)  

(defun cw-mysql-pbs-new ()   
  "connect to a mysql server with interactiv sql-Buffer"   
  (interactive)  
  (add-to-list 'auto-mode-alist '("\\.sql\\'" . sql-mode))  
  (add-to-list 'auto-mode-alist '("\\.SQL\\'" . sql-mode))  
  (find-file-other-window xdb-mysql-sqli-file)  
  (sql-pool-pbs-new) 
  (other-window -1)
  (sql-set-sqli-buffer-generally)
  (cw-update-db-name "pbs-new" "test_write")
)  


;; 新加一样标识

;; (defvar sql-last-prompt-pos 1
;;    "position of last prompt when added recording started")
;;  (make-variable-buffer-local 'sql-last-prompt-pos)
;;  (put 'sql-last-prompt-pos 'permanent-local t)
;; 
;;  (defun sql-add-newline-first (output)
;;    "Add newline to beginning of OUTPUT for `comint-preoutput-filter-functions'
;;    This fixes up the display of queries sent to the inferior buffer
;;    programatically."
;;    (let ((begin-of-prompt
;;           (or (and comint-last-prompt-overlay
;;                    ;; sometimes this overlay is not on prompt
;;                    (save-excursion
;;                      (goto-char (overlay-start comint-last-prompt-overlay))
;;                      (looking-at-p comint-prompt-regexp)
;;                      (point)))
;;               1)))
;;      (if (> begin-of-prompt sql-last-prompt-pos)
;;          (progn
;;            (setq sql-last-prompt-pos begin-of-prompt)
;;            (concat "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n" output))
;;        output)))
;; 
;;  (defun sqli-add-hooks ()
;;    "Add hooks to `sql-interactive-mode-hook'."
;;    (add-hook 'comint-preoutput-filter-functions
;;              'sql-add-newline-first))
;; 
;;  (add-hook 'sql-interactive-mode-hook 'sqli-add-hooks)


(provide 'cw-mysql)
