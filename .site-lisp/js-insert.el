(defun js-insert-module()
  (interactive)
  (insert "\
/**
 * @module
 */
"))

(defun js-insert-object ()
  (interactive)
  (insert "{}"))



(define-minor-mode js-insert-mode
  ;; here is some documentation
  "Toggle JavaScript insert mode."
  ;; this is the initial value of the mode (turned off)
  nil
  ;; this is the indicator for the mode line?
  "js-insert"
  ;; and finally, here is the actual mode!
  '(("\C-c\C-o" . js-insert-object)
    ("\C-c\C-p" . js-insert-module))

  :group js-insert)