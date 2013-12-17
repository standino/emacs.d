;;(require 'plsql)

(setq sql-db2-options  '("-c" "-i" "-w"    "-td@" "-v" ))

(setq sql-send-terminator "@")
(setq sql-product 'db2)
(add-to-list 'auto-mode-alist '("\\.sql\\'" . sql-mode))  
(add-to-list 'auto-mode-alist '("\\.SQL\\'" . sql-mode))  

(cygwin-do 
        (lambda()(setq sql-db2-program "/bin/IBM/SQLLIB/BIN/db2cmd.exe") )
  
 )

(cygwin-do
        (lambda()(setq sql-db2-options (append '("-c" "-i" "-w"  "db2" "-td@" "-v" ) ( list (format-time-string "-z C:/dsw/home/Will/backup/my_db2_log%y%m.SQL" (current-time))) ))  )
  
 )

(win-do
 (lambda()
		   (setq sql-db2-program "C:/Program Files/IBM/SQLLIB/BIN/db2cmd.exe")
		   (setq sql-db2-options (append '("-c" "-i" "-w"  "db2" "-td@" "-v" ) ( list (format-time-string "-z C:/dsw/home/Will/backup/my_db2_log%y%m.SQL" (current-time))) ))
		   
   )
)


(add-hook 'sql-interactive-mode-hook
         (lambda ()
           (setq sql-input-ring-file-name "~/.emacs.d/sql_history")
           (setq comint-scroll-to-bottom-on-output t)
           (setq tab-width 4)
           (set (make-local-variable 'truncate-lines) t)
           
           ))

(add-hook 'sql-mode-hook
         (lambda ()
           (setq tab-width 4)
           (setq indent-tabs-mode nil) 
           ))


(add-hook 'sql-interactive-mode-hook 'turn-on-orgtbl)

;;(defadvice sql-send-region (after sql-store-in-history)
;;  "The region sent to the SQLi process is also stored in the history."
;;  (let ((history (buffer-substring-no-properties start end)))
;;    (save-excursion
;;      (set-buffer sql-buffer)
;;      (message history)
;;      (if (and (funcall comint-input-filter history)
;;               (or (null comint-input-ignoredups)
;;                   (not (ring-p comint-input-ring))
;;                   (ring-empty-p comint-input-ring)
;;                   (not (string-equal (ring-ref comint-input-ring 0)
;;                                      history))))
;;          (ring-insert comint-input-ring history))
;;      (setq comint-save-input-ring-index comint-input-ring-index)
;;      (setq comint-input-ring-index nil))))
;;
;;(ad-activate 'sql-send-region)

(defun sql-escape-newlines-filter (string)
  "Escape newlines in STRING.
Every newline in STRING will be preceded with a space and a backslash."
  (let ((result "") (start 0) mb me)
    (while (string-match "\n" string start)
      (setq mb (match-beginning 0)
	    me (match-end 0)
	    result (concat result
			   (substring string start mb)
			   (if (and (> mb 1)
				    (string-equal " " (substring string (- mb 2) mb)))
			       "" " \n"))
	    start me))
    (concat result (substring string start))))

 
(eval-after-load "sql"
   '(load-library "sql-indent"))

(defgroup xdb-connect nil 
  "interactiv db-sessions" 
  :prefix "xdb-" 
  :group 'local) 


(defcustom xdb-db2-sqli-file "~/db2SQL-log.sql"   
  "Default SQLi file for db2-sessions"      
  :type 'string         
  :group 'xdb-connect)   

;;------------------------------------------------------------------------  
;; functions
;;------------------------------------------------------------------------  

(defun db2connect ()   
  "connect to a db2 server with interactiv sql-Buffer"   
  (interactive)  
  (add-to-list 'auto-mode-alist '("\\.sql\\'" . sql-mode))  
  (add-to-list 'auto-mode-alist '("\\.SQL\\'" . sql-mode))  
  (find-file-other-window xdb-db2-sqli-file)  
  (sql-db2)  
  (other-window -1)
  (sql-set-sqli-buffer-generally))  

(defun db2-con(db2name)
  "connect to databse using my personal ID"
  (interactive "sPlease input DB name:")
  (db2-con-db (format "web%s" db2name) "web_dev5"  "ebiz66vs")
)

(setq global-mode-string
      (append global-mode-string
              '(" " my-db2-str 
                " "))
)
 

(defun db2-update-db2-name(db2name  userName)
  (setq my-db2-str (format "-DB: %s User: %s-" db2name userName))

)

(defun db2-con-my(db2name)
  "connect to databse using my personal ID"
  (interactive "sPlease input DB name:")
  (db2-con-db (format "web%s" db2name) "changwei" "ebiz23vs")
;;  (set-buffer sql-buffer)
;;  (comint-simple-send sql-buffer (format "connect to web%s user changwei using ebiz63vs@" db2name))
;;  (comint-previous-prompt 1)
;;  (db2-update-db2-name db2name "changwei") 
;; (setq global-mode-string   (format "****connecting to db2%s user changwei****" db2name ))
)

(defun db2-con-plug()
  "connect to production"
  (interactive)
  (db2-con-db "webplug" "myang" "ebiz02vs")

)

(defun db2-con-db(db2name user passwd)
  "connect to db"
  (set-buffer sql-buffer)
  (comint-simple-send sql-buffer (format "connect to %s user %s  using %s@" db2name user passwd))
  (comint-previous-prompt 1)
  (db2-update-db2-name db2name user)  
  ;;(setq global-mode-string   (format "****connecting to %s user %s****" db2name user ))
)

(defun db2-con-saastx()
  "db2 catalog tcpip node MPBSTX remote 9.123.109.134 server 50000
db2 catalog db SAASTX as SAASTX at node MPBSTX"
  (interactive)
  (db2-con-db "SAASTX" "txdbusr" "saas2009")
)

(defun db2-con-moddw()
  "db2 catalog tcpip node MPBSDW remote 9.123.109.113 server 50000
db2 catalog db MODDW as MODDW at node MPBSDW
"
  (interactive)
  (db2-con-db "MODDW" "db2admin" "aq1sw2de")
)


(defun db2-con-java(db2name)
  "connect to databse using prcbkweb "
  (interactive "sPlease input DB name:")
  (db2-con-db (format "web%s" db2name) "prcbkweb"  "new10prc")
 
)


(defun my-db2-auto-save-log()
 (interactive)
    (when (equal "SQLi[db2]" mode-name)
	(write-file  (concat "~/backup/my_db2_log" (format-time-string "%y%m%d" (current-time)) ".SQL" ))
    )
)

(defun my-db2-view-table(tablename)
  "Get the table's definition from database."
  (interactive "sinput table name:")
  (set-buffer sql-buffer)
  (setq st-table-name-list (split-string tablename "\\.")
       st-table-first-name (car st-table-name-list  )
       st-table-last-name (car (cdr st-table-name-list )))
  (comint-simple-send  sql-buffer   (format "describe table %s show detail @ 
select 'PK---'|| LTRIM(RTRIM(sp.column_name))||' '|| LTRIM(RTRIM(co.TYPENAME)) || '(' || LTRIM(RTRIM(CHAR(co.LENGTH))) || ')',
sp.table_schem from sysibm.sqlprimarykeys sp, SYSCAT.COLUMNS co where sp.table_name=upper('%s') 
and sp.table_name=co.TABNAME and sp.column_name = co.COLNAME @ 
select 'FK---' || LTRIM(RTRIM(PKTABLE_SCHEM))||'.'||LTRIM(RTRIM(PKTABLE_NAME))||'.'||LTRIM(RTRIM(PKCOLUMN_NAME))|| 
'-->'||LTRIM(RTRIM(FKTABLE_SCHEM))|| '.'||LTRIM(RTRIM(FKTABLE_NAME))||'.'||LTRIM(RTRIM(FKCOLUMN_NAME)) 
from sysibm.SQLFOREIGNKEYS where (PKTABLE_SCHEM=upper('%s') and PKTABLE_NAME =upper('%s')) or (FKTABLE_SCHEM=upper('%s') and FKTABLE_NAME =upper('%s')) @ 
select 'Index --' || VARCHAR(INDNAME,30), VARCHAR(TABNAME,30) , VARCHAR(COLNAMES,130) from SYSCAT.INDEXES where TABSCHEMA = upper('%s') AND TABNAME = upper('%s')  @ 
select * from %s fetch first 20 rows only @ 
select 'SQL of View ---' ||  varchar(text,32670)  from syscat.views where viewschema=upper('%s')and viewname = upper('%s') @ 
 select distinct 'tables in the view---' ||  bname from syscat.viewdep where viewname=upper('%s')  and btype='T' @ "
       tablename 
       st-table-last-name 
       st-table-first-name st-table-last-name st-table-first-name st-table-last-name
       st-table-first-name st-table-last-name 
       tablename
       st-table-first-name st-table-last-name 
       st-table-last-name 
       ))
  (comint-previous-prompt 1)
)

(add-hook 'kill-buffer-hook 'my-db2-auto-save-log) 

(defun sql-beautify-region (beg end)
  "Beautify SQL in region between beg and END."
  (interactive "r")
  (save-excursion
    (shell-command-on-region beg end "sqlbeautify" nil t)))

(defun sql-beautify-buffer ()
 "Beautify SQL in buffer."
 (interactive)
 (sql-beautify-region (point-min) (point-max)))

(provide 'cw-db2)
