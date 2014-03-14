(require-package 'mew)

(setq mew-touch-folder-p nil)
;
; -----------  Added by Install Kit writer ------------
; Caution when no Subject mail
(setq mew-ask-subject t)
; Un-limit the receiving POP mail size
(setq mew-pop-size 0)
; ------------  End of additional part  ----------------
;

;-------------------------------------------------------------------------------
;; delete mail on pop server ?
(setq mew-pop-delete nil)

;-------------------------------------------------------------------------------
;; passwd
(setq mew-use-cached-passwd t)

;-------------------------------------------------------------------------------
;; SSL
;(setq mew-ssl-verify-level 2)
;(setq mew-ssl-cert-directory "~/.certs")

;; use POP instead of APOP
(setq mew-pop-auth 'pass) ;; APOP password is not supported by GMail POP server

;; mail status
(setq mew-name "常伟") ;; (user-full-name)
(setq mew-user "changwei") ;; (user-login-name)
(setq mew-mail-domain "jd.com")

;; SMTP (send)

(setq mew-smtp-user "username")
(setq mew-smtp-server "smtp.jd.com")
;;(setq mew-smtp-ssl t)
;;(setq mew-smtp-ssl-port "465")
;;; -------
;;; localhost (using SSH port forward)
;;(setq mew-smtp-server "localhost")
;;(setq mew-smtp-port "10000")
;;; -------

;; POP (recv)
(setq mew-pop-user "changwei")  ;; (user-login-name)
(setq mew-pop-server "pop3.jd.com")    ;; if not localhost
;;(setq mew-pop-ssl t)
;;(setq mew-pop-ssl-port "995")

;; IMAP (recv)
;; (setq mew-proto "%")
;; (setq mew-imap-user "your IMAP account")  ;; (user-login-name)
;; (setq mew-imap-server "your IMAP server")    ;; if not localhost

;; NNTP (news)
;; (setq mew-nntp-user "your NNTP account")
;; (setq mew-nntp-server "your NNTP server")

;-------------------------------------------------------------------------------
;; MIME control
(setq mew-use-text-body t)
(setq mew-use-alternative nil)

;; flush for send
(setq mew-auto-flush-queue nil)

;; signature
(setq mew-signature-file "~/.signature")
(setq mew-signature-insert-last t)

;; mark
(setq mew-use-unread-mark t)
(setq mew-delete-unread-mark-by-mark nil)


(provide 'init-mail)
