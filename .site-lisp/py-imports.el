(require 'etags)

(defvar py-import-interactive-select-tag nil)
(defvar py-import-show-import-location nil)
(defvar py-import-syspath '("~/schoolbell/src/"
                            "~/schoolbell/Zope3/src/"))

(defvar py-import-predefined-imports
  '(("Interface" "zope/interface")
    ("verifyObject" "zope/interface/verify")
    ("zapi" "zope/app")
    ("adapts" "zope/component")
    ("implements" "zope/interface")
    ("traverse" "zope/app/traversing/api")
    ("NotFound" "zope/publisher/interfaces")
    ("TestRequest" "zope/publisher/browser")
    ("removeSecurityProxy" "zope.security.proxy")
    ("Attribute" "zope.interface")
    ("ztapi" "zope.app.tests")
    ("queryMultiAdapter" "zope.component")
    ("Field" "zope.schema")
    ("provideSubscriptionAdapter" "zope.component")
    ("URIInstruction" "schooltool.app.relationships")
    ("URISection" "schooltool.app.relationships")
    ("URIMembership" "schooltool.app.membership")
    ("URIMember" "schooltool.app.membership")
    ("implementer" "zope.interface")
    ("Iterable" "zope.schema")
    ("provideAdapter" "zope.component" "provideAdapter(factory, adapts=None, provides=None, name='')")
    ("classImplements" "zope.interface")
    ("directlyProvides" "zope.interface")
    ("directlyProvidedBy" "zope.interface")
    ("getUtility" "zope.component")))

(defvar py-import-path-postprocessor 'remove-src)

(defun hacky-replace (a b)
  (flet ((message (&rest ignore)))
    (beginning-of-buffer)
    (while (search-forward a nil t)
      (replace-match b nil t))))

(defun hacky-regexp-replace (a b)
  (flet ((message (&rest ignore)))
    (beginning-of-buffer)
    (while (search-forward-regexp a nil t)
      (replace-match b nil t))))

(defun remove-syspath (path)
  (with-temp-buffer
    (insert path)
    (hacky-replace ".py$" "")
    ;;(insert (substring path 1 -3)) ;; remove the .py suffix
    (loop for path in py-import-path-postprocessor
         do (beginning-of-line)
         do (hacky-replace (expand-file-name path) ""))
    (buffer-string)))

(defun remove-src (path)
  (with-temp-buffer
    (insert path)
    (hacky-replace ".py" "")
    (beginning-of-line)
    (hacky-regexp-replace ".*/src/" "")
    (beginning-of-line)
    (hacky-regexp-replace ".*\.egg/" "")
    (buffer-string)))

(defun process-import (import-file tag)
  (with-temp-buffer
    (beginning-of-line)
    (if (equal (string-match tag import-file) 0)
        (insert (format "%s" import-file))
        (insert (format "from %s import %s"
                        (funcall py-import-path-postprocessor import-file)
                        tag)))
    (beginning-of-line)
    (hacky-replace "/" ".")
    (beginning-of-line)
    (hacky-replace ".__init__" "")
    (hacky-replace "._bootstrapfields" "") ;; workaround zope.schema._bootstrapfields
    (hacky-replace "._api" "") ;; workaround zope.component._api
    (buffer-string)))

(defun process-import-in-place (import-file tag)
  (with-temp-buffer
    (beginning-of-line)
    (if (equal (string-match tag import-file) 0)
        (insert (format "%s" import-file))
        (insert (format "%s.%s"
                        (funcall py-import-path-postprocessor import-file)
                        tag)))
    (beginning-of-line)
    (hacky-replace "/" ".")
    (beginning-of-line)
    (hacky-replace ".__init__" "")
    (hacky-replace "._bootstrapfields" "") ;; workaround zope.schema._bootstrapfields
    (hacky-replace "._api" "") ;; workaround zope.component._api
    (buffer-string)))

(defun lookup-predefined-import (pattern)
  (loop for import in py-import-predefined-imports
       when (equal (car import)
                   pattern)
       return (cdr import)))

(defun find-all-locations-of-tag (pattern)
  (or (lookup-predefined-import pattern)
      (progn
        (visit-tags-table-buffer)
        (save-excursion
          (let ((search-forward-func find-tag-search-function)
                file                            ;name of file containing tag
                tag-info                        ;where to find the tag in FILE
                (case-fold-search (if (memq tags-case-fold-search '(nil t))
                                      tags-case-fold-search
                                      case-fold-search))
                (pos-list nil))
            (visit-tags-table-buffer)
            (goto-char (point-min))
            (loop as pos = (funcall search-forward-func pattern nil t)
               while (and pos
                          (not (find pos pos-list)))
               do (push pos pos-list)
               ;; Naive match found.  Qualify the match.
               when (tag-exact-match-p pattern)
               ;; Make sure it is not a previous qualified match.
               ;;tag-info (funcall snarf-tag-function)
               collect (progn
                         (save-excursion
                           (beginning-of-line)
                           (expand-file-name
                            (file-of-tag))))))))))

(defun find-all-imports (tag)
  (interactive)
  (save-excursion
    (let ((table (remove-duplicates
                  (loop for import in (find-all-locations-of-tag tag)
                     collect (process-import import tag))
                  :test 'equal)))
      (if table
          (if (= (length table) 1)
              (car table)
              (completing-read "Select-import:"
                               table
                               nil
                               t
                               "from "))
          (error "Suitable import was not found!")))))


(defun find-all-imports-in-place (tag)
  (interactive)
  (save-excursion
    (let ((table (remove-duplicates
                  (loop for import in (find-all-locations-of-tag tag)
                     collect (process-import-in-place import tag))
                  :test 'equal)))
      (if table
          (if (= (length table) 1)
              (car table)
              (completing-read "Select-import:"
                               table
                               nil
                               t
                               ""))
          (error "Suitable import was not found!")))))


(defun select-tag ()
  (if py-import-interactive-select-tag
      (find-tag-interactive "Import tag: ")
      (list (find-tag-default))))

(defun select-tag-to-import (tag)
  (interactive (select-tag))
  (insert-import (find-all-imports tag)))

(defun select-tag-to-import-in-place (tag)
  (interactive (select-tag))
  (insert-import-in-place (find-all-imports-in-place tag)))

(defun insert-import-in-place (import-string)
  (flet ((message (&rest ignore)))
    (forward-char)
    (backward-word)
    (kill-word 1)
    (insert import-string)))

(defun insert-import (import-string)
  (flet ((message (&rest ignore)))
    (beginning-of-line)
    (insert import-string "\n")
    (previous-line)
    (indent-for-tab-command)))

(provide 'py-imports)
