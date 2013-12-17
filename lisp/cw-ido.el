;;(ido-mode 1)
;;(setq ido-save-directory-list-file "~/backup/_ido_last")
;;(ido-everywhere 1)
;;(require 'imenu)
;;(defun imenu--completion-buffer (index-alist &optional prompt)
;;  ;; Create a list for this buffer only when needed.
;;  (let ((name (thing-at-point 'symbol))
;;        choice
;;        (prepared-index-alist
;;         (if (not imenu-space-replacement) index-alist
;;           (mapcar
;;            (lambda (item)
;;              (cons (subst-char-in-string ?\s (aref imenu-space-replacement 0)
;;                                          (car item))
;;                    (cdr item)))
;;            index-alist))))
;;    (when (stringp name)
;;      (setq name (or (imenu-find-default name prepared-index-alist) name)))
;;    (setq name (ido-completing-read
;;                "Index item: "
;;                (mapcar 'car prepared-index-alist)
;;                nil t nil 'imenu--history-list
;;                (and name (imenu--in-alist name prepared-index-alist) name)))
;;    (when (stringp name)
;;      (setq choice (assoc name prepared-index-alist))
;;      (if (imenu--subalist-p choice)
;;          (imenu--completion-buffer (cdr choice) prompt)
;;        choice))))
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(defvar drupal-project-path "~/quote" "*Base path for your project")
;;
;;(require 'etags)
;;(setq tags-file-name (expand-file-name "TAGS" drupal-project-path))
;;
;;(require 'filecache)
;;(require 'ido)
;;(defun file-cache-ido-find-file (file)
;;  "Using ido, interactively open file from file cache'.
;;First select a file, matched using ido-switch-buffer against the contents
;;in `file-cache-alist'. If the file exist in more than one
;;directory, select directory. Lastly the file is opened."
;;  (interactive (list (file-cache-ido-read "File: "
;;                                          (mapcar
;;                                           (lambda (x)
;;                                             (car x))
;;                                           file-cache-alist))))
;;  (let* ((record (assoc file file-cache-alist)))
;;    (find-file
;;     (expand-file-name
;;      file
;;      (if (= (length record) 2)
;;          (car (cdr record))
;;        (file-cache-ido-read
;;         (format "Find %s in dir: " file) (cdr record)))))))
;;
;;(defun file-cache-ido-read (prompt choices)
;;  (let ((ido-make-buffer-list-hook
;;	 (lambda ()
;;	   (setq ido-temp-list choices))))
;;    (ido-read-buffer prompt)))
;;
;;(ido-mode t)
;;;; Change this to filter out your version control files
;;(add-to-list 'file-cache-filter-regexps "\\.svn-base$")
;;(if drupal-project-path
;;    (file-cache-add-directory-using-find drupal-project-path))
;;
;;(global-set-key (kbd "ESC ESC f") 'file-cache-ido-find-file)
;;
(ido-mode t)                                        ;开启ido模式
(setq ido-enable-flex-matching t)                   ;模糊匹配
(setq ido-everywhere nil)                           ;禁用ido everyting, 拷贝操作不方便
(add-hook 'ido-make-file-list-hook 'ido-sort-mtime) ;文件的排序方法
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)  ;目录的排序方法

(defun ido-sort-mtime ()
    (setq ido-temp-list
          (sort ido-temp-list 
                (lambda (a b)
                  (let ((ta (nth 5 (file-attributes (concat ido-current-directory a))))
                        (tb (nth 5 (file-attributes (concat ido-current-directory b)))))
                    (if (= (nth 0 ta) (nth 0 tb))
                        (> (nth 1 ta) (nth 1 tb))
                      (> (nth 0 ta) (nth 0 tb)))))))
    (ido-to-end  ;; move . files to end (again)
     (delq nil (mapcar
                (lambda (x) (if (string-equal (substring x 0 1) ".") x))
                ido-temp-list))))

(provide 'cw-ido)
