
(defun set-clipboard-contents-from-string (str)
  "Copy the value of string STR into the clipboard."
  (let ((x-select-enable-clipboard t))
    (x-select-text str)))

(defun string-replace-all (old new big)
  "Replace all occurences of OLD string with NEW string in BIG sting."
  (do ((newlen (length new))
       (i (search old big)
          (search old big :start2 (+ i newlen))))
      ((null i) big)
    (setq big
          (concatenate 'string
                       (subseq big 0 i)
                       new
                       (subseq big (+ i (length old))))))
  )

(defun path-to-clipboard ()
  "Copy the current file's path to the clipboard.
     If the current buffer has no file, copy the buffer's default directory."
  (interactive)
  (let (
        (path  (expand-file-name (or (buffer-file-name) default-directory)))
        )
    (set-clipboard-contents-from-string path )
    (kill-new path)
    (message "%s" path)))


(defun win-path()
  (concat "C:\\dsw" (string-replace-all "/" "\\" (expand-file-name (or (buffer-file-name) default-directory))))
  )

(defun buffer-dir()
  (file-name-directory (expand-file-name (or (buffer-file-name) default-directory)))
  )

(defun kill-unmodified-buffers ()
  "Kill some buffers.  Asks the user whether to kill each one of them.
Non-interactively, if optional argument LIST is non-nil, it
specifies the list of buffers to kill, asking for approval for each one."
  (interactive)
  (setq list (buffer-list))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and name				; Can be nil for an indirect buffer
                                        ; if we killed the base buffer.
           (not (string-equal name ""))
           (/= (aref name 0) ?\s)
           (if (buffer-modified-p buffer)
               (message "")(kill-buffer buffer))
           ))
    (setq list (cdr list))))
(setq grep-files-aliases 
      (quote (("asm" . "*.[sS]") 
              ("c" . "*.c") ("cc" . "*.cc *.cxx *.cpp *.C *.CC *.c++") 
              ("cchh" . "*.cc *.[ch]xx *.[ch]pp *.[CHh] *.CC *.HH *.[ch]++") 
              ("hh" . "*.hxx *.hpp *.[Hh] *.HH *.h++") 
              ("ch" . "*.[ch]") 
               ("el" . "*.el") 
               ("h" . "*.h") 
               ("l" . "[Cc]hange[Ll]og*") 
               ("m" . "[Mm]akefile*") 
               ("tex" . "*.tex") 
               ("texi" . "*.texi") 
               (java . "*.java") 
               (sql . "*.sql *.SQL") 
               (xml . "*.xml"))))

(provide 'cw-file)

