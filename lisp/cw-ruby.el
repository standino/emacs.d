;;说明ruby-mode模式调用哪个函数块
(autoload 'ruby-mode "ruby-mode"
      "Mode for editing ruby source files" t)
;;看到文件后缀为.rb的，对其使用ruby-mode模式，然后它会调用autoload中
;;指定的函数块
(setq auto-mode-alist
          (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq auto-mode-alist
          (append '(("\\.dsl$" . ruby-mode)) auto-mode-alist))

;;如果文件后缀名不为.rb，但是脚本第一行有#!ruby之类的说明
;;也相应调用此ruby模式
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                    interpreter-mode-alist))
;;调用inf-ruby
(autoload 'run-ruby "inf-ruby"
      "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
      "Set local key defs for inf-ruby in ruby-mode")
;;加载钩子
(add-hook 'ruby-mode-hook
         '(lambda ()
            (inf-ruby-keys)))
;;使用ruby-electric次模式
(my-require 'ruby-electric)

;;使用rails模式
;;(my-require 'rails) 

(provide 'cw-ruby)
