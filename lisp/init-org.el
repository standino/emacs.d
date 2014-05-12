(when (< emacs-major-version 24)
  (require-package 'org))
(require-package 'org-fstree)
(when *is-a-mac*
  (require-package 'org-mac-link)
  (autoload 'org-mac-grab-link "org-mac-link" nil t)
  (require-package 'org-mac-iCal))


(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

;; Various preferences
(setq org-log-done t
      org-completion-use-ido t
      org-edit-timestamp-down-means-later t
      org-agenda-start-on-weekday nil
      org-agenda-span 14
      org-agenda-include-diary t
      org-agenda-window-setup 'current-window
      org-fast-tag-selection-single-key 'expert
      org-export-kill-product-buffer-when-displayed t
      org-tags-column 80)


; Refile targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5))))
; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))
; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)


(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "OKTODAY(o!)" "|"   "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "SOMEDAY(S)" "|" "CANCELLED(c@/!)"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org clock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persistence-insinuate t)
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")
;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(after-load 'org-clock
  (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
  (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu))


;; ;; Show iCal calendars in the org agenda
;; (when (and *is-a-mac* (require 'org-mac-iCal nil t))
;;   (setq org-agenda-include-diary t
;;         org-agenda-custom-commands
;;         '(("I" "Import diary from iCal" agenda ""
;;            ((org-agenda-mode-hook #'org-mac-iCal)))))

;;   (add-hook 'org-agenda-cleanup-fancy-diary-hook
;;             (lambda ()
;;               (goto-char (point-min))
;;               (save-excursion
;;                 (while (re-search-forward "^[a-z]" nil t)
;;                   (goto-char (match-beginning 0))
;;                   (insert "0:00-24:00 ")))
;;               (while (re-search-forward "^ [a-z]" nil t)
;;                 (goto-char (match-beginning 0))
;;                 (save-excursion
;;                   (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
;;                 (insert (match-string 0))))))


(after-load 'org
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (define-key org-mode-map (kbd "M-h") nil))
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (autoload 'omlg-grab-link "org-mac-link")
    (define-key org-mode-map (kbd "C-c g") 'omlg-grab-link))


  )


;;; added by standino
;; Remove empty LOGBOOK drawers on clock out
;;(defun bh/remove-empty-drawer-on-clock-out ()
;;  (interactive)
;;  (save-excursion
;;    (beginning-of-line 0)
;;    (org-remove-empty-drawer-at "LOGBOOK" (point))))
;;
;;(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)
;;
;;; Enable habit tracking (and a bunch of other modules)
;;(setq org-modules (quote (org-bbdb
;;                          org-bibtex
;;                          org-crypt
;;                          org-gnus
;;                          org-id
;;                          org-info
;;                          org-jsinfo
;;                          org-habit
;;                          org-inlinetask
;;                          org-irc
;;                          org-mew
;;                          org-mhe
;;                          org-protocol
;;                          org-rmail
;;                          org-vm
;;                          org-wl
;;                          org-w3m)))
;;
;;; position the habit graph on the agenda to the right of the default
;;(setq org-habit-graph-column 50)
;;
;;(run-at-time "09:00" 86400 '(lambda () (setq org-habit-show-habits t)))
(run-at-time "11:50" 86400 '(cw/pub-all))

(defun sacha/org-agenda-clock (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (org-dblock-write:clocktable
     `(:scope agenda
              :maxlevel 8
              :block today
              :formula %
              :compact t
              :narrow 150!
;;              :link t
              ))))

(defun cw/org-agenda-clock (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (org-dblock-write:clocktable
     `(:scope agenda
              :maxlevel 8
              :block today
              :compact t
              :narrow 150!
              ))))

(defun cw/org-agenda-clock-daily-report (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (org-dblock-write:clocktable
     `(:scope agenda
       :maxlevel 8
       :block today

       ))))
(defun cw/org-agenda-clock-thisweek (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (org-dblock-write:clocktable
     `(:scope agenda
       :maxlevel 8
           :block thisweek
           :formula %
           :compact t
           :narrow 150!
;;           :link t
       ))))

(defun cw/org-agenda-clock-lastweek (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (insert  "\n\nTasks done in this week: \n")
    (org-dblock-write:clocktable
     `(:scope agenda
       :maxlevel 8
           :block lastweek
           :formula %
           :compact t
           :narrow 150!
;;           :link t
       ))))

(defun cw/org-agenda-clock-thismonth (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (insert  "\n\nTasks done in this month: \n")
    (org-dblock-write:clocktable
     `(:scope agenda
       :maxlevel 8
           :block thismonth
           :formula %
           :compact t
           :narrow 150!
;;           :link t
       ))))
(defun cw/org-agenda-clock-thisyear (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (insert  "\n\nTasks done in this year: \n")
    (org-dblock-write:clocktable
     `(:scope agenda
       :maxlevel 8
           :block thisyear
           :formula %
           :compact t
           :narrow 150!
;;           :link t
       ))))

;; Change your existing org-agenda-custom-commands
(setq org-agenda-custom-commands
      '(("a" "My custom agenda"
         (
          (sacha/org-agenda-clock)
          (todo "OKTODAY" )
          (todo "STARTED")

          (org-agenda-list nil nil 1)
;;          (sacha/org-agenda-load)
          (todo "WAITING")
          (todo "DELEGATED" )

          (todo "TODO")
          (tags "PROJECT")
;;          (tags "PROJECT-WAITING")
          (todo "MAYBE")
          )
         )
        ("d" "delegated"
         ((todo "DELEGATED" ))
         )
        ("c" "finished tasks"
         ((todo "DONE" )
          (todo "DEFERRED" )
          (todo "CANCELLED" )
          )
         )
        ("w" "waiting"
         ((todo "WAITING" ))
         )
        ("o" "overview"
         ((todo "WAITING" )
          (cw/org-agenda-clock-daily-report)
          (cw/org-agenda-clock-thisweek)
          (cw/org-agenda-clock-thismonth)
          (cw/org-agenda-clock-thisyear)
          )
         )
        ("x" "Weekly schedule" agenda ""
         ((org-agenda-ndays 7)          ;; agenda will start in week view
          (org-agenda-repeating-timestamp-show-all nil)   ;; ensures that repeating events appear on all relevant dates
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
        ("A" "priority A"
         ((tags "//#A" ))
         )
        ("T" todo-tree "TODO")
        ("W" todo-tree "WAITING")
        ("u" "Unscheduled" ((sacha/org-agenda-list-unscheduled)))
        ("v" tags-todo "+BOSS-URGENT")
        ("U" tags-tree "+BOSS-URGENT")
        ("f" occur-tree "\\<FIXME\\>")
        )
      )
;;; writing presentation

;; {{ export org-mode in Chinese into PDF
;; @see http://freizl.github.io/posts/tech/2012-04-06-export-orgmode-file-in-Chinese.html
;; and you need install texlive-xetex on different platforms
;; To install texlive-xetex:
;;    `sudo USE="cjk" emerge texlive-xetex` on Gentoo Linux
(setq org-latex-to-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))

  ;; Install a default set-up for Beamer export.
(require 'ox-beamer)
  (unless (assoc "beamer-cn" org-latex-classes)
  (add-to-list 'org-latex-classes
               '("beamer-cn"
                 "\\documentclass[presentation]{beamer}
\\usepackage{xeCJK}
\\setCJKmainfont{SimSun}
\[DEFAULT-PACKAGES]
\[PACKAGES]
\[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))


;; }}


;;; GTD 提醒

(defun sacha/org-clock-in-if-starting ()
  "Clock in when the task is marked STARTED."
  (when  (string= org-state "STARTED")
    (org-clock-in)
;;    (org-pomodoro)
))

(add-hook 'org-after-todo-state-change-hook
          'sacha/org-clock-in-if-starting)

(defadvice org-clock-in (after sacha activate)
  "Set this task's status to 'STARTED'."
  (org-todo "STARTED"))

(defun sacha/org-clock-out-if-waiting ()
  "Clock in when the task is marked STARTED."
  (when  (string= org-state "WAITING")
    (org-clock-out)))
(add-hook 'org-after-todo-state-change-hook
          'sacha/org-clock-out-if-waiting)

(defun sacha/org-clock-out-if-oktoday ()
  "clock out  when the task is marked OKTODAY."
  (when (string= org-state "OKTODAY")
    (org-clock-out)))
(add-hook 'org-after-todo-state-change-hook
          'sacha/org-clock-out-if-oktoday)

;; Pomodoro and org-mode

(add-to-list 'org-modules' org-timer)
(setq org-timer-default-timer 25)
(add-hook 'org-clock-in-hook' (lambda ()
       (if (not org-timer-current-timer)
       (org-timer-set-timer '(16)))))
(add-hook 'org-clock-out-hook' (lambda ()
       (setq org-mode-line-string nil)
))
(add-hook 'org-timer-done-hook 'have-a-rest)

(require-package 'express)
(express-install-aliases)

(defun have-a-rest ()
  "alert a have a rest msg"
  (interactive)
  (express-message-popup  "It really is time to take a break")
  ;;(org-timer-set-timer 5)
;;  (setq org-mode-line-string "休息中...")
)

(setq org-agenda-span 'day)

;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)

(define-key global-map "\C-cr"
  (lambda () (interactive) (org-capture nil "m")))
(define-key global-map "\C-cd"
  (lambda () (interactive) (org-capture nil "d")))

(global-set-key (kbd "<f12>") (lambda () (interactive)(switch-to-buffer "*Org Agenda*")(org-agenda-redo)))



;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file (concat my-idea-home "org/mygtd.org"))
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file (concat my-idea-home "org/mygtd.org"))
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file (concat my-idea-home "org/mygtd.org"))
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file (concat my-idea-home "org/mygtd.org"))
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file+headline (concat my-idea-home "org/mygtd.org") "Meeting")
               "* [#A] [/]   %?  SCHEDULED:%t   :MEETING:\n%U" )
              ("p" "Phone call" entry (file (concat my-idea-home "org/mygtd.org"))
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("d" "Development" entry (file+headline (concat my-idea-home "org/mygtd.org") "Development")
               "* TODO [#A] [/] %? %u SCHEDULED:%t:OFFICE:\n" )
              ("h" "Habit" entry (file (concat my-idea-home "org/mygtd.org"))
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;;http://doc.norang.ca/org-mode.html
;;18.38 Remove Multiple State Change Log Details From The Agenda
;;I skip multiple timestamps for the same entry in the agenda view with the following setting.

(setq org-agenda-skip-additional-timestamps-same-entry t)

(require 'org-crypt)
; Encrypt all entries before saving
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
; GPG key to use for encryption
(setq org-crypt-key "F0B66B40")


;;Enable Auto Fill mode
(defun my-org-mode-hook ()

(setq-default fill-column 130)
(auto-fill-mode 1))

(add-hook 'org-mode-hook 'my-org-mode-hook)

(defun cw/tasks-last-week ()
  "Produces an org agenda tags view list of all the tasks completed
last week."

  (interactive)
    (org-tags-view nil
          (concat

           (format-time-string "+CLOSED>=\"[%Y-%m-%d]\"" (time-subtract (current-time)
                                                  (seconds-to-time (* 7 24 60 60))))
           (format-time-string "+CLOSED<=\"[%Y-%m-%d]\""  (current-time)))))

(defun cw/tasks-last-month ()
  "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."
  (interactive)
    (org-tags-view nil
          (concat
           (format-time-string "+CLOSED>=\"[%Y-%m-%d]\"" (time-subtract (current-time)
                                                  (seconds-to-time (* 30 24 60 60))))
           (format-time-string "+CLOSED<=\"[%Y-%m-%d]\""  (current-time)))))

(defun cw/tasks-last-year ()
  "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."

  (interactive)
    (org-tags-view nil
          (concat

           (format-time-string "+CLOSED>=\"[%Y-%m-%d]\"" (time-subtract (current-time)
                                                  (seconds-to-time (* 365 24 60 60))))
           (format-time-string "+CLOSED<=\"[%Y-%m-%d]\""  (current-time)))))



;;; end added by standino


(provide 'init-org)
