(require 'muse-colors)
(require 'muse-mode)                    ; load authoring mode
(require 'muse-html)                    ; load publishing styles I use
(require 'muse-xml)                    
(require 'muse-latex)
(require 'muse-context)
(require 'muse-texinfo)
(require 'muse-docbook)
(require 'muse-wiki)
(require 'muse-project)                 ; publish files in projects
(require 'require-or-install)
(require-or-install 'muse-tex2png "muse-tex2png" "http://jm.bornier.free.fr/muse/muse-tex2png.el")
(require-or-install 'muse-tikz2png  "muse-tikz2png"  "http://jm.bornier.free.fr/muse/muse-tikz2png.el")
(require 'htmlize-hack)
(cygwin-or-linux (lambda()()) 

                 (lambda()
                      (require 'htmlize-hack)
                      )
                 )
(require 'muse-odt)
(require 'muse-odp)
;;(add-to-list 'auto-mode-alist '("\\.muse\\'" . muse-mode-choose-mode))
(add-to-list 'magic-mode-alist '("#title " . muse-mode))
(add-hook 'muse-mode-hook 'turn-on-orgtbl)

;;(setq muse-latexcjk-encoding-default "{UTF8}{gbsn}") ; "{UTF8}{song}")

(setq  muse-latexcjk-encoding-map
       '((utf-8 . "{UTF8}{gbsn}")
         (japanese-iso-8bit . "[dnp]{JIS}{min}")
         (chinese-big5 . "{Bg5}{bsmi}")
         (mule-utf-8 . "{UTF8}{gbsn}")
         (chinese-iso-8bit . "{GB}{gbsn}")
         (chinese-gbk . "{GBK}{gbsn}")))

;;(setq muse-latexcjk-footer muse-latexcjk-footer)
;;"
;;\\end{CJK*} 
;;\\end{document}
;;")

;;(setq muse-latexcjk-header 
;;\\documentclass{article}
;;\\usepackage{tikz}
;;\\usepackage{CJK}
;;\\usepackage{indentfirst}
;;\\usepackage[CJKbookmarks=true]{hyperref}
;;\\usepackage[pdftex]{graphicx}
;;\\def\\museincludegraphics{%
;;  \\begingroup
;;  \\catcode`\\|=0
;;  \\catcode`\\\\=12
;;  \\catcode`\\#=12
;;  \\includegraphics[width=0.75\\textwidth]
;;}
;;
;;\\begin{document}
;;\\begin{CJK*}<lisp>(muse-latexcjk-encoding)</lisp>
;;
;;
;;\\title{<lisp>(muse-publish-escape-specials-in-string
;;  (muse-publishing-directive \"title\") 'document)</lisp>}
;;\\author{<lisp>(muse-publishing-directive \"author\")</lisp>}
;;\\date{<lisp>(muse-publishing-directive \"date\")</lisp>}
;;
;;\\maketitle
;;
;;<lisp>(and muse-publish-generate-contents
;;           (not muse-latex-permit-contents-tag)
;;           \"\\\\tableofcontents\n\\\\newpage\")</lisp>\n\n"
;;  "Header used for publishing LaTeX files (CJK).  This may be text or afilename.
;;")


(setq muse-completing-read-function 'ido-completing-read
      muse-publish-date-format "%Y - %m - %d "
      muse-colors-evaluate-lisp-tags nil
      muse-wiki-ignore-bare-project-names t
      muse-wiki-ignore-implicit-links-to-current-page t
      ywb-muse-recentchanges-page "RecentChanges")

(defvar ywb-muse-publish-root-path "~/public_html/")

(muse-derive-style "my-page-html" "html"
                   :header "~/../Muse/header.html"
                   :footer "~/../Muse/footer.html")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DW html

(defun dw-html-src-tag(beg end attrs)
  "Publish the <src> tag in dw html "
;;  (setq debug-on-error t)
  (let ((title (cdr (assoc "title" attrs))) )

	  (goto-char beg)
	  (muse-insert-markup "<code type=\"section\" width=\"100%\">")
	  (when title
		(muse-insert-markup "<heading refname=\"common_connect\" type=\"code\">")
		(insert title)
		(muse-insert-markup "</heading>"))
	  (goto-char end)
	  (muse-insert-markup "</code>")
	  (muse-publish-mark-read-only beg end)))

(defvar dw-html-markup-tags
  (nconc 
   '(("src"  t t nil  dw-html-src-tag))))

(defvar dw-xml-markup-functions
  '( (table . dw-xml-markup-table)))

(muse-derive-style "dw-html" "xml"
                   :header "~/../Muse/header.xml"
                   :footer "~/../Muse/footer.xml"
				   :tags       'dw-html-markup-tags
				   :functions  'dw-xml-markup-functions
				   :final      'muse-dw-xml-generate)
;; xml 
(defvar dwpath "")
(defvar dwpic "")

(defun my-muse-dw-path (path pic)
  (setq dwpath path)
  (setq dwpic pic)
)

(defun dw-xml-markup-table (&optional attributes)
  "Publish the matched region into a table.
If a string ATTRIBUTES is given, pass it to the markup string begin-table."
  (let* ((table-info (muse-publish-table-fields (match-beginning 0)
                                                (match-end 0)))
         (row-len (car table-info))
         (supports-group (not (string= (muse-markup-text 'begin-table-group
                                                         row-len)
                                       "")))
         (field-list (muse-xml-sort-table (cdr table-info)))
         last-part)
    (when table-info
      (let ((beg (point)))
        (muse-publish-ensure-block beg))
      (muse-insert-markup (muse-markup-text 'begin-table (or attributes "")))
      (muse-insert-markup (muse-markup-text 'begin-table-group row-len))
      (dolist (fields field-list)
        (let* ((type (car fields))
               (part (cond ((eq type 'hline) nil)
                           ((= type 6) "tbody")
                           ((= type 7) "thead")
                           ((= type 9) "tfoot")))
               (col (cond ((eq type 'hline) nil)
                          ((= type 1) "td")
                          ((= type 2) "th")
                          ((= type 3) "td"))))
          (setq fields (cdr fields))
          (unless (and part last-part (string= part last-part))
            (when last-part
              (muse-insert-markup "  </" last-part ">\n")
              (when (eq type 'hline)
                ;; horizontal separators are represented by closing
                ;; the current table group and opening a new one
                (muse-insert-markup (muse-markup-text 'end-table-group))
                (muse-insert-markup (muse-markup-text 'begin-table-group
                                                      row-len))))
            (when part
              (muse-insert-markup "  <" part ">\n"))
            (setq last-part part))
          (unless (eq type 'hline)
            (muse-insert-markup (muse-markup-text 'begin-table-row))
            (dolist (field fields)
              (muse-insert-markup (muse-markup-text 'begin-table-entry  col))
              (insert field)
              (muse-insert-markup (muse-markup-text 'end-table-entry  col)))
            (muse-insert-markup (muse-markup-text 'end-table-row)))))
      (when last-part
        (muse-insert-markup "  </" last-part ">\n"))
      (muse-insert-markup (muse-markup-text 'end-table-group))
      (muse-insert-markup (muse-markup-text 'end-table))
      (insert ?\n))))


(defun muse-dw-xml-generate (file output-path final-target)
 ;; (message (format "---%s----:--%s---:--%s--" file output-path dwpath ))
  (shell-command (concat "cp  " output-path "  "  dwpath  "/index.xml && "
						 "cp  " dwpic "  "   dwpath  "/ && "
						  "cd " dwpath "  && "
						  "./dw-transform.sh  & "
						  )
				 )
  )
(setcdr (assoc 'section muse-xml-markup-strings)
        "<heading alttoc=\"\" refname=\"\" type=\"major\" >")
(setcdr (assoc 'section-end muse-xml-markup-strings)
        "</heading>")

(setcdr (assoc 'subsection muse-xml-markup-strings)
        "<heading alttoc=\"\" refname=\"\" type=\"minor\" >")
(setcdr (assoc 'subsection-end muse-xml-markup-strings)
        "</heading>")
(setcdr (assoc 'subsubsection muse-xml-markup-strings)
        "<heading alttoc=\"\" refname=\"\" type=\"minor\" >")
(setcdr (assoc 'subsubsection-end muse-xml-markup-strings)
        "</heading>")
(setcdr (assoc 'section-other muse-xml-markup-strings)
        "<heading alttoc=\"\" refname=\"\" type=\"table\" >")
(setcdr (assoc 'section-other-end muse-xml-markup-strings)
        "</heading>")

(setcdr (assoc 'section-close muse-xml-markup-strings)
        "")

(setcdr (assoc 'image muse-xml-markup-strings)
        "<figure>
        <heading refname=\"\" type=\"figure\" alttoc=\"\"></heading>
        <img src=\"%s.%s\" alt=\"\"/>
      </figure>")
(setcdr (assoc 'image-with-desc muse-xml-markup-strings)
        "<figure>
        <heading refname=\"\" type=\"figure\" alttoc=\"\">%3%</heading>
        <img src=\"%1%.%2%\" alt=\"%3%\"/>
      </figure>")
(setcdr (assoc 'begin-uli muse-xml-markup-strings)
        "<ul>")

(setcdr (assoc 'end-uli muse-xml-markup-strings)
        "</ul>")

(setcdr (assoc 'begin-uli-item muse-xml-markup-strings)
        "<li>")
(setcdr (assoc 'end-uli-item muse-xml-markup-strings)
        "</li>")

(setcdr (assoc 'begin-oli muse-xml-markup-strings)
        "<ol>")

(setcdr (assoc 'end-oli muse-xml-markup-strings)
        "</ol>")

(setcdr (assoc 'begin-oli-item muse-xml-markup-strings)
        "<li>")
(setcdr (assoc 'end-oli-item muse-xml-markup-strings)
        "</li>")

(setcdr (assoc 'url muse-xml-markup-strings)
        "<a href=\"%s\">%s</a> ")
(setcdr (assoc 'link  muse-xml-markup-strings)
        "<a href=\"%s\">%s</a> ")
(setcdr (assoc 'anchor-ref muse-xml-markup-strings)
        "<a href=\"#%s\">%s</a> ")

(setcdr (assoc 'begin-table muse-xml-markup-strings)
        "<table%s border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"data-table-1\" width=\"100%%\"   summary=\"\" >\n")

(setcdr (assoc 'begin-example muse-xml-markup-strings)
        "<code type=\"section\" width=\"100%\"> ")
(setcdr (assoc 'end-example muse-xml-markup-strings)
        "</code> ")
;;end dw html 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar muse-context-tas-header   "\\usemodule[taspresent][style=<lisp>(if (string-equal (muse-publishing-directive \"style\") nil) \"blueframe\" (muse-publishing-directive \"style\"))</lisp>,font=Pagella,size=17pt]\\setvariables [taspresent]              [author={<lisp>(muse-publishing-directive \"author\")</lisp>},               title={<lisp>(muse-publishing-directive \"title\")</lisp>}]\\starttext \n \\Maketitle \n  \\page \n \\lecback \n")

(defvar muse-context-tas-markup-strings
  (nconc 
   '((section      . "\\Slidetitle  {")
     muse-context-markup-regexps))
  )
(muse-derive-style "tas" "context"
		           :header 'muse-context-tas-header
                   :strings 'muse-context-tas-markup-strings)

(muse-derive-style "tas-pdf" "context-pdf"
		           :header  'muse-context-tas-header
                   :strings 'muse-context-tas-markup-strings
                   )

;;begin customize for bbcode
(defvar bbcode-header "")
(defvar bbcode-footer "")
(defvar bbcode-tags
  '()
  )

(defvar bbcode-regexps '())

(defvar bbcode-html-markup-strings 
  '((image           . "[img]%s.%s[/img]")
    (image-link      . "[url=%s][img]%s.%s[/img][/url]")
    (url             . "[url=%s]%s[/url]")
    (link            . "[url=%s]%s[/url]")
    (section         . "[size=large]")
    (section-end     . "[/size]")
    (subsection      . "[size=medium]")
    (subsection-end  . "[/size]")
    (subsubsection   . "[size=small]")
    (subsubsection-end . "[/size]")
    (section-other   . "[size=x-small]")
    (section-other-end . "[/size]")
    (begin-underline . "[u]")
    (end-underline   . "[/u]")
    (begin-literal   . "[code]")
    (end-literal     . "[/code]")
    (begin-example   . "[code]")
    (end-example     . "[/code]")
    (begin-quote     . "[quote]")
    (end-quote       . "[/quote]")
    (begin-uli       . "[list]")
    (end-uli         . "[/list]")
    (begin-uli-item  . "[*]")
    (end-uli-item    . "")
    (begin-oli       . "[list=1]")
    (end-oli         . "[/list]")
    (begin-oli-item  . "[*]")
    (end-oli-item    . "")
    (begin-quote-item . "")
    (end-quote-item  . "")
    )
  )

(muse-derive-style "bbcode" "wiki"
                   :regexps 'bbcode-regexps
                   :strings 'bbcode-html-markup-strings
                   :tags   'bbcode-tags
                   :header 'bbcode-header
                   :footer 'bbcode-footer
                   )

;;end customize for bbcode

;; customize for slides
(defvar muse-latex-my-slides-header 
"\\documentclass{beamer}

\\usepackage{CJK}
\\usepackage{indentfirst}
\\usepackage[english]{babel}
\\usepackage{ucs}
\\usepackage[utf8x]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{hyperref}

\\usepackage{beamerthemesplit} 
\\def\\museincludegraphics{%
  \\includegraphics[width=0.75\\textwidth]
}

\\begin{document}
\\begin{CJK*}<lisp>(muse-latexcjk-encoding)</lisp>


\\title{<lisp>(muse-publish-escape-specials-in-string
  (muse-publishing-directive \"title\") 'document)</lisp>}
\\author{<lisp>(muse-publishing-directive \"author\")</lisp>}
\\date{<lisp>(muse-publishing-directive \"date\")</lisp>}


\\maketitle

<lisp>(and muse-publish-generate-contents
           \"\\\\tableofcontents\n\\\\newpage\")</lisp>\n\n")

(defvar muse-latex-my-slides-strings
  (nconc 
   '((image           . "\\begin{figure}[htbp]
\\centering\\museincludegraphics{%s.%s}
\\end{figure}")
     'muse-latex-markup-strings))
)

(defun muse-latex-my-example-tag(beg end attrs)
  "Publish the <src> tag ."
    (goto-char beg)
    (muse-insert-markup "\\begin{quote}\n\\begin{verbatim}")
    (goto-char end)
    (muse-insert-markup "\\end{verbatim}\n\\end{quote}")
)
(defun muse-latex-my-cols-tag(beg end attrs)
  "Publish the <cols> tag ."
    (goto-char beg)
    (muse-insert-markup "\\begin{columns}\n")

    (save-excursion
      (goto-char end)
    (muse-insert-markup "\\end{columns}\n")
      )


)
(defun muse-latex-my-col-tag(beg end attrs)
  "Publish the <cols> tag ."
    (goto-char beg)
    (muse-insert-markup "\\column[t]{5cm}\n")

)

(defvar muse-latex-my-slides-markup-tags
  (nconc 
   '(("src3" nil t t muse-latex-my-example-tag)
	 ("cols" nil t t muse-latex-my-cols-tag)
	 ("col" nil t t muse-latex-my-col-tag)
         ("slide" t t nil muse-latex-slide-tag)
     'muse-latex-slides-markup-tags))
  )

(muse-derive-style "my-slides" "pdfcjk"
	           :header  'muse-latex-my-slides-header 
                   :tags    'muse-latex-my-slides-markup-tags
                   :strings 'muse-latex-my-slides-strings
)


;;end for slides
(defun ywb-muse-relative-path (file)
  (concat
   (file-relative-name
    ywb-muse-publish-root-path
    (file-name-directory muse-publishing-current-output-path))
   file))
(defun ywb-define-muse-project (dir)
  `(,dir (,(concat "~/../Muse/" dir) :default "index"
          :force-publish (,ywb-muse-recentchanges-page "WikiIndex"))
         (:base "my-page-html" :path ,(concat "~/public_html/" (downcase dir)))
         (:base "dw-html" :path ,(concat "~/public_html/xml/" (downcase dir)))
         (:base "docbook" :path ,(concat "~/public_html/xml/" (downcase dir)))
;;         (:base "context-slides-pdf" :path ,(concat "~/public_html/" (downcase dir)))
         (:base "slides-pdf" :path ,(concat "~/public_html/" (downcase dir)))
;;        (:base "tas-pdf" :path ,(concat "~/public_html/" (downcase dir)))
         (:base "pdfcjk" :path ,(concat "~/public_html/" (downcase dir)))
         (:base "bbcode" :path ,(concat "~/public_html/bbcode/" (downcase dir)))
        (:base "my-slides" :path ,(concat "~/public_html/" (downcase dir)))
        (:base "dw-odt" :path ,(concat "~/public_html/" (downcase dir))) 
        (:base "dw-odp" :path ,(concat "~/public_html/" (downcase dir))) 
         )
  )


(setq muse-project-alist
      `(,@(mapcar 'ywb-define-muse-project
                  '("work" "programming"  "tools"  "article" "blog"  "other"))
        
        ("Website" ("~/../Muse/" :default "index"
                    :force-publish (,ywb-muse-recentchanges-page "WikiIndex"))
         (:base "my-page-html" :path "~/../../public_html"))

        ))

(autoload 'sgml-tag "sgml-mode" "" t)
(defvar muse-tag-alist
  '(("example")
    ("literal")
    ("lisp" n)
    ("src" ("lang" ("emacs-lisp") ("perl") ("sql") ("c++") ("sh")) n))
  "Tag list for `sgml-tag'.")

(defun ywb-muse-index-as-string (&optional as-list exclude-private exclude-current &rest project-list)
  "Generate the index of all wiki file using title.
See also `muse-index-as-string'.
PROJECT-LIST is the index of projects to insert.
"
  (unless project-list
    (setq project-list (list (car (muse-project)))))
  (let ((current (muse-page-name))
        files title)
    (with-temp-buffer
      (dolist (project project-list)
        (setq files
              (sort (copy-alist (muse-project-file-alist project))
                    (function
                     (lambda (l r)
                       (string-lessp (car l) (car r))))))
        (when (and exclude-current current)
          (setq files (delete (assoc current files) files)))
        (unless (= (length project-list) 1)
          (insert "* " project "\n"))
        (dolist (file files)
          (when (and (file-exists-p (cdr file))
                     (not (member (car file) ywb-muse-index-exclude-pages))
                     (not (and exclude-private
                               (muse-project-private-p (cdr file)))))
            (insert " - [[" project "#" (car file) "]["
                    (or (ywb-muse-page-title (cdr file)) (car file))
                    "]]\n"))))
      (insert "\n")
      (buffer-string))))

(defun my-muse-mode-hook ()

  (add-hook 'font-lock-mode-hook
            (lambda ()
              (when (and (boundp 'muse-colors-overlays)
                         muse-colors-overlays
                         (null font-lock-mode))
                (mapcar 'delete-overlay muse-colors-overlays)))
            nil t)
  (make-local-variable 'muse-colors-overlays)

  (when (= (buffer-size) 0)
    (let ((page (muse-page-name)))
      (cond ((string= page "WikiIndex")
             (insert "#title ç®å½\n"
                     "<lisp>(ywb-muse-index-as-string t t t)</lisp>\n"))
            ((string= page "RecentChanges")
             (insert "#title æ1¤7è¿æ´æ°\n"
                     "<lisp>(ywb-muse-generate-recentchanges)</lisp>\n"))
            (t (insert "#title ")))))
  (outline-minor-mode 1)
  (auto-fill-mode 1)

  (define-key muse-mode-map (kbd "C-c C-c") 'ywb-muse-preview-source)
  (define-key muse-mode-map (kbd "C-c C-m") 'ywb-muse-preview-with-w3m)
  (set (make-local-variable 'sgml-tag-alist) muse-tag-alist)
  (modify-syntax-entry ?> ")" muse-mode-syntax-table)
  (modify-syntax-entry ?< "(" muse-mode-syntax-table)
  (define-key muse-mode-map (kbd "C-c /") 'sgml-close-tag)
  (define-key muse-mode-map (kbd "C-c t") 'sgml-tag))
(add-hook 'muse-mode-hook 'my-muse-mode-hook)



(require 'htmlize)

(require 'file-stat nil t)
(when (not (fboundp 'file-stat-mtime))
  (defsubst file-stat-mtime (file &optional id-format)
    (nth 5 (file-attributes file id-format))))

(defvar ywb-muse-recentchanges-format "%Yå¹1¤7%mæ1¤7%dæ1¤7")



(defun ywb-muse-generate-recentchanges (&optional show-proj &rest project-list)
  "Generate recent changes of project files.

If SHOW-PROJ is non-nil, the index will add project name.
If PROJECT-LIST is given, all changes in these projects will display"
  (or project-list (setq project-list (list (car (muse-project)))))
  (let ((curr-file (muse-current-file))
        (curr-buf (current-buffer))
        (content "")
        last files header current changed beg pos)
    ;; if this file is not save yet, just return an empty string
    (if (not (file-exists-p curr-file))
        ""
      (with-temp-buffer
        (insert-file-contents curr-file)
        ;; search for last change time stamp.
        ;; if there is one, get it and update the time stamp
        ;; if didn't have one, insert current time stamp after directives
        (goto-char (point-min))
        (if (re-search-forward "^; last time stamp: \\([0-9]+\\(\\.[0-9]+\\)?\\)"
                               nil t)
            (progn
              (setq last (seconds-to-time (string-to-number (match-string 1))))
              ;; (re-search-forward "^; last time stamp: \\([0-9.]+\\)" nil t)
              (replace-match (number-to-string (float-time)) nil nil nil 1))
          (re-search-forward "^[^#]" nil t)
          (backward-char 1)
          (insert (format "; last time stamp: %d\n" (float-time))))
        ;; get all file in the project-list newer than last
        (setq files (ywb-muse-get-rc-page project-list (or last '(0 0))))
        (when files
          (re-search-forward "</lisp>")
          (forward-line 1)
          (setq beg (point))
          ;; insert href for the pages. Pages are collected under the
          ;; same header generated by `ywb-muse-recentchanges-format'
          (setq header (format-time-string
                        ywb-muse-recentchanges-format
                        (nth 2 (car files))))
          (insert "* " header "\n")
          (dolist (file files)
            (setq current (format-time-string
                           ywb-muse-recentchanges-format
                           (nth 2 file)))
            (unless (string= current header)
              (insert "\n* " current "\n")
              (setq header current))
            (insert " - [[" (car file) "#" (cadr file) "]["
                    (if show-proj (concat (car file) "-") "")
                    (cadr file) "]]"
                    ;; if the page is not register in the this
                    ;; recentchange, a new tag will add
                    (save-excursion
                      (if (re-search-forward
                           (regexp-quote (concat "[" (car file) "#" (cadr file) "]"))
                           nil t) "" " *(new)*"))
                    "\n"))
          (setq pos (point))
          (if (re-search-forward header nil t)
              ;; if we update this file in the same peroid, the duplicate
              ;; line should removed. 
              (progn
                (re-search-forward "^[*]" nil t)
                (setq content (mapconcat 'identity 
                                         (delete-dups (split-string (delete-and-extract-region beg (point)) "\n")) "\n"))
                (insert content)
                ;; make change in publishing buffer
                (save-excursion
                  (set-buffer curr-buf)
                  (save-restriction
                    (widen)
                    (goto-char (point-min))
                    (re-search-forward "^[*]" nil t)
                    (delete-region (point)
                                   (progn
                                     (re-search-forward "^[*]" nil t)
                                     (point))))))
            (setq content (buffer-substring beg (point))))
          (write-region (point-min) (point-max) curr-file)
          (message "Use M-x revert-buffer to update current buffer")))
      content)))

(defun ywb-muse-get-rc-page (project-list newer)
  (let (files mtime)
    (dolist (proj project-list)
      (dolist (file (muse-project-file-alist (muse-project proj)))
        (when (file-exists-p (cdr file))
          (setq mtime (file-stat-mtime (cdr file)))
          (if (and (time-less-p newer mtime)
                   ;; autosave file
                   (not (string-match "^\.#" (car file)))
                   ;; the page itself
                   (not (string= ywb-muse-recentchanges-page (car file))))
              (setq files (cons (list proj (car file) mtime) files))))))
    (sort files (lambda (f1 f2) (time-less-p (nth 2 f2) (nth 2 f1))))))
;;


(defun ywb-muse-page-title (file)
  (when (and file (file-exists-p file))
    (let ((max-size 200))           ; the max size to search for title
      (with-temp-buffer
        (insert-file-contents file nil 0 max-size)
        (goto-char (point-min))
        (if (re-search-forward "^#title\\s-*" nil t)
            (buffer-substring (point) (line-end-position)))))))

(defvar ywb-muse-index-exclude-pages
  '("index" "WikiIndex" "RecentChanges")
  "Exclude pages when publish index")


;;


(defun ywb-muse-output-file ()
  (let ((style (muse-style
                (muse-project-get-applicable-style buffer-file-name
                                                   (cddr muse-current-project)))))
    (muse-publish-output-file buffer-file-name
                              (muse-style-element :path style) style)))
(defun ywb-muse-preview-with-w3m ()
  "Preview the html file"
  (interactive)
  (muse-project-publish-this-file)
  (let ((file (ywb-muse-output-file)))
    (w3m-goto-url (if (string-match "^[a-zA-Z]:" file)
                      (ywb-convert-to-cygwin-path file)
                    (concat "file://" file)))))
(defun ywb-muse-preview-source ()
  "Find the html file"
  (interactive)
  (muse-project-publish-this-file)
  (find-file (ywb-muse-output-file)))
;;




(defun muse-project-batch-publish ()
  "Publish Muse files in batch mode."
  (let ((muse-batch-publishing-p t)
        force)
    (if (string= "--force" (or (car command-line-args-left) ""))
        (setq force t
              command-line-args-left (cdr command-line-args-left)))
    (if (string= "--all" (or (car command-line-args-left) ""))
        (setq command-line-args-left (nconc (cdr command-line-args-left)
                                            (mapcar 'car muse-project-alist))))
    (if command-line-args-left
        (dolist (project (delete-dups command-line-args-left))
          (message "Publishing project %s ..." project)
          (muse-project-publish project force))
      (message "No projects specified."))))
;;

(defun ywb-remove-html-cjk-space ()
  (when (string= (muse-style-element :base muse-publishing-current-style) "html")
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\\(\\cc\\)\n\\(\\cc\\)" nil t)
        (unless (get-text-property (match-beginning 0) 'read-only)
          (replace-match "\\1\\2"))))))
(add-hook 'muse-after-publish-hook 'ywb-remove-html-cjk-space)
;;

(defun ywb-muse-publish-math-tag (beg end attrs)
  (require 'org)
  (let ((tag (or (cdr (assoc "tag" attrs)) "span")))
    (insert (concat "<" tag " class=\"math\">"
                    (org-export-html-convert-sub-super
                     (delete-and-extract-region beg end))
                    "</" tag ">"))
    (muse-publish-mark-read-only beg (point))))
(add-to-list 'muse-html-markup-tags
             '("math" t t t ywb-muse-publish-math-tag))
;;


(defun ywb-muse-create-wikisource ()
  "Create all wikisource directory using file symbol link"
  (interactive)
  (dolist (proj muse-project-alist)
    (let ((source (expand-file-name (car (cadr proj))))
          (wikisource
           (expand-file-name (concat (muse-get-keyword :path (nth 2 proj)) "/" "wikisource"))))
      (when (and (file-exists-p source)
                 (not (file-exists-p wikisource)))
        (message "Create link %s" wikisource)
        (call-process "ln" nil nil nil "-s" source wikisource)))))
;;


(setcdr (assoc 'image-with-desc muse-html-markup-strings)
        "<div class=\"figure\">
		<div class=\"photo\">
	<img src=\"%1%.%2%\" alt=\"%3%\"/>	</div>
		<p>%3%</p>
	</div>")
;;


(defun muse-colors-literal-tag (beg end)
  "Strip properties and mark as literal."
  (muse-unhighlight-region beg end)
  (let ((multi (save-excursion
                 (goto-char beg)
                 (forward-line 1)
                 (> end (point)))))
    (when (string= (buffer-substring beg (+ beg 9)) "<literal>")
      (add-text-properties beg (+ beg 9) '(invisible muse intangible t))
      (add-text-properties (- end 10) end '(invisible muse intangible t)))
    (add-text-properties beg end `(face muse-verbatim
                                        font-lock-multiline ,multi))))
;;


(when (featurep 'shell-completion)
  (add-to-list 'shell-completion-options-alist
               `("publish-project" "--force" "--all" ,@(mapcar 'car muse-project-alist))))
;;


(let ((table-el (assoc 2300 muse-publish-markup-regexps)))
  (unless (= (aref (cadr table-el) 0) ?^)
    (setcar (cdr table-el)
            (concat "^" (cadr table-el)))))
;;


(defun ywb-muse-publish-desc-tag (beg end)
  (let (muse-publish-inhibit-style-hooks)
    (muse-publish-ensure-block beg)
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (insert (muse-markup-text 'begin-dl))
      (insert (muse-markup-text 'begin-ddt))
      (forward-line 1)
      (muse-publish-markup-region (point) (line-end-position))
      (insert (muse-markup-text 'end-ddt))
      (forward-line 1)
      (insert (muse-markup-text 'begin-dde))
      (muse-publish-markup-region (point) (point-max))
      (goto-char (point-max))
      (insert (muse-markup-text 'end-dde)
              (muse-markup-text 'end-dl))
      (muse-publish-mark-read-only (point-min) (point-max)))))
(add-to-list 'muse-publish-markup-tags
             '("description" t nil nil ywb-muse-publish-desc-tag))
;;


(defun ywb-muse-tutor-link ()
  (if (or (null muse-publishing-current-file)
          (string= (muse-style-element :base muse-publishing-current-style) "html"))
      (let* ((project (muse-project))
             (page (muse-page-name))
             (files (muse-project-file-alist))
             (default (assoc
                       (muse-get-keyword :default (cadr project))
                       files))
             (wikiword-re "\\<\\(\\(?:[[:upper:]]+[[:lower:]]+\\)\\(?:[[:upper:]]+[[:lower:]]+\\)*\\)")
             index prev next)
        (with-temp-buffer
          (insert-file-contents (cdr default))
          (goto-char (point-min))
          (when (re-search-forward (concat "^\\s-+[0-9]+.\\s-*\\(\\[\\[\\)?"
                                           (regexp-quote page)) nil t)
            (save-excursion
              (forward-line 0)
              (if (re-search-backward (concat "^\\s-+[0-9]+.\\s-*\\(\\[\\[\\)?"
                                              wikiword-re) nil t)
                  (setq prev (match-string 2))))
            (forward-line 1)
            (if (re-search-forward (concat "^\\s-+[0-9]+.\\s-*\\(\\[\\[\\)?"
                                           wikiword-re) nil t)
                (setq next (match-string 2)))
            (ywb-muse-tutor-format-anchor (car default) prev next files))))))

(defun ywb-muse-tutor-format-anchor (content prev next file-alist)
  (concat
   "<literal>
   <div class=\"tutorNav\"><ul>
"
   (mapconcat
    'identity
    (delq nil
          (list (if content (format "<li><a href=\"%s.html\">ç®å½</a></li>" content))
                (if prev (format "<li><a href=\"%s.html\">ä¸ä¸èï¼%s</a></li>" prev
                                 (ywb-muse-page-title (cdr (assoc prev file-alist)))))
                (if next (format "<li><a href=\"%s.html\">ä¸ä¸èï¼%s</a></li>" next
                                 (or (ywb-muse-page-title (cdr (assoc next file-alist)))
                                     next)))))
    "\n")
   "
</ul></div>
</literal>"))
;;


(defun ywb-add-first-para ()
  (when (string= (muse-style-element :base muse-publishing-current-style) "html")
    (save-excursion
      (goto-char (point-min))
      (when
          (re-search-forward (regexp-quote "<!-- Page published by Emacs Muse begins here -->"))
        (forward-line 1)
        (if (or (looking-at "<p>")
                (and (looking-at (regexp-quote "<div class=\"contents\">"))
                     (re-search-forward "</div>\\s-+")
                     (looking-at "<p>")))
            (replace-match "<p class=\"first-para\">"))))))
(add-hook 'muse-after-publish-hook 'ywb-add-first-para)
;;


(defun ywb-muse-src-update-from (file)
  (if (not (file-exists-p file))
      (error "File %s is not exists!" file)
    (let (beg end)
      (save-excursion
        (save-restriction
          (re-search-forward "^<src")
          (forward-line 1)
          (setq beg (point))
          (re-search-forward "^</src>")
          (forward-line 0)
          (narrow-to-region beg (point))
          (delete-region (point-min) (point-max))
          (insert-file-contents file))))))
;;


(defun muse-latex-markup-table ()
  (let* ((table-info (muse-publish-table-fields (match-beginning 0)
                                                (match-end 0)))
         (row-len (car table-info))
         (field-list (cdr table-info)))
    (when table-info
      (muse-insert-markup "\\begin{tabular}{" (make-string row-len ?l) "}\n")
      (unless (eq (caar field-list) 'hline)
        (muse-insert-markup "\\hline\n"))
      (dolist (fields field-list)
        (let ((type (car fields)))
          (setq fields (cdr fields))
          (if (eq type 'hline)
              (muse-insert-markup "\\hline\n")
            (when (= type 3)
              (muse-insert-markup "\\hline\n"))
            (insert (car fields))
            (setq fields (cdr fields))
            (dolist (field fields)
              (muse-insert-markup " & ")
              (insert field))
            (muse-insert-markup " \\\\\n")
            (when (= type 2)
              (muse-insert-markup "\\hline\n")))))
      (unless (eq (caar (last field-list)) 'hline)
        (muse-insert-markup "\\hline\n"))
      (muse-insert-markup "\\end{tabular}"))))
;;

;;  Extra command
(defun ywb-muse-project-publish-with-style (project style force)
  (interactive
   (let ((project (muse-read-project "Publish project: " nil t))
         styles style)
     (setq styles (cddr (muse-project project)))
     (if (= (length styles) 1)
         (setq style (car styles))
       (setq style (completing-read "With style: "
                                    (mapcar 'cadr styles) nil t))
       (while styles
         (if (string= style (cadr (car styles)))
             (setq style (car styles)
                   styles nil)
           (setq styles (cdr styles)))))
     (list project style current-prefix-arg)))
  (setq style (list style))
  (muse-project-save-buffers project)
  ;; run hook before publishing begins
  (run-hook-with-args 'muse-before-project-publish-hook project)
  ;; run the project-level publisher
  (let ((fun (or (muse-get-keyword :publish-project (cadr project) t)
                 'muse-project-publish-default)))
    (funcall fun project style force)))





(defun muse-index-sort-by-date ()
 "Display an index of all known Muse pages."
 (interactive)
 (message "Generating Muse index by date...")
 (let ((project (muse-project)))
   (with-current-buffer (muse-generate-index-sort-by-date)
     (goto-char (point-min))
     (muse-mode)
     (setq muse-current-project project)
     (pop-to-buffer (current-buffer))))
 (message "Generating Muse index by date...done"))


(defun muse-generate-index-sort-by-date (&optional as-list exclude-private)
 "Generate an index of all Muse pages."
 (let ((index (muse-index-as-string-sort-by-date as-list exclude-private)))

   (with-current-buffer (get-buffer-create "*Muse Index sort by date*")
     (erase-buffer)
     (insert index)
     (current-buffer))))

(defun muse-index-as-string-sort-by-date (&optional as-list exclude-private exclude-current)
 "Generate an index of all Muse pages.
If AS-LIST is non-nil, insert a dash and spaces before each item.
If EXCLUDE-PRIVATE is non-nil, exclude files that have private permissions.
If EXCLUDE-CURRENT is non-nil, exclude the current file from the output."
 (let ((files (sort (mapcar (lambda (pair)
                             (list
                              (car pair)
                              (cdr pair)
                              (nth 5 (file-attributes (cdr pair)))))
                           (muse-project-file-alist))
                   (function
                    (lambda (l r)
                      (not (muse-time-less-p
                            (nth 2 l)(nth 2 r))))))))
   (when (and exclude-current (muse-page-name))
     (setq files (delete (assoc (muse-page-name) files) files)))
   (with-temp-buffer
     (while files
       (unless (and exclude-private
                    (muse-project-private-p (cdar files)))
         (insert (if as-list " - " "") "[[" (caar files) "]"
                 "["(muse-extract-file-directive (caar files) "title")"]]\n"))
       (setq files (cdr files)))
     (buffer-string))))

(defun muse-extract-file-directive (file directive)
 "Extracts DIRECTIVE content from the source of Muse FILE."
 (with-temp-buffer
   (muse-insert-file-contents file)
   (goto-char (point-min))
   (setq pos (search-forward (concat "#" directive) nil t))
   (if pos
       (let ((beg (+ 1 pos))
             (end (muse-line-end-position)))
         (buffer-substring-no-properties beg  end)) " ")
   ))


(defun muse-pretty-index-as-string (&optional as-list exclude-private
exclude-current)
 "Generate an index of all Muse pages.
If AS-LIST is non-nil, insert a dash and spaces before each item.
If EXCLUDE-PRIVATE is non-nil, exclude files that have private
permissions.
If EXCLUDE-CURRENT is non-nil, exclude the current file from the
output."
 (let ((files (sort (copy-alist (muse-project-file-alist))
                    (function
                     (lambda (l r)
                       (string-lessp (car l) (car r)))))))
   (when (and exclude-current (muse-page-name))
     (setq files (delete (assoc (muse-page-name) files) files)))
   (with-temp-buffer
     (while files
       (setq file-title (muse-extract-file-directive (cdar files)
"title"))
       (unless (and exclude-private
                    (muse-project-private-p (cdar files)))
         (insert (if as-list " - " "") "[[" (caar files) (if file-title
(concat "][" file-title "]]\n") "]]\n") ))
       (setq files (cdr files)))
     (buffer-string))))


(add-hook 'muse-mode-hook 'muse-prepare-imenu)
 
(defun muse-prepare-imenu() 
  (setq imenu-generic-expression
        muse-imenu-generic-expression))
 
(defvar muse-imenu-generic-expression 
  '( ;;sections
    (nil "^\\(\\*+ .+\\)" 1) ("Anchors" "^\\(\\#.+\\)" 1)
    ) 
  "Add support for imenu in muse.  See `imenu-generic-expression' for details")



(provide 'cw-muse)
