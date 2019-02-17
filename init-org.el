(setq user-full-name "Nick George"
      user-mail-address "nicholas.m.george@ucdenver.edu")

(defun my/tangle-dotfiles ()
   "If the current file is this file, the code blocks are tangled"
   (when (equal (buffer-file-name) (expand-file-name "~/.emacs.d/config.org"))
     (org-babel-tangle nil "~/.emacs.d/init-org.el")
     (byte-compile-file "~/.emacs.d/init-org.el")))

(add-hook 'after-save-hook #'my/tangle-dotfiles)

;; rainbows
(use-package rainbow-delimiters
  :defer t)
;; s package
(use-package s
  :defer t)

(use-package projectile
  :commands (projectile-mode)
  :defer t
  :init
  (projectile-mode))
(setq projectile-indexing-method 'native)
;; for some reason, org is giving me the problems listed here https://lists.gnu.org/archive/html/emacs-orgmode/2016-02/msg00424.html
;; I had to M-x install-package org-plus-contrib to fix it. I havent tried from scratch yet, but hopefully this will work in the future. 
;; tried the fix here https://emacs.stackexchange.com/questions/7890/org-plus-contrib-and-org-with-require-or-use-package
;; (use-package org
;;       :ensure org-plus-contrib)

(use-package material-theme
  :ensure t
  :defer t)

(use-package zenburn-theme
  :ensure t
  :defer t)

(use-package solarized-theme
  :defer t
  :init
  (setq solarized-use-variable-pitch nil)
  :ensure t)

(require 'material-theme)
      (use-package leuven-theme
        :ensure t
        :config
        (load-theme 'leuven t))

;; fix these in the future. So it switches upon programming mode entry
;; (add-hook 'prog-mode-hook
;;   (lambda ()
;;     (add-hook 'window-configuration-change-hook)
;;     '(enable-theme 'material)))

;; (add-hook 'org-mode-hook
;;   (lambda ()
;;     (add-hook 'window-configuration-change-hook)
;;     '(enable-theme 'leuven)))

(defun switch-theme (theme)
  "Disables any currently active themes and loads THEME."
  ;; This interactive call is taken from `load-theme'
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapc 'symbol-name
                                   (custom-available-themes))))))
  (let ((enabled-themes custom-enabled-themes))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)))

(defun disable-active-themes ()
  "Disables any currently active themes listed in `custom-enabled-themes'."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

(global-set-key (kbd "C-c t") 'switch-theme)

(when (window-system)
  (set-frame-font "Fira Code"))
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

(add-hook 'helm-major-mode-hook
          (lambda ()
            (setq auto-composition-mode nil)))

;; (setq x-select-enable-clipboard t)
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(use-package openwith
  :defer t)

(setq openwith-associations '(("\\.pptx?\\'" "open" (file))
                              ("\\.docx?\\'" "open" (file))
                              ("\\.xlsx?\\'" "open" (file))
                              ("\\.ods?\\'" "open" (file))))
(openwith-mode t)

;; don't pop up font menu
;;(global-set-key (kbd "s-t") '(lambda () (interactive)))
(defalias 'yes-or-no-p 'y-or-n-p)
;; Brandon Rhodes https://github.com/brandon-rhodes/dot-emacs/blob/master/init.el
;;(global-set-key [C-tab] 'other-window)
;;(global-set-key [C-S-tab] (lambda () (interactive) (other-window -1)))

(global-set-key (kbd "C-c y") 'kill-buffer-and-window) ;; kill buffer and window is C-c C-k
(global-set-key (kbd "C-c c")'org-capture) ;; start org capture.
(global-set-key (kbd "C-c m") (lambda () (interactive) (find-file "~/Dropbox/orgs/master_agenda.org"))) ;; master agenda in org.
(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file "~/.emacs.d/config.org"))) ;; config file
(global-set-key (kbd "C-c l") (lambda () (interactive) (find-file "~/Dropbox/lab_notebook/lab_notebook.org"))) ;; lab notebook in org.
(global-set-key (kbd "C-c d") (lambda () (interactive) (find-file "~/Dropbox/lab_notebook/data_analysis.org"))) ;; go to data analysis

(bind-key "C-c l" 'org-store-link)
(bind-key "C-c c" 'org-capture)
(bind-key "C-c a" 'org-agenda)

(advice-add 'org-agenda :after #'delete-other-windows)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Turn off the menu bar at the top of each frame because it's distracting
(menu-bar-mode -1)
;; Show line numbers
(use-package nlinum
  :defer t)
(global-nlinum-mode)
;; You can uncomment this to remove the graphical toolbar at the top. After
;; awhile, you won't need the toolbar.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Don't show native OS scroll bars for buffers because they're redundant
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; increase font size for better readability
(set-face-attribute 'default nil :height 140)

;; frame and window size 
(setq initial-frame-alist '((top . 0) (left . 700) (width . 95) (height . 45)))

;; These settings relate to how emacs interacts with your operating system
(setq ;; makes killing/yanking interact with the clipboard
      select-enable-clipboard t

      ;; I'm actually not sure what this does but it's recommended?
      select-enable-primary t

      ;; Save clipboard strings into kill ring before replacing them.
      ;; When one selects something in another program to paste it into Emacs,
      ;; but kills something in Emacs before actually pasting it,
      ;; this selection is gone unless this variable is non-nil
      save-interprogram-paste-before-kill t

      ;; Shows all options when running apropos. For more info,
      ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Apropos.html
      apropos-do-all t

      ;; Mouse yank commands yank at point instead of at click.
      mouse-yank-at-point t)

;; No cursor blinking, it's distracting
(blink-cursor-mode 0)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; don't pop up font menu
(global-set-key (kbd "s-t") '(lambda () (interactive)))

;; no bell
(setq ring-bell-function 'ignore)

;;    (require 'uniquify)

;; (use-package uniquify
;;       :ensure t
;;       :config
;;       (setq uniquify-buffer-name-style 'forward))

(setq uniquify-buffer-name-style 'forward)
;; Highlights matching parenthesis
(show-paren-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

;; Interactive search key bindings. By default, C-s runs
;; isearch-forward, so this swaps the bindings.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Don't use hard tabs
(setq-default indent-tabs-mode nil)
;; When you visit a file, point goes to the last place where it
;; was when you previously visited the same file.
;; http://www.emacswiki.org/emacs/SavePlace
;;        (require 'saveplace)
(use-package saveplace
  :defer t
  :config
  (setq-default save-place t)  
  (setq save-place-file (concat user-emacs-directory "places")))
;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(setq auto-save-default nil)
;; comments
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; use 2 spaces for tabs
;; (defun die-tabs ()
;;   (interactive)
;;   (set-variable 'tab-width 2)
;;   (mark-whole-buffer)
;;   (untabify (region-beginning) (region-end))
;;   (keyboard-quit))

;; fix weird os x kill error
(defun ns-get-pasteboard ()
  "Returns the value of the pasteboard, or nil for unsupported formats."
  (condition-case nil
      (ns-get-selection-internal 'CLIPBOARD)
    (quit nil)))

(setq electric-indent-mode nil)
;; visual line!
(global-visual-line-mode t)

(require 'cl-lib)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (cl-letf (((symbol-function #'process-list) (lambda ())))
    ad-do-it))

;; ido-mode allows you to more easily navigate choices. For example,
    ;; when you want to switch buffers, ido presents you with a list
    ;; of buffers in the the mini-buffer. As you start to type a buffer's
    ;; name, ido will narrow down the list of buffers to match the text
    ;; you've typed in
    ;; http://www.emacswiki.org/emacs/InteractivelyDoThings
;; use helm
  ;; (use-package ido
  ;;   :config
  ;;   (ido-mode t)
  ;;   :init  
  ;;   (setq 
  ;;    ido-enable-flex-matching t
  ;;    ido-use-filename-at-point nil
  ;;    ido-auto-merge-work-directories-length -1
  ;;    ido-use-virtual-buffers t
  ;;    ido-ubiquitous-mode 1))

    ;; Shows a list of buffers
(use-package ibuffer
  :defer t
  :commands ibuffer
  :config
  (define-ibuffer-column size-h
    (:name "Size" :inline t)
    (cond
     ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
     ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
     (t (format "%8d" (buffer-size)))))
  :bind
  ("C-x C-b" . ibuffer))

;; Enhances M-x to allow easier execution of commands. Provides
;; a filterable list of possible commands in the minibuffer
;; http://www.emacswiki.org/emacs/Smex
(use-package smex
  :defer t
  :bind 
  ("M-x" . smex)
  :config
  (smex-initialize)
  :init
  (setq smex-save-file (concat user-emacs-directory ".smex-items")))

(use-package interleave
  :defer t)

(use-package helm
  :ensure t
  :defer t
  :bind  (("M-a" . helm-M-x)
          ("C-x C-f" . helm-find-files)
          ("M-y" . helm-show-kill-ring)
          ("C-x b" . helm-buffers-list))
  :config (progn
            (setq helm-buffers-fuzzy-matching t)
            (helm-mode 1)))

(use-package helm-projectile
  :defer t)
(helm-projectile-on)

(use-package kivy-mode
  :defer t)
(add-to-list 'auto-mode-alist '("\\.kv$" . kivy-mode))

(add-hook 'kivy-mode-hook
          '(lambda ()
             (electric-indent-local-mode t)))

;;  use recent file stuff
(use-package recentf
  :bind ("C-x C-r" . helm-recentf)
  :defer t  
  :config
  (recentf-mode t)
  (setq recentf-max-saved-items 200))

  ;; recommended from https://www.emacswiki.org/emacs/RecentFiles

;;  (run-at-time nil (* 5 60) 'recentf-save-list)
  (setq create-lockfiles nil) ;; see this https://github.com/syl20bnr/spacemacs/issues/5554

(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; regular python stuff
   (use-package python-mode
     :defer t
     :ensure t)


;; python environment
(use-package elpy
  :ensure t
  :defer t
  ;;:config
  ;;(setenv "WORKON_HOME" "~/.ve")
  :init
  (add-hook 'python-mode-hook 'elpy-mode)
  )
(elpy-enable)

;; syntax check

;; highlight indentation off, only use current column
(highlight-indentation-mode nil)
(add-hook 'python-mode-hook 'highlight-indentation-current-column-mode)
;; (highlight-indentation-current-column-mode t)

(use-package flycheck
  :ensure t
  :defer t
  :init (global-flycheck-mode))

(use-package jedi
  :defer t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; for org babel
(setq org-babel-python-command "python3")

(setq ansi-color-for-comint-mode t)

;; start using pipenv
;; (use-package pipenv
;;   :init
;;   (setq
;;    pipenv-projectile-after-switch-function
;;    #'pipenv-projectile-after-switch-extended))
;; not installing from melpa, I'll do manual
(load "~/.emacs.d/manual-packages/pipenv.el-master/pipenv.elc")
(add-hook 'python-mode-hook #'pipenv-mode)
(setq pipenv-projectile-after-switch-function
      #'pipenv-projectile-after-switch-extended)

(add-hook 'python-mode-hook 'rainbow-delimiters-mode)
(add-hook 'python-mode-hook 'electric-pair-mode)

(defun org-babel-python-strip-session-chars ()
  "Remove >>> and ... from a Python session output."
  (when (and (string=
              "python"
              (org-element-property :language (org-element-at-point)))
             (string-match
              ":session"
              (org-element-property :parameters (org-element-at-point))))

    (save-excursion
      (when (org-babel-where-is-src-block-result)
        (goto-char (org-babel-where-is-src-block-result))
        (end-of-line 1)
        ;(while (looking-at "[\n\r\t\f ]") (forward-char 1))
        (while (re-search-forward
                "\\(>>> \\|\\.\\.\\. \\|: $\\|: >>>$\\)"
                (org-element-property :end (org-element-at-point))
                t)
          (replace-match "")
          ;; this enables us to get rid of blank lines and blank : >>>
          (beginning-of-line)
          (when (looking-at "^$")
            (kill-line)))))))

(add-hook 'org-babel-after-execute-hook 'org-babel-python-strip-session-chars)

; use IPython

; use the wx backend, for both mayavi and matplotlib
(setq py-python-command-args
  '("--gui=wx" "--pylab=wx" "-colors" "Linux"))

(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

;; Remove trailing whitespace manually by typing C-t C-w.
(add-hook 'python-mode-hook
          (lambda ()
            (local-set-key (kbd "C-t C-w")
                           'delete-trailing-whitespace)))

;; Automatically remove trailing whitespace when file is saved.
(add-hook 'python-mode-hook
      (lambda()
        (add-hook 'local-write-file-hooks
              '(lambda()
                 (save-excursion
                   (delete-trailing-whitespace))))))

;; Use M-SPC (use ALT key) to make sure that words are separated by
;; just one space. Use C-x C-o to collapse a set of empty lines
;; around the cursor to one empty line. Useful for deleting all but
;; one blank line at end of file. To do this go to end of file (M->)
;; and type C-x C-o.

(use-package org-pomodoro
  :defer t)

;;(require 'org)
;; source editing takes over current window
(setq org-src-window-setup (quote current-window))
;; auto open org files in org mode.
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) ;; auto activate org mode for org docs.

(setq org-startup-with-inline-images t) ;; for inline code images in python

;; display preferences from https://www.youtube.com/watch?v=SzA2YODtgK4&t=36s

;; (setq org-todo-keywords
;;       (quote ((sequence "TODO(t)" "NEXT(n)" "In-progress(ip)" "|" "DONE(d)" "CANCELLED(c)"))))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "In-progress(ip)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)" ))))
;; log time on finish
(setq org-log-done 'time)

(setq org-todo-keyword-faces
      '(("TODO" :foreground "red" :weight bold)
        ("NEXT" :foreground "yellow" :weight bold)
        ("In-progress" :foreground "orange" :weight bold)
        ("WAITING" :foreground "black" :background "grey" :weight bold)
        ("DONE" :foreground "#2D6B2D" :weight bold)
        ("CANCELLED" :foreground "#2D6B2D")))

(add-hook 'org-mode-hook
          (lambda ()
            (org-bullets-mode t)))
;; hook for org mode wrap paragraphs
(add-hook 'org-mode-hook  (lambda () (setq truncate-lines nil)))
(setq org-agenda-files
      '("~/Dropbox/orgs/master_agenda.org"
        "~/Dropbox/orgs/myelin-neuron-communication.org"
        "~/Dropbox/orgs/samplej.org"
        "~/Dropbox/orgs/smaller-projects.org"
        "~/Dropbox/orgs/recurring-reminders-and-tasks.org"))
;; electric pairs rock!
(add-hook 'org-mode-hook 'electric-pair-mode)
(use-package org-bullets
  :defer t)

;; (defvar org-export-output-directory-prefix "compiled_" "prefix of directory used for org-mode export")

;; (defadvice org-export-output-file-name (before org-add-export-dir activate)
;;   "Modifies org-export to place exported files in a different directory"
;;   (when (not pub-dir)
;;       (setq pub-dir (concat org-export-output-directory-prefix (substring extension 1)))
;;       (when (not (file-directory-p pub-dir))
;;        (make-directory pub-dir))))

;; dealing with time here: https://writequit.org/denver-emacs/presentations/2017-04-11-time-clocking-with-org.html
(setq org-clock-idle-time 15)
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Do not prompt to resume an active clock, just resume it
(setq org-clock-persist-query-resume nil)
;; Change tasks to whatever when clocking in
(setq org-clock-in-switch-to-state "NEXT")
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks
;; with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
;; use pretty things for the clocktable
(setq org-pretty-entities t)

(setq org-tags-column 45)

;; redundancies with org here...
(require 'ox-beamer)
(use-package auctex-latexmk
  :ensure t
  :defer t)

;; described here 
(use-package tex 
  :ensure auctex-latexmk
  :defer t)
;; emacs latex customizations

;; https://tex.stackexchange.com/questions/21200/auctex-and-xetex


;;(setq TeX-PDF-mode t)
;; AUCTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(setq TeX-PDF-mode t)

;; Automatically activate folding mode in auctex, use C-c C-o C-b to fold.
(add-hook 'TeX-mode-hook
          (lambda () (TeX-fold-mode 1))); Automatically activate TeX-fold-mode.

;; get rid of temporary files on export
(setq org-latex-logfiles-extensions (quote ("lof" "lot" "tex" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "pygtex" "pygstyle" "pyg")))

;; from https://stackoverflow.com/questions/21005885/export-org-mode-code-block-and-result-with-different-styles
       ;; and this video https://www.youtube.com/watch?v=lsYdK0C2RvQ
   (add-to-list 'exec-path "/usr/local/bin") ;; add pandoc to search path
   (unless (boundp 'org-latex-classes)
     (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
                '("article"
                  "\\documentclass{article}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))


;; ;; breaklines from https://emacs.stackexchange.com/questions/33010/how-to-word-wrap-within-code-blocks

(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")))

   ;; ;; from research toolkit https://raw.githubusercontent.com/vikasrawal/orgpaper/master/research-toolkit.org
   ;; ;; and https://github.com/vikasrawal/orgpaper/blob/master/orgpapers.org

;; reftex
(use-package reftex
  :commands turn-on-reftex
  :init
  (progn
    (setq reftex-default-bibliography '("/Users/Nick/Dropbox/bibliography/zotero-library.bib"))
    (setq reftex-plug-intoAUCTex t))
  :defer t  
  )
(use-package helm-bibtex)

(use-package org-ref
  :after org
  :defer t
  :init
  (setq reftex-default-bibliography '("~/Dropbox/bibliography/zotero-library.bib"))
  (setq org-ref-default-bibliography '("~/Dropbox/bibliography/zotero-library.bib"))
  (setq org-ref-pdf-directory '("~/PDFs")))

(setq bibtex-completion-library-path "~/PDFs/")


(setq bibtex-completion-bibliography "~/Dropbox/bibliography/zotero-library.bib")
(setq bibtex-completion-additional-search-fields '(keywords journal doi))
(setq bibtex-completion-display-formats
      '((t . "${author:36} ${year:4} ${title:*}")))



(setq bibtex-completion-pdf-open-function
      (lambda (fpath)
        (start-process "open" "*open*" "open" fpath)))

;; Edit source in current window. 

  ;; export in UTF-8
  (setq org-export-cording-system 'utf-8)
  ;; load common languages
  ;; for some reason, only R gives the header error. I will deal with that later. 
;; Ahhh I found the answer to the header problem. 
;; check out this website: http://irreal.org/blog/?p=4295

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t) 
   (ipython . t) ;; ob-ipython
   (clojure . t)
   (R . t) 
   (sh . t)
   (C . t)
   (sqlite . t)
   (latex . t)
   (shell . t)
   (octave . t)
   (matlab . t)
   (org . t)
   (emacs-lisp . t)
   (dot .t)))
;; use python 3 default

(setq org-babel-python-command "python3")

;; dont evaluate on export
;; this causes it to ignore header args and export anyways, so cancel it. 
;; see this https://www.miskatonic.org/2016/10/03/orgexportbabelevaluate/
;;(setq org-export-babel-evaluate nil)
;; dont confirm execute with these languages. 
(defun my-org-confirm-babel-evaluate (lang body)
  (not (member lang '("octave" "sh" "python" "R" "emacs-lisp" "clojure" "shell" "ipython" "bash"))))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
;; inline images-- nevermind this is annoying
;;(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; format source blocks natively
;; from http://www.i3s.unice.fr/~malapert/org/tips/emacs_orgmode.html
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

(use-package cider)
(setq org-babel-clojure-backend 'cider)

(org-defkey org-mode-map "\C-c\C-x\C-e" 'cider-eval-last-sexp)
(setq cider-repl-display-help-banner nil)
;; autocompletion from cider https://github.com/clojure-emacs/cider/blob/master/doc/code_completion.md
(use-package company-mode) ;; autocompletion
(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)
(define-key cider-mode-map (kbd "C-<tab>") #'company-complete)
(setq company-idle-delay nil) ; never start completions automatically
;;(global-set-key (kbd "TAB") #'company-indent-or-complete-common)

;;(use-package matlab-mode
;;  :ensure t
;;  :defer t)

;; (setq org-babel-default-header-args:python
;;       (cons '(:results . "output org drawer replace")
;;             (assq-delete-all :results org-babel-default-header-args)))

(use-package ox-reveal
  :ensure t
  :defer t)
(setq org-reveal-title-slide "<h1>%t</h1><h4>%a</h4><h4>%e</h4>")
(setq org-reveal-root "file:///Users/Nick/reveal.js")

(use-package tagedit
  :ensure t
  :defer t  )
(require 'ox-publish)
(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
  :defer t)
;; for html output highlighting
(use-package htmlize)

;; for static publishing 
;; (setq org-publish-project-alist
;;       '(
;;         ("projects"
;;          :base-directory "~/Dropbox/orgs/site/content/projects/"
;;          :base-extension "org"
;;          :publishing-directory "~/nickgeorge.net/content/projects/"
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4
;;          :html-extension "html"
;;          :body-only t)
;;         ("about"
;;          :base-directory "~/Dropbox/orgs/site/content/about/"
;;          :base-extension "org"
;;          :publishing-directory "~/nickgeorge.net/content/about/"
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4
;;          :html-extension "html"
;;          :body-only t)
;;         ("blog"
;;          :base-directory "~/Dropbox/orgs/site/content/blog/"
;;          :base-extension "org"
;;          :publishing-directory "~/nickgeorge.net/content/blog/"
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4
;;          :html-extension "html"
;;          :body-only t)
;;         ("notes"
;;          :base-directory "~/Dropbox/orgs/site/content/notes/"
;;          :base-extension "org"
;;          :publishing-directory "~/nickgeorge.net/content/notes/"
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4
;;          :html-extension "html"
;;          :body-only t)
;;         ("static"
;;          :base-directory "~/Dropbox/orgs/site/static/"
;;          :base-extension "jpg\\|jpeg\\|png\\|css\\|js\\|pdf"
;;          :publishing-directory "~/nickgeorge.net/static/"
;;          :publishing-function org-publish-attachment
;;          :recursive t)
;;         ("templates"
;;          :base-directory "~/Dropbox/orgs/site/templates/"
;;          :base-extension "html"
;;          :publishing-directory "~/nickgeorge.net/templates/"
;;          :publishing-function org-publish-attachment
;;          :recursive t)
;;         ("main_app"
;;          :base-directory "~/Dropbox/orgs/site/"
;;          :base-extension "py"
;;          :publishing-directory "~/nickgeorge.net/"
;;          :publishing-function org-publish-attachment
;;          )
;;         ("nick-site" :components ("projects" "about" "blog" "notes" "static" "templates" "main_app"))))

(setq org-publish-project-alist
      '(
        ("programming"
         :base-directory "~/personal_projects/website-clj/resources/org-programming"
         :base-extension "org"
         :publishing-directory "~/personal_projects/website-clj/resources/programming"
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t)
        ("science"
         :base-directory "~/personal_projects/website-clj/resources/org-science"
         :base-extension "org"
         :publishing-directory "~/personal_projects/website-clj/resources/science"
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t)
        ("clj-site" :components ("programming" "science"))))

;; Automatically load paredit when editing a lisp file
;; More at http://www.emacswiki.org/emacs/ParEdit
(use-package paredit
  :defer t)
(use-package lispy
  :defer t)
;; indent AGGRESSIVE
(use-package aggressive-indent)
;;(global-aggressive-indent-mode 1)
;;(add-to-list 'aggressive-indent-excluded-modes 'clojure-mode)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode 'org-mode)
(add-hook 'clojure-mode-hook #'aggressive-indent-mode)
(add-hook 'lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'emacs-lisp-mode-hook #'paredit-mode)
;; sadly, I tried parinfer but as a beginner I found it difficult to work with based on 
;; a lot of the reasons summarized ehre https://github.com/noctuid/parinfer-notes
;; (use-package parinfer
;;   :ensure t
;;   :bind
;;   (("C-," . parinfer-toggle-mode))
;;   :init
;;   (progn
;;     (setq parinfer-extensions
;;           '(defaults       ; should be included.
;;              pretty-parens  ; different paren styles for different modes.
;;              evil           ; If you use Evil.
;;              lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
;;              paredit        ; Introduce some paredit commands.
;;              smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
;;              smart-yank))   ; Yank behavior depend on mode.
;;     (add-hook 'clojure-mode-hook #'parinfer-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'common-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'scheme-mode-hook #'parinfer-mode)
;;     (add-hook 'lisp-mode-hook #'parinfer-mode)))

;; scheme
(setq scheme-program-name "/usr/local/bin/mit-scheme")
(add-hook 'scheme-mode-hook #'aggressive-indent-mode)

;; setup file for html mode. 
;; added 2017-4-02

(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)
;;(add-hook 'sgml-mode-hook 'htmld-start)
(add-hook 'html-mode-hook (lambda ()
                            (set (make-local-variable 'sgml-basic-offset) 4)))

(add-hook 'html-mode-hook (lambda ()
                            (set (make-local-variable 'sgml-basic-offset) 4)
                            (sgml-guess-indent)))

(add-to-list 'auto-mode-alist '("\\.css$ . html-mode"))

(use-package irony-eldoc
  :defer t)
(use-package irony
  :defer t)
(use-package arduino-mode
  :defer t)
(add-to-list 'auto-mode-alist '("\\.ino$" . arduino-mode))
(use-package platformio-mode
  :defer t)

;; Enable irony for all c++ files, and platformio-mode only
;; when needed (platformio.ini present in project root).
;; (add-hook 'c++-mode-hook (lambda ()
;;                            (irony-mode)
;;                            (irony-eldoc)
;;                            (platformio-conditionally-enable)))

;; Use irony's completion functions.
(add-hook 'irony-mode-hook
          (lambda ()
            (define-key irony-mode-map [remap completion-at-point]
              'irony-completion-at-point-async)

            (define-key irony-mode-map [remap complete-symbol]
              'irony-completion-at-point-async)

            (irony-cdb-autosetup-compile-options)))

(use-package ess-site
  :defer t) 
(use-package ess
  :ensure t
  :init (require 'ess-site)
  :defer t)

(add-hook 'ess-mode-hook #'company-mode)
(define-key ess-mode-map (kbd "C-<tab>") #'company-complete)
;; https://emacs.stackexchange.com/questions/8041/how-to-implement-the-piping-operator-in-ess-mode
(defun then_R_operator ()
  "R - %>% operator or 'then' pipe operator"
  (interactive)
  (just-one-space 1)
  (insert " %>% ")
  (reindent-then-newline-and-indent))

(defun r_assignment_operator ()
  "R assignment <- operator"
  (interactive)
  (just-one-space 1)
  (insert " <- "))
(define-key ess-mode-map (kbd "C-M-m") 'then_R_operator)
(define-key inferior-ess-mode-map (kbd "C-M-m") 'then_R_operator)
(define-key ess-mode-map (kbd "C-=") 'r_assignment_operator)
(define-key inferior-ess-mode-map (kbd "C-=") 'r_assignment_operator)


;; also new YASnippet for assignment <- which is -<TAB>

;; I do not like the underscore replace behavior. 
(ess-toggle-underscore nil)

;; javascript / html
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-hook 'js-mode-hook 'subword-mode)
(add-hook 'html-mode-hook 'subword-mode)
(setq js-indent-level 2)
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))

(use-package magit
  :ensure t
  :defer t
  :bind ("C-c g" . magit-status)
  :config
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session))

;; likely not needed... executed in block below
;; (use-package exec-path-from-shell
;;   :if (memq window-system '(mac ns))
;;   :ensure t
;;   :init
;;   (exec-path-from-shell-initialize))

;; Sets up exec-path-from shell
;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :defer t)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs
   '("PATH")))

;; for venv and customizations
;; think about this https://www.emacswiki.org/emacs/EshellPrompt
;; (setq eshell-prompt-function
;;       (lambda ()
;;         (concat
;;          (propertize (eshell/pwd)'face '(:foreground "blue")) " - " (pyenv-mode-version) " $ ")))

(setq eshell-prompt-regexp "^[^#$\n]*[#$] "
      eshell-prompt-function
      (lambda nil
        (concat
         (propertize (user-login-name) 'face '(:foreground "black")) " "
         (if (string= (eshell/pwd)
                      (getenv "HOME"))
             (propertize "~" 'face '(:foreground "blue"))
           (propertize (eshell/basename (eshell/pwd)) 'face '(:foreground "blue"))) 
         (if (= (user-uid) 0) "# "
           (concat  " $ " )))))

;; key bindings
;; these help me out with the way I usually develop web apps
(defun cider-start-http-server ()
  (interactive)
  (cider-load-current-buffer)
  (let ((ns (cider-current-ns)))
    (cider-repl-set-ns ns)
    (cider-interactive-eval (format "(println '(def server (%s/start))) (println 'server)" ns))
    (cider-interactive-eval (format "(def server (%s/start)) (println server)" ns))))


(defun cider-refresh ()
  (interactive)
  (cider-interactive-eval (format "(user/reset)")))

(defun cider-user-ns ()
  (interactive)
  (cider-repl-set-ns "user"))

(eval-after-load 'cider
  '(progn
     (define-key clojure-mode-map (kbd "C-c C-v") 'cider-start-http-server)
     (define-key clojure-mode-map (kbd "C-M-r") 'cider-refresh)
     (define-key clojure-mode-map (kbd "C-c u") 'cider-user-ns)
     (define-key cider-mode-map (kbd "C-c u") 'cider-user-ns)))


;; reference https://github.com/clojure-emacs/squiggly-clojure/issues/29
;; (use-package flycheck-clojure
;;   :commands (flycheck-clojure-setup)
;;   :init
;;   (add-hook 'clojure-mode-hook
;;             (lambda ()
;;               (eval-after-load 'flycheck
;;                 '(flycheck-clojure-setup)))))

;; (use-package flycheck-clojure)
;;(use-package flycheck-pos-tip)
;; (eval-after-load 'flycheck '(flycheck-clojure-setup))
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (eval-after-load 'flycheck
;;   '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;;;;
;; Clojure
  ;;;;
(use-package clojure-mode
  :ensure t
  :defer t  
  :config 
  ;; Enable paredit for Clojure
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  ;; This is useful for working with camel-case tokens, like names of
  ;; Java classes (e.g. JavaClassName)
  (add-hook 'clojure-mode-hook 'subword-mode)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
  ;; A little more syntax highlighting
  ;; syntax hilighting for midje
  (add-hook 'clojure-mode-hook
            (lambda ()
              ;;(setq inferior-lisp-program "lein repl")
              (font-lock-add-keywords
               nil
               '(("(\\(facts?\\)"
                  (1 font-lock-keyword-face))
                 ("(\\(background?\\)"
                  (1 font-lock-keyword-face))))
              (define-clojure-indent (fact 1))
              (define-clojure-indent (facts 1))))
  (add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode)))
(use-package clojure-mode-extra-font-locking
  :defer t)

;;;;
;; ;; Cider
;; ;;;;
;; (use-package cider
;;   :ensure t
;;   :defer t
;;   )

;;   ;; provides minibuffer documentation for the code you're typing into the repl
;;   (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;;   ;; go right to the REPL buffer when it's finished connecting
;;   (setq cider-repl-pop-to-buffer-on-connect t)

;;   ;; When there's a cider error, show its buffer and switch to it
;;   (setq cider-show-error-buffer t)
;;   (setq cider-auto-select-error-buffer t)

;;   ;; Where to store the cider history.
;;   (setq cider-repl-history-file "~/.emacs.d/cider-history")

;;   ;; Wrap when navigating history.
;;   (setq cider-repl-wrap-history t)

;;   ;; enable paredit in your REPL
   (add-hook 'cider-repl-mode-hook 'paredit-mode)

(setq ispell-program-name "/usr/local/bin/aspell")
(global-set-key (kbd "<f2>")'flyspell-auto-correct-word)

;; todo mode hooks. 
(add-hook 'org-mode-hook 'flyspell-mode)

(setq abbrev-file-name             ;; tell emacs where to read abbrev
        "~/.emacs.d/abbrev_defs")    ;; definitions from...

(setq save-abbrevs t)
(setq-default abbrev-mode t)

;; (use-package ace-jump-mode
;;   :ensure t
;;   :diminish ace-jump-mode
;;   :commands ace-jump-mode
;;   :bind ("C-S-s" . ace-jump-mode))

;; (use-package ace-window
;;   :ensure t
;;   :config
;;   (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;;   (ace-window-display-mode)
;;   :bind ("S-o" . ace-window))

(use-package yasnippet
  :ensure t
  :defer t)

(yas-global-mode t)
(setq yas-trigger-key "<tab>")
