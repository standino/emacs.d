(setq-default ispell-program-name "aspell")
(setq-default ispell-extra-args '("--reverse"))
(setq-default ispell-local-dictionary "en")

(defvar my-flyspell-major-mode-list
  '(latex-mode
    message-mode
    muse-mode
    nuweb-mode
    nxml-mode
    text-mode
    org-mode
    sql-mode
    change-log-mode
    log-edit-mode
    remember-mode)
)

(add-hook 'first-change-hook
          (lambda ()
            ;;                 (message "major-mode is %s" major-mode)
            (when (and (memq major-mode my-flyspell-major-mode-list)
                       (not flyspell-mode))
              (flyspell-mode)))
 )
(provide 'cw-spell)
