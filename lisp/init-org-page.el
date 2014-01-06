;;; package --- 配置org page
;;; Commentary: 配置org page


(require 'org-page)


(setq op/site-main-title "Keep going")

(setq op/site-sub-title "努力超越自己！")

(setq op/site-domain "http://standino.github.io/")


(setq op/personal-github-link "https://github.com/standino")


(setq op/personal-disqus-shortname "standino")


(setq op/personal-google-analytics-id "UA-46515756-1")

(setq op/repository-org-branch "master")  ;; default is "source"

(setq op/repository-html-branch "master") ;; default is "master"

(setq op/category-config-alist
      '(("blog" ;; this is the default configuration
         :show-meta t
         :show-comment t
         :uri-generator op/generate-uri
         :uri-template "/blog/%y/%m/%d/%t/"
         :sort-by :date       ;; how to sort the posts
         :category-index t)   ;; generate category index or not
        ("wiki"
         :show-meta t
         :show-comment t
         :uri-generator op/generate-uri
         :uri-template "/wiki/%t/"
         :sort-by :mod-date
         :category-index t)
        ("index"
         :show-meta nil
         :show-comment nil
         :uri-generator op/generate-uri
         :uri-template "/"
         :sort-by :date
         :category-index nil)
        ("about"
         :show-meta nil
         :show-comment nil
         :uri-generator op/generate-uri
         :uri-template "/about/"
         :sort-by :date
         :category-index nil)))

(defun cw/commit-pub ()
    (shell-command  "st ci")
;;    (op/do-publication t nil nil t)
  )

(defun cw/pub-blog-git ()
  (interactive)
  (setq op/repository-directory (concat my-idea-home "standino.github.com") )
  (cw/commit-pub)
  (op/do-publication nil "HEAD^1" "~/ideas/standino.github.com/" nil)


  )
(defun cw/pub-notes-local ()
  (interactive)
  (setq op/repository-directory (concat my-idea-home "orgpage") )
  (cw/commit-pub)
  (op/do-publication nil "HEAD^1" "~/ideas/orgpage/" nil)
)

(defun cw/pub-all ()
  (interactive)
  (cw/pub-notes-local)
  (cw/pub-blog-git)
  (shell-command  "st site")

  )

(provide 'init-org-page)
