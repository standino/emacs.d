
;;(load "~/.emacs.d/nxhtml/autostart.el")

(add-to-list 'auto-mode-alist '("\\.jsp\\'" . anjsp-mode))

(defun bf-pretty-print-xml-region (begin end) 
  "Pretty format XML markup in region. You need to have nxml-mode http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do this. The function inserts linebreaks to separate tags that have nothing but whitespace between them. It then indents the markup by using nxml's indentation rules." 
  (interactive "r") 
  (save-excursion (nxml-mode) (goto-char begin) 
                  (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
                    (backward-char) (insert "\n")) 
                  (indent-region begin end)) 
(message "Ah, much better!"))

(defun msh-close-tag ()
  "Close the previously defined XML tag"
  (interactive)
  (let ((tag nil)
        (quote nil))
    (save-excursion
      (do ((skip 1))
          ((= 0 skip))
        (re-search-backward "</?[a-zA-Z0-9_-]+")
        (cond ((looking-at "</")
               (setq skip (+ skip 1)))
              ((not (looking-at "<[a-zA-Z0-9_-]+[^>]*?/>"))
               (setq skip (- skip 1)))))
      (when (looking-at "<\\([a-zA-Z0-9_-]+\\)")
        (setq tag (match-string 1)))
      (if (eq (get-text-property (point) 'face)
              'font-lock-string-face)
          (setq quote t)))
    (when tag
      (setq quote (and quote
                       (not (eq (get-text-property (- (point) 1) 'face)
                                'font-lock-string-face))))
      (if quote
          (insert "\""))
      (insert "</" tag ">")
      (if quote
          (insert "\"")))))

(provide 'cw-nxhml)

