(require 'org-page)
(setq op/repository-directory (concat my-idea-home "standino.github.com") )
(setq op/site-domain "http://standino.github.io/")
(setq op/personal-github-link "https://github.com/standino")
(setq op/personal-disqus-shortname "standino")
(setq op/personal-google-analytics-id "UA-46515756-1")

(setq op/category-config-alist
      '(("blog" ;; this is the default configuration
         :show-meta t
         :show-comment t
         :uri-generator op/generate-uri
         :uri-template "/blog/%y/%m/%d/%t/"
         :sort-by :date     ;; how to sort the posts
         :category-index t) ;; generate category index or not
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
(defun cw/org-page-publish ()

  (interactive)
  (op/do-publication t nil nil t)
 )

(provide 'init-org-page)
