(require 'org)

(require 'cal-dst)

;;把Log信息放到抽屉里
(setq org-log-into-drawer t)
(setq org-clock-into-drawer t)

(defun gtd ()
   (interactive)
   (find-file (concat my-idea-home "org/mygtd.org"))
 )
;;(custom-set-variables
;; ;; custom-set-variables was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(ac-sources (quote (ac-source-imenu ac-source-abbrev ac-source-words-in-buffer ac-source-files-in-current-dir ac-source-filename)) t)
;; '(tool-bar-mode nil))

(custom-set-variables

 '(org-remember-store-without-prompt t)
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler)))
'(org-agenda-files (quote ("~/../org/mygtd.org")))
 '(org-default-notes-file (concat my-idea-home "org/mygtd.org"))
 '(org-directory (concat my-idea-home "org/"))
 '(org-agenda-ndays 7)
 '(org-deadline-warning-days 14)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-reverse-note-order t)
 '(org-fast-tag-selection-single-key (quote expert))
)

(setq org-agenda-include-diary t)

(defun sacha/org-show-load ()
  "Show my unscheduled time and free time for the day."
  (interactive)
  (let ((time (sacha/org-calculate-free-time
               ;; today
               (calendar-gregorian-from-absolute (time-to-days (current-time)))
               ;; now
               (let* ((now (decode-time))
                      (cur-hour (nth 2 now))
                      (cur-min (nth 1 now)))
                 (+ (* cur-hour 60) cur-min))
               ;; until the last time in my time grid
               (let ((last (car (last (elt org-agenda-time-grid 2)))))
                 (+ (* (/ last 100) 60) (% last 100))))))
    (message "%.1f%% load: %d minutes to be scheduled, %d minutes free, %d minutes gap\n"
            (/ (car time) (* .01 (cdr time)))
            (car time)
            (cdr time)
            (- (cdr time) (car time)))))

(defun sacha/org-agenda-load (match)
  "Can be included in `org-agenda-custom-commands'."
  (let ((inhibit-read-only t)
        (time (sacha/org-calculate-free-time
               ;; today
               (calendar-gregorian-from-absolute org-starting-day)
               ;; now if today, else start of day
               (if (= org-starting-day
                      (time-to-days (current-time)))
                   (let* ((now (decode-time))
                          (cur-hour (nth 2 now))
                          (cur-min (nth 1 now)))
                     (+ (* cur-hour 60) cur-min))
                 (let ((start (car (elt org-agenda-time-grid 2))))
                   (+ (* (/ start 100) 60) (% start 100))))
                 ;; until the last time in my time grid
               (let ((last (car (last (elt org-agenda-time-grid 2)))))
                 (+ (* (/ last 100) 60) (% last 100))))))
    (goto-char (point-max))
    (insert (format
             "%.1f%% load: %d minutes to be scheduled, %d minutes free, %d minutes gap\n"
             (/ (car time) (* .01 (cdr time)))
             (car time)
             (cdr time)
             (- (cdr time) (car time))))))

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
;;           :link t
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

