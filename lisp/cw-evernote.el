(add-to-list 'load-path "/home/will/ideas/emacs/evernote-mode-0_41")
(require 'evernote-mode)
(setq evernote-username "standino") ; optional: you can use this username as default.
(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; option
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)
(defun sacha/org-get-subtree-region ()
  "Return the start and end of the current subtree."
  (save-excursion
    (let (beg end folded (beg0 (point)))
      (if (org-called-interactively-p 'any)
          (org-back-to-heading nil) ; take what looks like a subtree
        (org-back-to-heading t)) ; take what is really there
      (org-back-over-empty-lines)
      (setq beg (point))
      (skip-chars-forward " \t\r\n")
      (save-match-data
        (save-excursion (outline-end-of-heading)
                        (setq folded (outline-invisible-p)))
        (condition-case nil
            (org-forward-same-level (1- n) t)
          (error nil))
        (org-end-of-subtree t t))
      (org-back-over-empty-lines)
      (setq end (point))
      (list beg end))))

(defun sacha/org-post-subtree-to-evernote (&optional notebook)
  "Post the current subtree to Evernote."
  (interactive)
  (let ((title (nth 4 (org-heading-components)))
        (body (apply 'buffer-substring-no-properties (sacha/org-get-subtree-region))))
    (with-temp-buffer
      (insert body)
      (enh-command-with-auth
       (let (note-attr)
         (setq note-attr
               (enh-command-create-note (current-buffer)
                                        title
                                        notebook
                                        nil "TEXT"))
         (enh-update-note-and-new-tag-attrs note-attr))))))   
