;include all the scripts in the .site-lisp diretory.
(add-to-list 'load-path "~/.site-lisp/")

;Javascript mode setup.
(autoload 'javascript-mode "javascript-mode" "JavaScript mode" t)
(setq auto-mode-alist (append '(("\\.js$" . javascript-mode)) auto-mode-alist))

;A reload method to easily reload this file in a live emacs session.
(defun reload () "Reloads .emacs interactively."
(interactive)
(load "~/.emacs"))

;What does auto-fill-mode do anyways?
(setq auto-fill-mode t)

;What does this stuff do?  Do I really care about where the top stuff is?
(setq initial-frame-alist
    '((top . 40) (left . -15)
      (width . 96) (height . 40)
      (cursor-color     . "blue")
      (user-position t)
(font . "-*-courier-*-r-*-*-12-*-*-*-*-*-*-*")
))

(column-number-mode t) ;show column number

(windmove-default-keybindings) ;move between windows with Shift+arrow
(global-set-key "\C-cg" 'goto-line) ;Use Ctrl-c g to go to a line
(setq delete-auto-save-files t) ;This is self explanatory
(setq-default case-fold-search nil) ;case sensitive searches
(highlight-beyond-fill-column) ;hilight text beyond the fill column?

;set some default modes for certain file types.
(add-to-list 'auto-mode-alist '("\\.\\(zcml\\|pt\\|lore\\|html\\)\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.\\(txt\\|rst\\)\\'" . rst-mode))
(add-to-list 'auto-mode-alist '("\\.\\(js\\|c\\)\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.\\(py\\|pyt\\)\\'" . python-mode))

;java script mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;enable glasses-mode without a separator and with bold capitals.
;(add-to-list 'auto-mode-alist '("\\.\\(zcml\\|py\\)\\'" . glasses-mode))
;(setq glasses-separator "")
;'(glasses-face (quote bold))

;enable kill ring
(browse-kill-ring-default-keybindings)

;get rid of those nasty backup files.
(add-to-list 'backup-directory-alist (cons "." "~/.emacs.d/backups"))

;Setup for Ignas's py-imports script.
(require 'py-imports)
(setq py-import-interactive-select-tag nil)
(global-set-key [f5] 'select-tag-to-import)
(global-set-key [C-f5] 'select-tag-to-import-in-place)

;key binding for upper casing things.
(put 'upcase-region 'disabled nil)

;make scroll margin 5 lines
(setq scroll-margin 2)

;enable tabbar mode
(require 'tabbar)
(setq tabbar-mode t)

;make selection be highlighted.
(setq transient-mark-mode t)

;be able to cut and copy things to the global paste buffer in linux.
(setq mouse-drag-copy-region nil)
(setq x-select-enable-primary nil)
(setq x-select-enable-clipboard t)

(setq inhibit-startup-message t); Do without annoying startup msg.

(require 'show-wspace) ; Load the show whitespace library.
(add-hook 'font-lock-mode-hook 'highlight-tabs)
;(add-hook 'font-lock-mode-hook 'highlight-trailing-whitespace)

;(require 'vc-bzr) ;Get bzr version control support


;;;(require 'rst) ;; get rst-mode for emacs (restructured text editing)

;(add-to-list 'load-path "~/.site-lisp/ruby-mode")
;(require 'ruby-mode)
;(require 'ruby-electric)
;(setq auto-mode-alist (cons '("\\.rb\\'" . rhtml-mode) auto-mode-alist))

;;;;;;;Latex help with AuxTex;;;;;;;;;;;;
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)
;(setq TeX-auto-save t)
;(setq TeX-parse-self t)
;(setq-default TeX-master nil)


; set up trac
(load-library "trac-wiki")
(autoload 'trac-wiki "trac-wiki"
          "Trac wiki editing entry-point." t)
;(trac-wiki-define-project "keas"
;                          "https://wush.net/trac/keas" t)
(trac-wiki-define-project "keas"
                          "https://wush.net/trac/" t)


(setq grep-find-command
  '("find . -name '.svn' -prune -name \"*\" -o -print0 | xargs -0 -e grep -in -e " . 75))

; add a pdb trace line when you hit C-c p
(define-key global-map "\C-cp" '(lambda() (interactive) (insert "import pdb; pdb.set_trace()")))

; shortcut to svn-status
(defalias 's 'svn-status)

; awesome buffer switching.  C-x b and start typing! use C-s and C-r to navigate in the set
(require 'iswitchb)
(iswitchb-default-keybindings)

; set tab width to 4
(setq tab-width 4)

; My Saved Macros!!!
; This one sets up my working environment.
(fset 'setup
   [?\M-x ?s ?h ?e ?l ?l return ?\M-x ?r ?e ?n ?a ?m ?e ?- ?b ?u ?f ?f ?e ?r return ?* ?s ?e ?r ?v ?e ?r ?* return ?c ?d ?  ?/ ?h ?o ?m ?e ?/ ?p ?c ?a ?r ?d ?u ?n ?e ?/ ?W ?o ?r ?k ?/ ?K ?e ?a ?s ?/ ?r ?e ?p ?o ?/ ?p ?a ?c ?k ?a ?g ?e ?s ?/ ?k ?e ?a ?s ?. ?a ?p ?p ?/ ?t ?r ?u ?n ?k return ?\M-x ?s ?h ?e ?l ?l return ?\M-x ?r ?e ?n ?a ?m ?e ?- ?b ?u ?f ?f ?e ?r return ?* ?s ?e ?r ?v ?e ?r backspace backspace backspace backspace backspace backspace ?t ?e ?s ?t ?s ?* return ?\M-x ?x ?s backspace backspace ?s ?h ?e ?l ?l return ?\M-x ?r ?e ?n ?a ?m ?e ?- ?b ?u ?f ?f ?e ?r return ?* ?s ?e ?l ?e ?n ?i ?u ?m ?* return ?c ?d ?  ?. ?. ?/ ?. ?. ?/ ?k ?e ?a tab ?a ?l ?l ?t ?e ?s ?t ?/ ?t ?r ?u ?n ?k return ?c ?d ?  ?. ?. ?/ ?. ?. ?/ return ?l ?s return ?c ?d ?  ?k ?e ?a ?s ?. ?a ?l ?l ?t ?e ?s ?t ?s ?/ ?t ?r ?u ?n ?k return ?\M-x ?s ?h ?e ?l ?l return ?\M-x ?r ?e ?n ?a ?m ?e ?- ?b ?u ?f ?f ?e ?r return ?* ?s ?v ?n ?* return ?c ?d ?  ?. ?. ?/ ?. ?. ?/ return ?s ?v ?n ?  ?u ?p return ?\C-x ?3 S-right ?\C-x ?2 ?\C-x ?b ?* ?t ?e ?s ?t ?s ?* return ?. ?/ ?b ?i ?n ?/ ?t ?e ?s ?t ?  ?- ?u ?v ?v ?p ?2 ?1 backspace backspace ?1 return S-left ?\M-x ?s ?h ?e ?l ?l return])

;bunch of custom stuff down here!

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(bar-cursor-mode t nil (bar-cursor))
 '(column-number-mode t)
 '(fill-column 79)
 '(indent-tabs-mode nil)
 '(js2-basic-offset 4)
 '(nuke-trailing-whitespace-always-major-modes (quote (ada-mode c++-mode c-mode change-log-mode emacs-lisp-mode fortran-mode latex-mode lisp-interaction-mode lisp-mode makefile-mode nroff-mode perl-mode plain-tex-mode prolog-mode scheme-mode sgml-mode tcl-mode slitex-mode sml-mode texinfo-mode python-mode)))
 '(safe-local-variable-values (quote ((Encoding . utf-8))))
 '(save-place t nil (saveplace))
 '(session-initialize (quote (de-saveplace session places keys menus)) nil (session))
 '(shell-command-completion-mode t nil (shell-command))
 '(show-trailing-whitespace t)
 '(tab-width 2)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))


(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "dark cyan"))))
 '(highlight-beyond-fill-column-face ((t (:background "light pink"))))
 '(highlight-current-line-face ((t (:background "ivory1"))))
 '(pesche-space ((t (:background "light cyan" :foreground "red" :strike-through t)))))

(put 'erase-buffer 'disabled nil)

(put 'narrow-to-region 'disabled nil)
