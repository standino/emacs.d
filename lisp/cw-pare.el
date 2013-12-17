;;; cw-pare.el --- config paredit

;; Copyright (C) 2009  Will

;; Author: Will <will@will-laptop>
;; Keywords: matching

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
;; cw-pare.el
;; 
;; Made by Will
;; Login   <will@will-laptop>
;; 
;; Started on  Thu Jan  8 20:57:10 2009 Will
;; Last update Wed Jan 21 15:27:18 2009 Will
;;


;;; Code:

 (autoload 'paredit-mode "paredit"
     "Minor mode for pseudo-structurally editing Lisp code."
     t)

;;(add-hook -mode-hook (lambda () (paredit-mode +1)))

;;(mapc (lambda (mode)
;;	(let ((hook (intern (concat (symbol-name mode)
;;				    "-mode-hook"))))
;;	  (add-hook hook (lambda () (paredit-mode +1)))))
;;      '(emacs-lisp lisp inferior-lisp shell sql))
;;
(provide 'cw-pare)
;;; cw-pare.el ends here
