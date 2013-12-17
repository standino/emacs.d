;;; cw-theme.el --- color theme

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
;; cw-theme.el
;; 
;; Made by Will
;; Login   <will@will-laptop>
;; 
;; Started on  Wed Dec 10 12:09:03 2008 Will
;; Last update Thu Dec 31 16:07:43 2009 Will
;;


;;; Code:
;; color
(my-require 'color-theme) 

(defun color-theme-blue ()
  "Color theme by hosiawak, created 2007-03-15."
  (interactive)
  (color-theme-install
   '(color-theme-blue
     ((background-color . "#162433")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "yellow")
      (foreground-color . "#C7D4E2")
      (mouse-color . "sienna1"))
     (default ((t (:background "black" :foreground "white"))))
     (blue ((t (:foreground "blue"))))
     (bold ((t (:bold t))))
     (bold-italic ((t (:bold t))))
     (border-glyph ((t (nil))))
     (buffers-tab ((t (:background "black" :foreground "white"))))
     (font-lock-builtin-face ((t (:foreground "white"))))
     (font-lock-comment-face ((t (:foreground "#428BDD"))))
     (font-lock-constant-face ((t (:foreground "#00CC00"))))
     (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
     (font-lock-function-name-face ((t (:foreground "white"))))
     (font-lock-keyword-face ((t (:foreground "#F9BB00"))))
     (font-lock-preprocessor-face ((t (:foreground "Aquamarine"))))
     (font-lock-reference-face ((t (:foreground "SlateBlue"))))
     (font-lock-string-face ((t (:foreground "#00CC00"))))
     (font-lock-type-face ((t (:foreground "white"))))
     (font-lock-variable-name-face ((t (:foreground "white"))))
     (font-lock-warning-face ((t (:bold t :foreground "Pink"))))
     (gui-element ((t (:background "#D4D0C8" :foreground "black"))))
     (highlight ((t (:background "darkolivegreen"))))
     (highline-face ((t (:background "SeaGreen"))))
     (italic ((t (nil))))
     (left-margin ((t (nil))))
     (text-cursor ((t (:background "yellow" :foreground "black"))))
     (toolbar ((t (nil))))
     (underline ((nil (:underline nil))))
     (zmacs-region ((t (:background "snow" :foreground "ble")))))))

(cygwin-or-linux 
 (lambda() 
   (color-theme-initialize)
   
   )
()
 )



(defun color-theme-inkpot ()
  "Color theme based on the Inkpot theme. Ported and tweaked by Per Vognsen."
  (interactive)
  (color-theme-install
   '(color-theme-inkpot
     ((foreground-color . "#cfbfad")
      (background-color . "#1e1e27")
      (border-color . "#3e3e5e")
      (cursor-color . "#404040")
      (background-mode . dark))
     (region ((t (:background "#404040"))))
     (highlight ((t (:background "#404040"))))
     (fringe ((t (:background "#16161b"))))
     (show-paren-match-face ((t (:background "#606060"))))
     (isearch ((t (:bold t :foreground "#303030" :background "#cd8b60"))))
     (modeline ((t (:bold t :foreground "#b9b9b9" :background "#3e3e5e"))))
     (modeline-inactive ((t (:foreground "#708090" :background "#3e3e5e"))))
     (modeline-buffer-id ((t (:bold t :foreground "#b9b9b9" :background "#3e3e5e"))))
     (minibuffer-prompt ((t (:bold t :foreground "#708090"))))
     (font-lock-builtin-face ((t (:foreground "#c080d0"))))
     (font-lock-comment-face ((t (:foreground "#708090")))) ; original inkpot: #cd8b00
     (font-lock-constant-face ((t (:foreground "#506dbd"))))
     (font-lock-doc-face ((t (:foreground "#cd8b00"))))
     (font-lock-function-name-face ((t (:foreground "#87cefa"))))
     (font-lock-keyword-face ((t (:bold t :foreground "#c080d0"))))
     (font-lock-preprocessor-face ((t (:foreground "309090"))))
     (font-lock-reference-face ((t (:bold t :foreground "#808bed"))))
     (font-lock-string-face ((t (:foreground "#ffcd8b" :background "#404040"))))
     (font-lock-type-face ((t (:foreground "#ff8bff"))))
     (font-lock-variable-name-face ((t nil)))
     (font-lock-warning-face ((t (:foreground "#ffffff" :background "#ff0000")))))))

