;;; cw-java.el --- config for java dev

;; Copyright (C) 2009  Will

;; Author: Will <will@will-laptop>
;; Keywords: extensions

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
;; cw-java.el
;;
;; Made by Will
;; Login   <will@will-laptop>
;;
;; Started on  Sun Nov 29 17:48:05 2009 Will
;; Last update Mon Nov 30 10:04:14 2009 Will
;;


;;; Code:

;;
;; Install load hooks into your .emacs file.
;; (load-file "~/../init/jde-init.el")
;;
;
;; 打开 debug ，方便输出错误信息
;; (setq debug-on-error t)

;; Load Cedet Elib Jde

;; 在这里定义你得CLASSPATH 需要的话，就修改这个文件，然后 M-x load-file
;;(setq jde-compile-option-classpath (quote ("./"
;;;;                                         "../" "../../" "../../../"
;;                                           "d:/mysoft/java/jdk/lib/dt.jar"
;;                                           "d:/mysoft/java/jdk/lib/tools.jar"
;;;;                                         "~/../bin/apache-ant/lib/ant.jar"
;;;;                                         "D:/mysoft/webserver/resin_3_0_21/lib/jsdk-24.jar"
;;;;                                         "D:/website/cqtel.softreg.com/WEB-INF/lib/webpro2.jar"
;;;;                                         "D:/website/cqtel.softreg.com/WEB-INF/lib/xfire-all-1.2.2.jar"
;;                                           )))
;;;;(load-file "/home/will/tools/cedet-1.0pre6/common/cedet.el")
;;(load-file "~/.emacs.d/cedet/common/cedet.el")
;;(global-ede-mode 1)                      ; Enable the Project management system
;;(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion
;;(global-srecode-minor-mode 1)            ; Enable template insertion menu
;;
;;(setq jde-debugger (quote ("JDEbug")))
;;
;;;; 用JDK1.5编译如果出现乱码,加上下面一行可以解决
;;(setq jde-compiler (quote ("javac" "")))
;;
;;(setq jde-complete-function (quote jde-complete-menu))
;;
;;;; JDK版本号和JAVA_HOME
;;(setq jde-jdk-registry (quote (("1.5" . "D:/mysoft/java/jdk"))))
;;
;;;; 定义 ANT_HOME
;;(setq jde-ant-home "D:/emacs22/custom/bin/apache-ant")
;;
;;;; 将 %ANT_HOME%/bin 放在你的环境变量PATH中
;;(setq jde-ant-program "ant")
;;;;(setq jde-ant-program "D:/emacs22/custom/bin/apache-ant/bin/ant")
;;
;;;; 默认的是 Script 在 window下不是找不到文件，就是说ant不可执行
;;;; 设置为Ant Server就好了
;;(setq jde-ant-invocation-method (quote ("Ant Server")))
;;
;;;; 可能我理解错了，我以为会在用ant发布的时候在 -classpath 里多加上下面jar包
;;(setq jde-ant-user-jar-files (quote ("~/../bin/apache-ant/lib/ant.jar")))
;;
;;;; 如果不用msf-abbrev的话，可以在去掉下面这段注释
;;;; 就可以在第一次打开.java文件的时候再载入jde
;;; (setq defer-loading-jde t)
;;; (setq jde-enable-abbrev-mode t)
;;; (if defer-loading-jde
;;; (progn
;;; (autoload 'jde-mode "jde" "JDE mode." t)
;;; (setq auto-mode-alist
;;; (append '(("\\.java\\'" . jde-mode))
;;; auto-mode-alist)))
;;
;;;; 开启Emacs时就载入Jde，这样msf-abbrev就不会出错
;;(require 'jde)
;;
;;;; 反编译 C-x C-f 打开一个Jar包，在Class文件上按 j 就会给出反编译的代码
;;;; 需要 jad.exe 和 unzip.exe 配合
;;
;;
;;;; Jmake我用不好,谁来教教我
;;;;(require 'jmaker)
;;;;(require 'jjar)
;;;;(require 'jsee)
;;;;(setq jmaker-end-of-line-format (quote dos))
;;;;(setq jmaker-java-compiler-options "")
;;
;;;; load ecb
;;(add-to-list 'load-path   "~/.emacs.d/ecb")
;;
;;(require 'ecb)
;;;; 防止CPU占用 100%
;;(setq semantic-idle-scheduler-idle-time 432000)
;;;;
;;;; 启动Ecb如果有警告
;;;; Warning: `semantic-before-toplevel-bovination-hook' is an obsolete variable;
;;;;    use `semantic--before-fetch-tags-hook' instead.
;;;; 可以修改ecb-util.el
;;;; 注释掉这两行 (428行)
;;;; (semantic-before-toplevel-bovination-hook (lambda ()
;;;;                                           nil))
;;;; 从新编译 M-x byte-compile-file <RET> <RET>
;;
;;;; 当前版本检查器只支持到 cedet 较低，禁用之。
;;(setq jde-check-version-flag nil)

;; Complicated regexp to match method declarations in interfaces or classes
;; A nasty test case is:
;;    else if(foo instanceof bar) {
;; To avoid matching this as a method named "if" must check that within
;; a parameter list there are an even number of symbols, i.e., one type name
;; paired with one variable name.  The trick there is to use the regexp
;; patterns \< and \> to match beginning and end of words.
(defvar java-function-regexp
  (concat
   "^[ \t]*"                                   ; leading white space
   "\\(public\\|private\\|protected\\|"        ; some of these 8 keywords
   "abstract\\|final\\|static\\|"
   "synchronized\\|native"
   "\\|[ \t\n\r]\\)*"                          ; or whitespace
   "[a-zA-Z0-9_$]+"                            ; return type
   "[ \t\n\r]*[[]?[]]?"                        ; (could be array)
   "[ \t\n\r]+"                                ; whitespace
   "\\([a-zA-Z0-9_$]+\\)"                      ; the name we want!
   "[ \t\n\r]*"                                ; optional whitespace
   "("                                         ; open the param list
   "\\([ \t\n\r]*"                             ; optional whitespace
   "\\<[a-zA-Z0-9_$]+\\>"                      ; typename
   "[ \t\n\r]*[[]?[]]?"                        ; (could be array)
   "[ \t\n\r]+"                                ; whitespace
   "\\<[a-zA-Z0-9_$]+\\>"                      ; variable name
   "[ \t\n\r]*[[]?[]]?"                        ; (could be array)
   "[ \t\n\r]*,?\\)*"                          ; opt whitespace and comma
   "[ \t\n\r]*"                                ; optional whitespace
   ")"                                         ; end the param list
   "[ \t\n\r]*"                                ; whitespace
;   "\\(throws\\([, \t\n\r]\\|[a-zA-Z0-9_$]\\)+\\)?{"
   "\\(throws[^{;]+\\)?"                       ; optional exceptions
   "[;{]"                                      ; ending ';' (interfaces) or '{'
   )
  "Matches method names in java code, select match 2")

(defvar java-class-regexp
  "^[ \t\n\r]*\\(final\\|abstract\\|public\\|[ \t\n\r]\\)*class[ \t\n\r]+\\([a-zA-Z0-9_$]+\\)[^;{]*{"
  "Matches class names in java code, select match 2")

(defvar java-interface-regexp
  "^[ \t\n\r]*\\(abstract\\|public\\|[ \t\n\r]\\)*interface[ \t\n\r]+\\([a-zA-Z0-9_$]+\\)[^;]*;"
  "Matches interface names in java code, select match 2")

(defvar java-imenu-regexp
  (list (list nil java-function-regexp 2)
        (list ".CLASSES." java-class-regexp 2)
        (list ".INTERFACES." java-interface-regexp 2))
  "Imenu expression for Java")

;; install it
(add-hook 'java-mode-hook
          (function (lambda ()
                      (setq imenu-generic-expression java-imenu-regexp))))




;; jdee
;;(add-to-list 'load-path "~/.emacs.d/jdee-2.4.1/lisp")
;;(load "jde")



;;(require 'eclim)
;;(global-eclim-mode)
;;
;;(require 'eclimd)
;;
;;(custom-set-variables
;; '(eclim-eclipse-dirs '("/usr/lib64/eclipse"))
;; '(eclimd-default-workspace "/home/Will/JD/projects" )
;; '(eclim-executable "/usr/lib64/eclipse/eclim" )
;; )
;;(setq help-at-pt-display-when-idle t)
;;(setq help-at-pt-timer-delay 0.1)
;;(help-at-pt-set-timer)
;;
;;(require 'company)
;;(require 'company-emacs-eclim)
;;(company-emacs-eclim-setup)
;;(global-company-mode t)
;;
;;(require 'flymake)
;;(defun my-flymake-init ()
;;  (list "my-java-flymake-checks"
;;        (list (flymake-init-create-temp-buffer-copy
;;               'flymake-create-temp-with-folder-structure))))
;;(add-to-list 'flymake-allowed-file-name-masks
;;             '("\\.java$" my-flymake-init flymake-simple-cleanup))
;;
;;
;;(defun eclim-run-test ()
;;  (interactive)
;;  (if (not (string= major-mode "java-mode"))
;;    (message "Sorry cannot run current buffer."))
;;  (compile (concat eclim-executable " -command java_junit -p " eclim--project-name " -t " (eclim-package-and-class))))
(provide 'init-java)
;;; cw-java.el ends here
