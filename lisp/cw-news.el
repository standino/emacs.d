;;; cw-news.el --- rss reader

;; Copyright (C) 2008  Will

;; Author: Will <will@will-laptop>
;; Keywords: 

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; ;;
;; cw-news.el
;; 
;; Made by Will
;; Login   <will@will-laptop>
;; 
;; Started on  Thu Dec  4 15:33:52 2008 Will
;; Last update Thu Dec  4 15:38:29 2008 Will
;;


;;; Code:

(setq newsticker-url-list 
     (quote 
      (
       ("OCDC Forum" "http://ibmforums.ibm.com/forums/rss/rssthreads.jspa?forumID=4255&Full=true" nil nil nil) 
       ("OCDC blog" "https://w3.tap.ibm.com/weblogs/ocdc/feed/entries/atom" nil nil nil)
       ("my connection" "http://w3.ibm.com/connections/news/atom/stories/top" nil nil nil)
       
       )
      )
     )

(provide 'cw-news)
;;; cw-news.el ends here