(defun cw/org-agenda-clock-thisweek (match)
  ;; Find out when today is
  (let* ((inhibit-read-only t))
    (goto-char (point-max))
    (insert  "\n\nTasks done in this week: \n")
    (org-dblock-write:clocktable
     `(:scope agenda
       :maxlevel 8
	   :block thisweek
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
          (tags "OFFICE")
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
        ("A" "priority A"
         ((tags "//#A" ))
         )
        ;;("n" "Next 21 days"
        ;; ((agenda) 
        ;;  (org-agenda-ndays 21)))
        ;;        ("A" agenda ""
        ;;         ((org-agenda-skip-function
        ;;           (lambda nil
        ;;             (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
        ;;          (org-agenda-ndays 1)
        ;;          (org-agenda-overriding-header "Today's Priority #A tasks: ")))
        ;;        ("u" alltodo ""
        ;;         ((org-agenda-skip-function
        ;;           (lambda nil
        ;;             (org-agenda-skip-entry-if (quote scheduled) (quote deadline)
        ;;                                       (quote regexp) "<[^>\n]+>")))
        ;;          (org-agenda-overriding-header "Unscheduled TODO entries: ")))
        
        ("T" todo-tree "TODO")
        ("W" todo-tree "WAITING")
        ("u" "Unscheduled" ((sacha/org-agenda-list-unscheduled)))
        ("v" tags-todo "+BOSS-URGENT")
        ("U" tags-tree "+BOSS-URGENT")
        ("f" occur-tree "\\<FIXME\\>")
        )
      )

;; List all the unscheduled TODO entries
(defun sacha/org-agenda-list-unscheduled (&rest ignore)
  "Create agenda view for tasks that are unscheduled and not done."
  (let* ((org-agenda-todo-ignore-with-date t)
	 (org-agenda-overriding-header "List of unscheduled tasks: "))
    (org-agenda-get-todos)))

;;
(my-require 'remember)



(define-key global-map [(control meta ?r)] 'remember)

(custom-set-variables
'(org-remember-store-without-prompt t)
'(org-remember-templates
   (quote ((116 "* TODO %?\n  %u :OFFICE: \n what are the results:     " (concat my-idea-home "org/mygtd.org") "Tasks")
           (110 "* %u %?                                               " (concat my-idea-home "org/mygtd.org") "Notes")
           (?o "* TODO [#A] [/]  %?   %u  SCHEDULED:%t  :OFFICE: \n    " (concat my-idea-home "org/mygtd.org") "Management")
           (?d "* TODO [#A] [/]  %?   %u  SCHEDULED:%t  :OFFICE: \n    " (concat my-idea-home "org/mygtd.org") "Development")
           (?m "* TODO [#A] [/]  %?       SCHEDULED:%t  :OFFICE: \n    " (concat my-idea-home "org/mygtd.org") "Meeting")
           (?i "* TODO [#A] [/]  %?   %u  SCHEDULED:%t  :OFFICE: \n    " (concat my-idea-home "org/mygtd.org") "Innovation")
)))
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler))))

(add-hook 'remember-mode-hook 'org-remember-apply-template)

(eval-after-load "org"
  '(progn
(define-prefix-command 'org-todo-state-map)

(define-key org-mode-map "\C-cx" 'org-todo-state-map)

(define-key org-todo-state-map "x"
#'(lambda nil (interactive) (org-todo "CANCELLED")))
(define-key org-todo-state-map "d"
#'(lambda nil (interactive) (org-todo "DONE")))
(define-key org-todo-state-map "f"
#'(lambda nil (interactive) (org-todo "DEFERRED")))
(define-key org-todo-state-map "l"
#'(lambda nil (interactive) (org-todo "DELEGATED")))
(define-key org-todo-state-map "s"
#'(lambda nil (interactive) (org-todo "STARTED")))
(define-key org-todo-state-map "w"
#'(lambda nil (interactive) (org-todo "WAITING")))
))


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

(defun have-a-rest ()
  "alert a have a rest msg"
  (interactive)
  (shell-command  "msg changwei 'It really is time to take a break'")
  ;;(org-timer-set-timer 5)
;;  (setq org-mode-line-string "休息中...")
)      

;; use appt-convert-time instead if appt is loaded
(defun iy/convert-time (time2conv)
  "Convert hour:min[am/pm] format TIME2CONV to minutes from midnight.
A period (.) can be used instead of a colon (:) to separate the
hour and minute parts."
  ;; Formats that should be accepted:
  ;; 10:00 10.00 10h00 10h 10am 10:00am 10.00am
  (let ((min (if (string-match "[h:.]\\([0-9][0-9]\\)" time2conv)
                 (string-to-number (match-string 1 time2conv))
               0))
        (hr (if (string-match "[0-9]*[0-9]" time2conv)
                (string-to-number (match-string 0 time2conv))
              0)))
    ;; Convert the time appointment time into 24 hour time.
    (cond ((and (string-match "pm" time2conv) (< hr 12))
           (setq hr (+ 12 hr)))
          ((and (string-match "am" time2conv) (= hr 12))
           (setq hr 0)))
    ;; Convert the actual time into minutes.
    (+ (* hr 60) min)))
 
(defun iy/org-get-entries (files date)
  (let (entry entries)
    (dolist (file files)
      (catch 'nextfile
        (org-check-agenda-file file)
        (setq entry (org-agenda-get-day-entries
                     file date :scheduled :timestamp))
        (setq entries (append entry entries))))
    entries))
 
(defun sacha/org-calculate-free-time (date start-time end-of-day)
  "Return a cons cell of the form (TASK-TIME . FREE-TIME) for DATE, given START-TIME and END-OF-DAY.
DATE is a list of the form (MONTH DAY YEAR).
START-TIME and END-OF-DAY are the number of minutes past midnight."
  (save-window-excursion
    (let* ((entries (iy/org-get-entries (org-agenda-files) date))
           (total-unscheduled 0)
           (total-gap 0)
           (last-timestamp start-time)
           scheduled-entries)
      ;; For each item on the list
      (dolist (entry entries)
        (let ((time (get-text-property 1 'time entry))
              (effort (get-text-property 1 'org-hd-marker entry)))
          (cond
           ((and time
                 (string-match "\\([^-]+\\)-\\([^-]+\\)" time))
            (push (cons
                   (save-match-data (iy/convert-time (match-string 1 time)))
                   (save-match-data (iy/convert-time (match-string 2 time))))
                  scheduled-entries))
           ((and time
                 (string-match "\\([^-]+\\)\\.+" time)
                 (not (eq effort nil)))
            (let ((start (save-match-data (iy/convert-time (match-string 1 time))))
                  (effort (save-match-data (iy/convert-time effort))))
              (push (cons start (+ start effort)) scheduled-entries)))
           ((not (eq effort nil))
            (setq total-unscheduled (+ (iy/convert-time effort)
                                       total-unscheduled))))))
      ;; Sort the scheduled entries by time
      (setq scheduled-entries (sort scheduled-entries (lambda (a b) (< (car a) (car b)))))
      (while scheduled-entries
        (let ((start (car (car scheduled-entries)))
              (end (cdr (car scheduled-entries))))
          (cond
           ;; are we in the middle of this timeslot?
           ((and (>= last-timestamp start)
                 (<= last-timestamp end))
            ;; move timestamp later, no change to time
            (setq last-timestamp end))
           ;; are we completely before this timeslot?
           ((< last-timestamp start)
            ;; add gap to total, skip to the end
            (setq total-gap (+ (- start last-timestamp) total-gap))
            (setq last-timestamp end)))
          (setq scheduled-entries (cdr scheduled-entries))))
      (if (< last-timestamp end-of-day)
          (setq total-gap (+ (- end-of-day last-timestamp) total-gap)))
      (cons total-unscheduled total-gap))))


(setq org-publish-project-alist
      '(("org"
         :base-directory (concat my-idea-home "org/")
         :publishing-directory (concat my-idea-home "/../public_html/org/")
         :section-numbers 1
         :table-of-contents 1
         :auto-sitemap 1
         :makeindex 2
         :style "<link rel=\"stylesheet\" href=\"../other/mystyle.css\" type=\"text/css\"/>")))


;; use appt-convert-time instead if appt is loaded
(defun iy/convert-time (time2conv)
  "Convert hour:min[am/pm] format TIME2CONV to minutes from midnight.
A period (.) can be used instead of a colon (:) to separate the
hour and minute parts."
  ;; Formats that should be accepted:
  ;; 10:00 10.00 10h00 10h 10am 10:00am 10.00am
  (let ((min (if (string-match "[h:.]\\([0-9][0-9]\\)" time2conv)
                 (string-to-number (match-string 1 time2conv))
               0))
        (hr (if (string-match "[0-9]*[0-9]" time2conv)
                (string-to-number (match-string 0 time2conv))
              0)))
    ;; Convert the time appointment time into 24 hour time.
    (cond ((and (string-match "pm" time2conv) (< hr 12))
           (setq hr (+ 12 hr)))
          ((and (string-match "am" time2conv) (= hr 12))
           (setq hr 0)))
    ;; Convert the actual time into minutes.
    (+ (* hr 60) min)))

(defun iy/org-get-entries (files date)
  (let (entry entries)
    (dolist (file files)
      (catch 'nextfile
        (org-check-agenda-file file)
        (setq entry (org-agenda-get-day-entries
                     file date :scheduled :timestamp))
        (setq entries (append entry entries))))
    entries))

(defun sacha/org-calculate-free-time (date start-time end-of-day)
  "Return a cons cell of the form (TASK-TIME . FREE-TIME) for DATE, given START-TIME and END-OF-DAY.
DATE is a list of the form (MONTH DAY YEAR).
START-TIME and END-OF-DAY are the number of minutes past midnight."
  (save-window-excursion
    (let* ((entries (iy/org-get-entries (org-agenda-files) date))
           (total-unscheduled 0)
           (total-gap 0)
           (last-timestamp start-time)
           scheduled-entries)
      ;; For each item on the list
      (dolist (entry entries)
        (let ((time (get-text-property 1 'time entry))
              (effort (org-get-effort (get-text-property 1 'org-hd-marker entry))))
          (cond
           ((and time
                 (string-match "\\([^-]+\\)-\\([^-]+\\)" time))
            (push (cons
                   (save-match-data (iy/convert-time (match-string 1 time)))
                   (save-match-data (iy/convert-time (match-string 2 time))))
                  scheduled-entries))
           ((and time
                 (string-match "\\([^-]+\\)\\.+" time)
                 (not (eq effort nil)))
            (let ((start (save-match-data (iy/convert-time (match-string 1 time))))
                  (effort (save-match-data (iy/convert-time effort))))
              (push (cons start (+ start effort)) scheduled-entries)))
           ((not (eq effort nil))
            (setq total-unscheduled (+ (iy/convert-time effort)
                                       total-unscheduled))))))
      ;; Sort the scheduled entries by time
      (setq scheduled-entries (sort scheduled-entries (lambda (a b) (< (car a) (car b)))))
      (while scheduled-entries
        (let ((start (car (car scheduled-entries)))
              (end (cdr (car scheduled-entries))))
          (cond
           ;; are we in the middle of this timeslot?
           ((and (>= last-timestamp start)
                 (<= last-timestamp end))
            ;; move timestamp later, no change to time
            (setq last-timestamp end))
           ;; are we completely before this timeslot?
           ((< last-timestamp start)
            ;; add gap to total, skip to the end
            (setq total-gap (+ (- start last-timestamp) total-gap))
            (setq last-timestamp end)))
          (setq scheduled-entries (cdr scheduled-entries))))
      (if (< last-timestamp end-of-day)
          (setq total-gap (+ (- end-of-day last-timestamp) total-gap)))
      (cons total-unscheduled total-gap))))



;; Weekly review

(defun sacha/quantified-get-hours (category time-summary)
        "Return the number of hours based on the time summary."
        (if (stringp category)
           (if (assoc category time-summary) (/ (cdr (assoc category time-summary)) 3600.0) 0)
          (apply '+ (mapcar (lambda (x) (sacha/quantified-get-hours x time-summary)) category))))
(defun sacha/org-summarize-focus-areas ()
  "Summarize previous and upcoming tasks as a list."
  (interactive)
  (let ((base-date (apply 'encode-time (org-read-date-analyze "-fri" nil '(0 0 0))))
        business relationships life business-next relationships-next life-next string start end time-summary
        biz-time)
    (setq start (format-time-string "%Y-%m-%d" (days-to-time (- (time-to-number-of-days base-date) 6))))
    (setq end (format-time-string "%Y-%m-%d" (days-to-time (1+ (time-to-number-of-days base-date)))))
;;    (setq time-summary (quantified-summarize-time start end))
    (setq biz-time (sacha/quantified-get-hours "Business" time-summary))
    (save-window-excursion
      (org-agenda nil "w")
      (setq string (buffer-string))
      (with-temp-buffer
        (insert string)
        (goto-char (point-min))
        (while (re-search-forward "^  \\([^:]+\\): +\\(Sched[^:]+: +\\)?TODO \\(.*?\\)\\(?:[      ]+\\(:[[:alnum:]_@#%:]+:\\)\\)?[        ]*$" nil t)
          (cond
           ((string= (match-string 1) "routines") nil) ; skip routine tasks
           ((string= (match-string 1) "business")
            (add-to-list 'business-next (concat "  - [ ] " (match-string 3))))
           ((string= (match-string 1) "people")
            (add-to-list 'relationships-next (concat "  - [ ] " (match-string 3))))
           (t (add-to-list 'life-next (concat "  - [ ] " (match-string 3))))))))
    (save-window-excursion
      (org-agenda nil "w")
      (org-agenda-later -1)
      (org-agenda-log-mode 16)
      (setq string (buffer-string))
      (with-temp-buffer
        (insert string)
        (goto-char (point-min))
        (while (re-search-forward "^  \\([^:]+\\): +.*?State:.*?\\(?:TODO\\|DONE\\) \\(.*?\\)\\(?:[       ]+\\(:[[:alnum:]_@#%:]+:\\)\\)?[        ]*$" nil t)
          (cond
           ((string= (match-string 1) "routines") nil) ; skip routine tasks
           ((string= (match-string 1) "business")
            (add-to-list 'business (concat "  - [X] " (match-string 2))))
           ((string= (match-string 1) "people")
            (add-to-list 'relationships (concat "  - [X] " (match-string 2))))
           (t (add-to-list 'life (concat "  - [X] " (match-string 2))))))))
    (setq string
          (concat
           (format "- *Business* (%.1fh - %d%%)\n" biz-time (/ biz-time 1.68))
           (mapconcat 'identity (sort business 'string<) "\n") "\n"
           (mapconcat 'identity (sort business-next 'string<) "\n")
           "\n"
           (format "  - *Earn* (%.1fh - %d%% of Business)\n"
                   (sacha/quantified-get-hours "Business - Earn" time-summary)
                   (/ (sacha/quantified-get-hours "Business - Earn" time-summary) (* 0.01 biz-time)))
           (format "  - *Build* (%.1fh - %d%% of Business)\n"
                   (sacha/quantified-get-hours "Business - Build" time-summary)
                   (/ (sacha/quantified-get-hours "Business - Build" time-summary) (* 0.01 biz-time)))
           (format "    - *Quantified Awesome* (%.1fh)\n"
                   (sacha/quantified-get-hours "Business - Build - Quantified Awesome" time-summary))
           (format "    - *Drawing* (%.1fh)\n"
                   (sacha/quantified-get-hours '("Business - Build - Drawing" "Business - Build - Book review")  time-summary))
           (format "    - *Paperwork* (%.1fh)\n"
                   (sacha/quantified-get-hours "Business - Build - Paperwork"  time-summary))
           (format "  - *Connect* (%.1fh - %d%% of Business)\n"
                   (sacha/quantified-get-hours "Business - Connect" time-summary)
                   (/ (sacha/quantified-get-hours "Business - Connect" time-summary) (* 0.01 biz-time)))
           (format "- *Relationships* (%.1fh - %d%%)\n"
                   (sacha/quantified-get-hours '("Discretionary - Social" "Discretionary - Family") time-summary)
                   (/ (sacha/quantified-get-hours '("Discretionary - Social" "Discretionary - Family") time-summary) 1.68))
           (mapconcat 'identity (sort relationships 'string<) "\n") "\n"
           (mapconcat 'identity (sort relationships-next 'string<) "\n")
           "\n"
           (format "- *Discretionary - Productive* (%.1fh - %d%%)\n"
                   (sacha/quantified-get-hours "Discretionary - Productive" time-summary)
                   (/ (sacha/quantified-get-hours "Discretionary - Productive" time-summary) 1.68))
           (mapconcat 'identity (sort life 'string<) "\n") "\n"
           (mapconcat 'identity (sort life-next 'string<) "\n") "\n"
           (format "  - *Writing* (%.1fh)\n"
                   (sacha/quantified-get-hours "Discretionary - Productive - Writing" time-summary))
           (format "- *Discretionary - Play* (%.1fh - %d%%)\n"
                   (sacha/quantified-get-hours "Discretionary - Play" time-summary)
                   (/ (sacha/quantified-get-hours "Discretionary - Play" time-summary) 1.68))
           (format "- *Personal routines* (%.1fh - %d%%)\n"
                   (sacha/quantified-get-hours "Personal" time-summary)
                   (/ (sacha/quantified-get-hours "Personal" time-summary) 1.68))
           (format "- *Unpaid work* (%.1fh - %d%%)\n"
                   (sacha/quantified-get-hours "Unpaid work" time-summary)
                   (/ (sacha/quantified-get-hours "Unpaid work" time-summary) 1.68))
           (format "- *Sleep* (%.1fh - %d%% - average of %.1f per day)\n"
                   (sacha/quantified-get-hours "Sleep" time-summary)
                   (/ (sacha/quantified-get-hours "Sleep" time-summary) 1.68)
                   (/ (sacha/quantified-get-hours "Sleep" time-summary) 7)
                   )))
    (if (called-interactively-p 'any)
        (insert string)
      string)))

(defun sacha/org-prepare-weekly-review ()
  "Prepare weekly review template."
  (interactive)
  (let ((base-date (apply 'encode-time (org-read-date-analyze "-fri" nil '(0 0 0))))
        (org-agenda-files '((concat my-idea-home "org/mygtd.org" ))))
    (insert
       (concat
        "*** Weekly review: Week ending " (format-time-string "%B %e, %Y" base-date) "  :weekly:\n"
        "*Blog posts*\n\n"
        "*Focus areas and time review*\n\n"
        (sacha/org-summarize-focus-areas)
        "\n"))))


(require 'calendar)

(setq org-log-done 'time)

(defun jtc-org-tasks-closed-in-month (&optional month year match-string)
  "Produces an org agenda tags view list of the tasks completed 
in the specified month and year. Month parameter expects a number 
from 1 to 12. Year parameter expects a four digit number. Defaults 
to the current month when arguments are not provided. Additional search
criteria can be provided via the optional match-string argument "
  (interactive)
  (let* ((today (calendar-current-date))
         (for-month (or month (calendar-extract-month today)))
         (for-year  (or year  (calendar-extract-year today))))
    (org-tags-view nil 
          (concat
           match-string
           (format "+CLOSED>=\"[%d-%02d-01]\"" 
                   for-year for-month)
           (format "+CLOSED<=\"[%d-%02d-%02d]\"" 
                   for-year for-month 
                   (calendar-last-day-of-month for-month for-year))))))

(defun jtc-foo-tasks-last-month ()
  "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."
  (interactive)
  (let* ((today (calendar-current-date))
         (for-month (calendar-extract-month today))
         (for-year  (calendar-extract-year today)))
       (calendar-increment-month for-month for-year 0)
       (jtc-org-tasks-closed-in-month 
        for-month for-year "")))


(defun cw-tasks-last-week ()
  "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."

  (interactive)
    (org-tags-view nil 
          (concat

           (format-time-string "+CLOSED>=\"[%Y-%m-%d]\"" (time-subtract (current-time)
                                                  (seconds-to-time (* 7 24 60 60))))
           (format-time-string "+CLOSED<=\"[%Y-%m-%d]\""  (current-time)))))

(defun cw-tasks-last-month ()
  "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."
  (interactive)
    (org-tags-view nil 
          (concat
           (format-time-string "+CLOSED>=\"[%Y-%m-%d]\"" (time-subtract (current-time)
                                                  (seconds-to-time (* 30 24 60 60))))
           (format-time-string "+CLOSED<=\"[%Y-%m-%d]\""  (current-time)))))

(defun cw-tasks-last-year ()
  "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."

  (interactive)
    (org-tags-view nil 
          (concat

           (format-time-string "+CLOSED>=\"[%Y-%m-%d]\"" (time-subtract (current-time)
                                                  (seconds-to-time (* 365 24 60 60))))
           (format-time-string "+CLOSED<=\"[%Y-%m-%d]\""  (current-time)))))


;;可以编写中文的ppt

(require 'org-latex)
;;两个"@"不能生成alert效果？
;;    这个可能是 org-mode 本身的 bug，但可以通过修改 Emacs 里的设置来解决。在 (require 'org-latex) 前加入这一段设置：
(setq org-emphasis-alist (quote (("*" bold "<b>" "</b>") 
                                 ("/" italic "<i>" "</i>")
                                 ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
                                 ("=" org-code "<code>" "</code>" verbatim)
                                 ("~" org-verbatim "<code>" "</code>" verbatim)
                                 ("+" (:strike-through t) "<del>" "</del>")
                                 ("@" org-warning "<b>" "</b>")))
      org-export-latex-emphasis-alist (quote 
                                       (("*" "\\textbf{%s}" nil)
                                        ("/" "\\emph{%s}" nil) 
                                        ("_" "\\underline{%s}" nil)
                                        ("+" "\\texttt{%s}" nil)
                                        ("=" "\\verb=%s=" nil)
                                        ("~" "\\verb~%s~" t)
                                        ("@" "\\alert{%s}" nil)))
      )


(setq org-latex-to-pdf-process '("xelatex -interaction nonstopmode %f"
                                 "xelatex -interaction nonstopmode %f"))
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                                 "xelatex -interaction nonstopmode %f"))

(add-to-list 'org-export-latex-classes 
'("beamer-cn" 
     "\\documentclass{beamer}
     \\usepackage{xeCJK} 
     \\setCJKmainfont{SimSun}"  
     org-beamer-sectioning
     ))






(provide 'cw-org)



