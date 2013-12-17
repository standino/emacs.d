(setq hippie-expand-try-functions-list
      '(try-expand-line
        try-expand-dabbrev
        try-expand-line-all-buffers
        try-expand-list
        try-expand-list-all-buffers
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name
        try-complete-file-name-partially
        try-complete-lisp-symbol
        try-complete-lisp-symbol-partially
        try-expand-whole-kill))


(defun copy-line (&optional arg)
 "Save current line into Kill-Ring without mark the line"
 (interactive "P")
 (let ((beg (line-beginning-position)) 
	(end (line-end-position arg)))
 (copy-region-as-kill beg end))
)


(defun copy-word (&optional arg)
 "Copy words at point"
 (interactive "P")
 (let ((beg (progn (if (looking-back "[a-zA-Z0-9]" 1) (backward-word 1)) (point))) 
	(end (progn (forward-word arg) (point))))
 (copy-region-as-kill beg end))
)


(defun copy-paragraph (&optional arg)
 "Copy paragraphes at point"
 (interactive "P")
 (let ((beg (progn (backward-paragraph 1) (point))) 
	(end (progn (forward-paragraph arg) (point))))
 (copy-region-as-kill beg end))
)

;; convert text files between unix and dos

(defun dos-unix () 
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match ""))
)

(defun unix-dos () 
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n"))
)

(defun sqlunit-run-file ()
     "Run sqlunit on current buffer"
     (interactive )
     (shell-command 
      (format "ant -f %s../build.xml  -Dscript.name=%s &" (buffer-dir)  (buffer-name))))
(defun sqlunit-run-syn ()
     "Run sqlunit on current buffer"
     (interactive )
     (shell-command 
      (format "ant -f %s../build.xml  -Dscript.name=%s" (buffer-dir) (buffer-name))))
(defun sqlunit-run-all-file ()
     "Run sqlunit on current buffer"
     (interactive )
     (shell-command 
      (format "ant -f %s../build.xml  -Dscript.dir=%s &" (buffer-dir)  "test")))

(setq tramp-default-method "ssh")

(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `wy-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
		     char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))


(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register. 
Use ska-jump-to-register to jump back to the stored 
position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
        (jump-to-register 8)
        (set-register 8 tmp)))

(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1))))
) 


(defun occur-symbol-at-point ()
 (interactive)
 (let ((sym (thing-at-point 'symbol)))
   (if sym
       (push (regexp-quote sym) regexp-history)) ;regexp-history defvared in replace.el
     (call-interactively 'occur)))

(defun my-select-inside-block ()
  "Select text between double straight quotes
on each side of cursor."
  (interactive)
  (let (p1 p2)
    (search-backward "begin")
    (setq p1 (point))
    (search-forward "end")
    (setq p2 (point))

    (goto-char p1)
    (push-mark p2)
    (setq mark-active t)
  )
)

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun semnav-up (arg)
 (interactive "p")
 (when (nth 3 (syntax-ppss))
   (if (> arg 0)
       (progn
         (skip-syntax-forward "^\"")
         (goto-char (1+ (point)))
         (decf arg))
     (skip-syntax-backward "^\"")
     (goto-char (1- (point)))
     (incf arg)))
 (up-list arg))

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun extend-selection (arg &optional incremental)
 "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
 (interactive (list (prefix-numeric-value current-prefix-arg)
                    (or (and transient-mark-mode mark-active)
                        (eq last-command this-command))))
 (if incremental
     (progn
       (semnav-up (- arg))
       (forward-sexp)
       (mark-sexp -1))
   (if (> arg 1)
       (extend-selection (1- arg) t)
     (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
         (goto-char (match-end 0))
       (unless (memq (char-before) '(?\) ?\"))
         (forward-sexp)))
     (mark-sexp -1))))



(defun select-text-in-quote ()
"Select text between the nearest left and right delimiters.
Delimiters are paired characters: ()[]<>«»“”‘’「」, including \"\"."
 (interactive)
 (let (b1 b2)
  (skip-chars-backward "^<>(“{[「«\"‘")
  (setq b1 (point))
  (skip-chars-forward "^<>)”}]」»\"’")
  (setq b2 (point))
  (set-mark b1)
  )
 )

(defun word-count nil "Count words in buffer" (interactive)
(shell-command-on-region (point-min) (point-max) "wc -w"))

(defun djcb-duplicate-line (&optional commentfirst)
  "comment line at point; if COMMENTFIRST is non-nil, comment the original" 
  (interactive)
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (let ((str (buffer-substring (region-beginning) (region-end))))
    (when commentfirst
    (comment-region (region-beginning) (region-end)))
    (insert-string
      (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
    (forward-line -1)))

;; or choose some better bindings....

;; duplicate a line
(global-set-key (kbd "C-c y") 'djcb-duplicate-line)

;; duplicate a line and comment the first
(global-set-key (kbd "C-c c") (lambda()(interactive)(djcb-duplicate-line t)))

(provide 'cw-basic)
