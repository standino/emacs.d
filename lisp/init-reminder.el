;;; cw-reminder.el --- popup window to reminde me.

;; Copyright (C) 2008  Will

;; Author: Will <will@will-laptop>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; ;;
;; cw-reminder.el
;;
;; Made by Will
;; Login   <will@will-laptop>
;;
;; Started on  Thu Dec 11 11:25:33 2008 Will
;; Last update Wed May  5 14:58:06 2010 Will
;;

;;(setq appt-display-format 'popup)
;;(defvar zendisp "zenity --info --title='Appointment' ")
;;(defun appt-display-message (string mins)
;;  "Display a reminder about an appointment.
;;The string STRING describes the appointment, due in integer MINS minutes.
;;The format of the visible reminder is controlled by `appt-display-format'.
;;The variable `appt-audible' controls the audible reminder."
;;  ;; let binding for backwards compatability. Remove when obsolete
;;  ;; vars appt-msg-window and appt-visible are dropped.
;;  (let ((appt-display-format
;;         (if (eq appt-display-format 'ignore)
;;         (cond (appt-msg-window 'window)
;;           (appt-visible 'echo))
;;           appt-display-format)))
;;    (cond ((eq appt-display-format 'window)
;;           (funcall appt-disp-window-function
;;                    (number-to-string mins)
;;                    ;; TODO - use calendar-month-abbrev-array rather
;;                    ;; than %b?
;;                    (format-time-string "%a %b %e " (current-time))
;;                    string)
;;           (run-at-time (format "%d sec" appt-display-duration)
;;                        nil
;;                        appt-delete-window-function))
;;          ((eq appt-display-format 'echo)
;;           (message "%s" string))
;;          ((eq appt-display-format 'popup)
;;           (shell-command (concat zendisp
;;                  " --text='"
;;                  string
;;                  "'"
;;                  )))
;;
;;      )
;;    (if appt-audible (beep 1))))
;;
;;; Code:

;;---------------------------------------------------------------------------------
;;Setting up appointment reminders in Org

;; Make appt aware of appointments from the agenda
;;(defun org-agenda-to-appt ()
;;  "Activate appointments found in `org-agenda-files'."
;;  (interactive)
;;  (require 'org)
;;  (let* ((today (org-date-to-gregorian
;;               (time-to-days (current-time))))
;;       (files org-agenda-files) entries file)
;;    (while (setq file (pop files))
;;      (setq entries (append entries (org-agenda-get-day-entries
;;                                   file today :timestamp))))
;;    (setq entries (delq nil entries))
;;    (mapc (lambda(x)
;;          (let* ((event (org-trim (get-text-property 1 'txt x)))
;;                 (time-of-day (get-text-property 1 'time-of-day x)) tod)
;;            (when time-of-day
;;              (setq tod (number-to-string time-of-day)
;;                    tod (when (string-match
;;                                "\\([0-9]\\{1,2\\}\\)\\([0-9]\\{2\\}\\)" tod)
;;                           (concat (match-string 1 tod) ":"
;;                                   (match-string 2 tod))))
;;              (if tod (appt-add tod event))))) entries)))
;;
;;(org-agenda-to-appt)
;;
;;(defadvice org-agenda-to-appt (before wickedcool activate)
;;  "Clear the appt-time-msg-list."
;;  (setq appt-time-msg-list nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; For org appointment reminders
;;
;;;; Get appointments for today
(defun my-org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (let ((org-deadline-warning-days 0))    ;; will be automatic in org 5.23
    (org-agenda-to-appt)))

;; Run once, activate and schedule refresh
(my-org-agenda-to-appt)
(appt-activate t)
(run-at-time "24:01" nil 'my-org-agenda-to-appt)

(setq appt-issue-message t)
(setq appt-message-warning-time '1)
(setq appt-display-interval '1)

(setq org-deadline-warning-days '1)
                                        ; Update appt each time agenda opened.
(add-hook 'org-finalize-agenda-hook 'my-org-agenda-to-appt)

                                        ; Setup zenify, we tell appt to use window, and replace default function
(setq appt-display-format 'window)
(setq appt-disp-window-function (function my-appt-disp-window))

(require-package 'express)
(express-install-aliases)

;;(express-message-popup "teste")

(defun my-appt-disp-window (min-to-app new-time msg)
  (save-window-excursion
    (express-message-popup (string-replace-all "<" "[]" msg))
    )
  )


(provide 'init-reminder)
;;; cw-reminder.el ends here
