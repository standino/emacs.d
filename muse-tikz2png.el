;; muse-tikz2png.el --- generate images from inline LaTeX code 

;; Copyright (C) 2005, 2006 Free Software Foundation, Inc.

;; Author: Jean Magnan de Bornier (jean AT bornier DOT fr)
;; Created: 31-May-2007

;; This file is part of Emacs Muse.  It is not part of GNU Emacs.

;; Emacs Muse is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; Emacs Muse is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Emacs Muse; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This file has been inspired by muse-latex2png.el, itself drawn from
;; latex2png.el, by Ganesh Swami <ganesh AT iamganesh DOT com>, which
;; was made for emacs-wiki. It provides a "tikz" tag where png (tikz)
;; code can be written to provide pictures in html, xhtml, latex and
;; context-derived styles.

;;; Code

(require 'muse-publish)

(defgroup muse-tikz2png nil
  "Publishing tikz graphics as PNG files."
  :group 'muse-publish)

(defcustom muse-tikz2png-img-dest "./latikz"
  "The folder where the generated images will be placed.
This is relative to the current publishing directory."
  :type 'string
  :group 'muse-tikz2png)



(defcustom muse-tikz2png-template
  "\\documentclass{article}
\\usepackage{tikz}
\\usetikzlibrary{arrows,snakes,backgrounds}
\\thispagestyle{empty}
\\begin{document}
\\fbox{
\\begin{tikzpicture}
%code%
}
\\end{document}"
  "The LaTeX template to use."
  :type 'string
  :group 'muse-tikz2png)

(defun muse-tikz2png-move2pubdir (file prefix pubdir)
  "Move FILE to the PUBDIR folder.

This is done so that the resulting images do not clutter your
main publishing directory.

Old files with PREFIX in the name are deleted."
  (when file
    (if (file-exists-p file)
        (progn
          (unless (file-directory-p pubdir)
            (message "Creating latikz directory %s" pubdir)
            (make-directory pubdir))
          (copy-file file (expand-file-name (file-name-nondirectory file)
                                            pubdir)
                     t)
          (delete-file file)
          (concat muse-tikz2png-img-dest "/" (file-name-nondirectory file)))
      (message "Cannot find %s!" file))))

(defun muse-tikz2png (code prefix preamble)
  "Convert the TIKZ CODE into a png file beginning with PREFIX.
PREAMBLE indicates extra packages and definitions to include."
  (unless preamble
    (setq preamble ""))
  (unless prefix
    (setq prefix "muse-tikz2png"))
  (let* ((tmpdir (cond ((boundp 'temporary-file-directory)
                        temporary-file-directory)
                       ((fboundp 'temp-directory)
                        (temp-directory))
                       (t "/tmp")))
         (texfile (expand-file-name
                   (concat prefix "__"  (format "%d" (abs (sxhash code))))
                   tmpdir))
         (defalt-directory default-directory))
    (with-temp-file (concat texfile ".tex")
      (insert muse-tikz2png-template)
      (goto-char (point-min))
      (while (search-forward "%preamble%" nil t)
        (replace-match preamble nil t))
      (goto-char (point-min))
      (while (search-forward "%code%" nil t)
        (replace-match code nil t)))
    (setq default-directory tmpdir)
    (call-process "latex" nil nil nil texfile)
    (if (file-exists-p (concat texfile ".dvi"))
        (progn
          (shell-command-to-string (concat "dvips -E " texfile ".dvi && convert "  texfile ".ps " texfile ".png"))
          (if (file-exists-p (concat texfile ".png"))
              (progn
                (delete-file (concat texfile ".dvi"))
                (delete-file (concat texfile ".tex"))
                (delete-file (concat texfile ".aux"))
                (delete-file (concat texfile ".log"))
                (concat texfile ".png"))
            (message "Failed to create png file")
            nil))
      (message (concat "Failed to create dvi file " texfile))
      nil)))

(defun muse-tikz2png-region (beg end attrs)
  "Generate an image for the TIKZ CODE between BEG and END.
If a Muse page is currently being published, replace the given
region with the appropriate markup that displays the image.
Otherwise, just return the path of the generated image.

Valid keys for the ATTRS alist are as follows.

prefix: The prefix given to the image file.
preamble: Extra text to add to the Latex preamble.
inline: Display image as inline, instead of a block."
  (let ((end-marker (set-marker (make-marker) (1+ end)))
        (pubdir (expand-file-name
                 muse-tikz2png-img-dest
                 (file-name-directory muse-publishing-current-output-path))))
    (save-restriction
      (narrow-to-region beg end)
      (let* ((text (buffer-substring-no-properties beg end))
             ;; the prefix given to the image file.
             (prefix (cdr (assoc "prefix" attrs)))
             ;; preamble (for extra options)
             (preamble (cdr (assoc "preamble" attrs)))
             ;; display inline or as a block
             (display (car (assoc "inline" attrs))))
        (when muse-publishing-p
          (delete-region beg end)
          (goto-char (point-min)))
        (unless (file-directory-p pubdir)
          (make-directory pubdir))
        (let ((path (muse-tikz2png-move2pubdir
                     (muse-tikz2png text prefix preamble)
                     prefix pubdir)))
          (when path
            (when muse-publishing-p
              (muse-insert-markup
               (if (muse-style-derived-p "html")
                   (concat "<img src=\"" path
                           "\" alt=\"tikz2png graphic\" "
                           (if display (concat "class=\"latex-inline\"")
                             (concat "class=\"latex-display\""))
                           (if (muse-style-derived-p "xhtml")
                               " />"
                             ">")
                           (muse-insert-markup "<!-- " text "-->"))
                 (let ((ext (or (file-name-extension path) ""))
                       (path (muse-path-sans-extension path)))
                   (muse-markup-text 'image path ext))))
              (goto-char (point-max)))
            path))))))








(defun muse-publish-tikz-tag (beg end attrs)
  "Surround the code with appropriate strings according to style,
which may be context-derived, latex-derived, or html-derived. 

  Define a caption argument. When the tag begins after at least 6
  whitespaces, in latex and context styles the picture appears as
  a float and the caption if any is appended. In html the caption
  appears at the bottom of the image."
  (let* ((caption (muse-publish-get-and-delete-attr "caption" attrs))
	  (muse-publishing-directives muse-publishing-directives)
	  (centered (and (re-search-backward
                         (concat "^[" muse-regexp-blank "]\\{6,\\}\\=")
                         nil t)
                        (prog1 t
                          (replace-match "")
                          (when (and 
				 (or (muse-style-derived-p "latex") (muse-style-derived-p "context"))
                                     (not (bobp)))
                            (backward-char 1)
                            (if (bolp)
                                (delete-char 1)
                              (forward-char 1)))
                          (setq beg (point)))))
         (tag-beg 
                      (cond ((muse-style-derived-p "context")
                        (if centered  (concat "\\placefigure{" caption "}{ \\starttikzpicture")  "\\starttikzpicture")) 
		((muse-style-derived-p "latex")
		      (if centered	"\\begin{figure}[htbp]\\begin{tikzpicture}"
                    "\\begin{tikzpicture} "))
	(t " ")
))
         (tag-end 
                      (cond ((muse-style-derived-p "context")
                         (if centered "\\stoptikzpicture }" "\\stoptikzpicture"))
			 ((muse-style-derived-p "latex")
			  (if centered (concat "\\end{tikzpicture}\\caption{" caption "} \\end{figure}")   "\\end{tikzpicture} "))
(t (if centered (concat "\\end{tikzpicture} \n {\\large " caption " }") "\\end{tikzpicture} "))))
         (attrs (nconc (list (cons "prefix"
                                   (concat "tikz2png-" (muse-page-name))))
                       (if centered nil
                         '(("inline" . t))))))
    (muse-insert-markup tag-beg)
    (goto-char end)
    (muse-insert-markup tag-end)
    (if (or (muse-style-derived-p "latex") (muse-style-derived-p "context"))
        (muse-publish-mark-read-only beg (point))
      (muse-tikz2png-region beg (point) attrs))))



(add-to-list 'muse-publish-markup-tags
             '("tikz" t t nil muse-publish-tikz-tag)
             t)

(provide 'muse-tikz2png)
;;; muse-tikz2png.el ends here
