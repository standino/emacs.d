(require 'org-page)

(defun cw/pub-blog-git ()
  (interactive)

  (setq op/site-main-title "Keep going")
  (setq op/site-sub-title "虽然还是比较迷茫，但是请不要忘记努力超越自己！")
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
           :sort-by :date   ;; how to sort the posts
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
    (shell-command  "st site")
  (op/do-publication t nil nil t)
      (shell-command  "st site")
)
(defun cw/pub-notes-local ()
  (interactive)
  (setq op/repository-org-branch "master") ;; default is "source"
(setq op/repository-html-branch "master")  ;; default is "master"
(setq op/site-main-title "Keep going")
(setq op/site-sub-title "虽然还是比较迷茫，但是请不要忘记努力超越自己！")
(setq op/repository-directory (concat my-idea-home "orgpage") )
;;(setq op/template-directory "~/.emacs.d/themes/mdo" )
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
    (shell-command  "st site")
  (op/do-publication)
    (shell-command  "st site")
)

(provide 'init-org-page)
