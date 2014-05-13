;;; express-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "express" "express.el" (21358 54648 0 0))
;;; Generated autoloads from express.el

(let ((loads (get 'express 'custom-loads))) (if (member '"express" loads) nil (put 'express 'custom-loads (cons '"express" loads))))

(defvar express-install-short-aliases nil "\
Install short aliases such as `message-nolog' for `express-message-nolog'.")

(custom-autoload 'express-install-short-aliases "express" t)

(defun express-install-aliases (&optional arg) "\
Install aliases outside the \"express-\" namespace.

With optional negative ARG, uninstall aliases.

The following aliases will be installed:

   message-nolog      for   express-message-nolog
   message-logonly    for   express-message-logonly
   message-noformat   for   express-message-noformat
   message-highlight  for   express-message-highlight
   message-insert     for   express-message-insert
   message-notify     for   express-message-notify
   message-popup      for   express-message-popup
   message-temp       for   express-message-temp" (let ((syms (quote (nolog logonly highlight insert noformat notify popup temp string)))) (cond ((and (numberp arg) (< arg 0)) (dolist (sym syms) (when (ignore-errors (eq (symbol-function (intern-soft (format "message-%s" sym))) (intern-soft (format "express-message-%s" sym)))) (fmakunbound (intern (format "message-%s" sym)))) (when (ignore-errors (eq (symbol-function (intern-soft (format "with-message-%s" sym))) (intern-soft (format "express-with-message-%s" sym)))) (fmakunbound (intern (format "with-message-%s" sym)))))) (t (dolist (sym syms) (defalias (intern (format "message-%s" sym)) (intern (format "express-message-%s" sym))) (defalias (intern (format "with-message-%s" sym)) (intern (format "express-with-message-%s" sym))))))))

(when express-install-short-aliases (express-install-aliases))

(autoload 'express-message-noformat "express" "\
An alternative for `message' which assumes a pre-formatted CONTENT string.

Any arguments after CONTENT are ignored, meaning this is not
functionally equivalent to `message'.  However, flet'ing
`message' to this function is safe in the sense that it does not
call `message' directly.

\(fn CONTENT &rest IGNORED)" nil nil)

(autoload 'express-message-logonly "express" "\
An flet'able replacement for `message' which logs but does not echo.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-insert "express" "\
An flet'able replacement for `message' which inserts text instead of echoing.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-string "express" "\
An flet'able replacement for `message' which returns a string instead of echoing.

Newline is appended to the return value as with `message'.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-nolog "express" "\
An flet'able replacement for `message' which echos but does not log.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-temp "express" "\
An flet'able replacement for `message' which displays temporarily.

The display time is governed by `express-message-seconds'.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-popup "express" "\
An flet'able replacement for `message' which uses popups instead of echoing.

The functions `popup-volatile' and `popup' are attempted in
order to create a popup.  If both functions fail, the message
content will appear in the echo area as usual.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-notify "express" "\
An flet'able replacement for `message' which uses notifications instead echo.

The following functions are attempted in order call system
notifications: `notify' and `todochiku-message'.  If both
functions fail, the message content will appear in the echo
area as usual.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express-message-highlight "express" "\
An flet'able replacement for `message' which echos highlighted text.

Text without added properties is logged to the messages buffer as
usual.

ARGS are as for `message', including a format-string.

\(fn &rest ARGS)" nil nil)

(autoload 'express "express" "\
Transiently and noticeably display CONTENT in the echo area.

CONTENT should be a pre-`format'ted if it is a string.

CONTENT will be coerced to a string if it is not a string.

Optional QUIET suppresses the bell, which is on by default.

Optional SECONDS determines the number of seconds CONTENT will be
displayed before reverting to the previous content of the echo
area.  Default is `express-message-seconds'.  If SECONDS is 0, or
non-numeric, the message is not timed out, and remains visible
until the next write to the echo area.

Optional NOCOLOR suppresses coloring the message with face held
in the variable `express-face'.

Optional LOG enables logging of CONTENT for any non-nil value.
If LOG is 'log-only, then CONTENT goes only to the *Messages*
buffer and all other options are ignored.

Optional NOTIFY enables sending the message via the notifications
system of the underlying OS.  The default is nil.  If NOTIFY is
'replace-echo, then the notification will be used instead of the
echo area.  For any other non-nil value, the notification will be
used in addition to the echo area.

Optional POPUP enables sending the message via `popup-tip' from
popup.el.  The default is nil.  If POPUP is 'replace-echo, then
the popup will be used instead of the echo area.  For any other
non-nil value, the popup will be used in addition to the echo
area.

The behavior of `express' is very different from `message':

  - CONTENT must already be formatted.

  - Non-strings are accepted for CONTENT.

  - The content is displayed with added color.

  - The bell is rung.

  - CONTENT is not written to the messages buffer (log).

  - After display, the previous contents of the echo area are
    restored.

The following forms using `message` and `express` are equivalent:

   (message \"hello, %s\" name)
   (express (format \"hello, %s\" name) 'quiet 0 'nocolor 'log)

\(fn CONTENT &optional QUIET SECONDS NOCOLOR LOG NOTIFY POPUP)" nil nil)

(autoload 'express* "express" "\
An alternate version of `express' which uses Common Lisp semantics.

CONTENT, QUIET, SECONDS, NOCOLOR, LOG, NOTIFY, and POPUP are as
documented for `express'.

\(fn CONTENT &key QUIET SECONDS NOCOLOR LOG NOTIFY POPUP)" nil nil)

(autoload 'express-with-message-logonly "express" "\
Execute BODY, redirecting the output of `message' to the log only.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-logonly 'lisp-indent-function '0)

(autoload 'express-with-message-nolog "express" "\
Execute BODY, keeping the output of `message' from being added to the log.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-nolog 'lisp-indent-function '0)

(autoload 'express-with-message-highlight "express" "\
Execute BODY, highlighting the output of `message'.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-highlight 'lisp-indent-function '0)

(autoload 'express-with-message-notify "express" "\
Execute BODY, redirecting the output of `message' to system notifications.

notify.el or todochiku.el may be used to provide the interface to
system notifications.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-notify 'lisp-indent-function '0)

(autoload 'express-with-message-popup "express" "\
Execute BODY, redirecting the output of `message' to popups.

popup.el is required.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-popup 'lisp-indent-function '0)

(autoload 'express-with-message-insert "express" "\
Execute BODY, redirecting the output of `message' to `insert'.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-insert 'lisp-indent-function '0)

(autoload 'express-with-message-string "express" "\
Execute BODY, capturing the output of `message' to a string.

Accumulated message output is returned.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-string 'lisp-indent-function '0)

(autoload 'express-with-message-temp "express" "\
Execute BODY, making all `message' output temporary.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-temp 'lisp-indent-function '0)

(autoload 'express-with-message-noformat "express" "\
Execute BODY, keeping `message' from formatting its arguments.

All arguments to `message' after the first one will be dropped.

Note that since `message' is a subr, only calls to `message' from
Lisp will be affected.

\(fn &rest BODY)" nil t)

(function-put 'express-with-message-noformat 'lisp-indent-function '0)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; express-autoloads.el ends here