(defun color-theme-blackboard ()
  "Color theme by JD Huntington, based off the TextMate Blackboard theme, created 2008-11-27.
I revise it a little, just change font-lock-function-name-face to make the headings in org-mode different."
  (interactive)
  (when (fboundp 'color-theme-install)
    (color-theme-install
     '(color-theme-blackboard
       ((background-color . "#0C1021")
        (background-mode . dark)
        (border-color . "black")
        (cursor-color . "#A7A7A7")
        (foreground-color . "#F8F8F8")
        (mouse-color . "sienna1"))
       (default ((t (:background "#0C1021" :foreground "#F8F8F8"))))
       (blue ((t (:foreground "RoyalBlue1"))))
       (bold ((t (:bold t))))
       (bold-italic ((t (:bold t))))
       (border-glyph ((t (nil))))
       (buffers-tab ((t (:background "#0C1021" :foreground "#F8F8F8"))))
       (font-lock-builtin-face ((t (:foreground "#F8F8F8"))))
       (font-lock-comment-face ((t (:italic t :foreground "#AEAEAE"))))
       (font-lock-constant-face ((t (:foreground "#D8FA3C"))))
       (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
       (font-lock-function-name-face ((t (:foreground "#CD5C5C")))) ; original is #FF6400
       (font-lock-keyword-face ((t (:foreground "#FBDE2D"))))
       (font-lock-preprocessor-face ((t (:foreground "Aquamarine"))))
       (font-lock-reference-face ((t (:foreground "SlateBlue"))))
 
       (font-lock-regexp-grouping-backslash ((t (:foreground "#E9C062"))))
       (font-lock-regexp-grouping-construct ((t (:foreground "red"))))
 
       (font-lock-string-face ((t (:foreground "#61CE3C"))))
       (font-lock-type-face ((t (:foreground "#8DA6CE"))))
       (font-lock-variable-name-face ((t (:foreground "#FF6400"))))
       (font-lock-warning-face ((t (:bold t :foreground "Pink"))))
       (gui-element ((t (:background "#D4D0C8" :foreground "black"))))
       (region ((t (:background "#253B76"))))
       (mode-line ((t (:background "gray75" :foreground "black"))))
       (highlight ((t (:background "gray21")))) ; original is #222222
       (highline-face ((t (:background "SeaGreen"))))
       (italic ((t (nil))))
       (left-margin ((t (nil))))
       (text-cursor ((t (:background "yellow" :foreground "black"))))
       (toolbar ((t (nil))))
       (underline ((nil (:underline nil))))
       (zmacs-region ((t (:background "snow" :foreground "blue"))))))))

(defun color-theme-blackboard ()
  "Color theme by JD Huntington, based off the TextMate Blackboard theme, created 2008-11-27"
  (interactive)
  (color-theme-install
   '(color-theme-blackboard
     ((background-color . "#0C1021")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "#A7A7A7")
      (foreground-color . "#F8F8F8")
      (mouse-color . "sienna1"))
     (default ((t (:background "#0C1021" :foreground "#F8F8F8"))))
     (blue ((t (:foreground "blue"))))
     (bold ((t (:bold t))))
     (bold-italic ((t (:bold t))))
     (border-glyph ((t (nil))))
     (buffers-tab ((t (:background "#0C1021" :foreground "#F8F8F8"))))
     (font-lock-builtin-face ((t (:foreground "#F8F8F8"))))
     (font-lock-comment-face ((t (:italic t :foreground "#AEAEAE"))))
     (font-lock-constant-face ((t (:foreground "#D8FA3C"))))
     (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
     (font-lock-function-name-face ((t (:foreground "#FF6400"))))
     (font-lock-keyword-face ((t (:foreground "#FBDE2D"))))
     (font-lock-preprocessor-face ((t (:foreground "Aquamarine"))))
     (font-lock-reference-face ((t (:foreground "SlateBlue"))))

     (font-lock-regexp-grouping-backslash ((t (:foreground "#E9C062"))))
     (font-lock-regexp-grouping-construct ((t (:foreground "red"))))

     (font-lock-string-face ((t (:foreground "#61CE3C"))))
     (font-lock-type-face ((t (:foreground "#8DA6CE"))))
     (font-lock-variable-name-face ((t (:foreground "#FF6400"))))
     (font-lock-warning-face ((t (:bold t :foreground "Pink"))))
     (gui-element ((t (:background "#D4D0C8" :foreground "black"))))
     (region ((t (:background "#253B76"))))
     (mode-line ((t (:background "grey75" :foreground "black"))))
     (highlight ((t (:background "#222222"))))
     (highline-face ((t (:background "SeaGreen"))))
     (italic ((t (nil))))
     (left-margin ((t (nil))))
     (text-cursor ((t (:background "yellow" :foreground "black"))))
     (toolbar ((t (nil))))
     (underline ((nil (:underline nil))))
     (zmacs-region ((t (:background "snow" :foreground "ble")))))))

;;(if window-system
;;    (color-theme-calm-forest)
;;(color-theme-inkpot)
;;(color-theme-billw)
(color-theme-blackboard)
;;(color-theme-blue)
;;	(color-theme-hober))


(provide 'cw-theme)
;;; cw-theme.el ends here
