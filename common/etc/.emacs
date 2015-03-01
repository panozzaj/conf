; melpa-stable for package manager
(require 'package)
(add-to-list 'package-archives
  '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

; otherwise conflicts with Karma (default is 9876)
;(setq *ORGTRELLO-PROXY-PORT* 9875)
;(orgtrello-proxy/reload)

; No message at startup
(setq inhibit-startup-message t)

; Highlight cursor line
(global-hl-line-mode t)

; Color enabled
(global-font-lock-mode 1)

; No blinking cursor
(blink-cursor-mode 0)

; Switch to splits (like Vim)
(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))

; resize window to something bigger by default
(when window-system (set-frame-size (selected-frame) 170 60))

; Some global Emacs shortcuts for accessing org-mode functions
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("032fe1f3acb2dcca1d451b891e1275a7d51f62c355e7883a8342e5734153a072" "40c4ae07d79f89c8f4e35b11066e059d289da043e70a37b5e4a87b0a06f26d07" "053bd530ce8c35805d34320bbd11f0680a74409901249cad53157053d42e9aeb" "536c5fc0de7ac2a7ba53b072286fcf09cbd05eb53e84eca9fc9f743837bfb42c" "dcfd4272e86ca2080703e9ef00657013409315d5eb13ea949929f391cdd2aa80" "e5377626af4d9c413b309267384647f42a8cfd047e0a0b57c3b703a3c170d86b" "1dec44213e780f4220cab0b45ae60063a1fecfa26a678ccce07fca4b30b92dc5" "47bff723f2aca3a9a5726abcc52a7cc4192b556dd80b3f773589994d2ed24d16" "6634408f60b490958b19759ebf1f56d97b8b8c69d44186a6c1a8056702a73301" default)))
 '(org-agenda-files
   (quote
    ("~/Dropbox/org/index.org" "~/Dropbox/org/index.org_archive" "~/Dropbox/org/habits.org")))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-start-on-weekday nil)
 '(org-default-notes-file "~/Dropbox/org/notes.org")
 '(org-directory "~/Dropbox/org")
 '(org-habit-show-habits t)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 3))))
 '(rainbow-identifiers-cie-l*a*b*-lightness 80)
 '(rainbow-identifiers-cie-l*a*b*-saturation 18)
 '(save-place t nil (saveplace)))

(define-key global-map "\C-cr" 'org-capture)

; habits
(setq org-habit-show-done-always-green 't)
(setq org-habit-graph-column 50)
(setq org-habit-preceding-days 14)
(setq org-habit-preceding-days 14)
(setq org-habit-following-days 3)

; Prompt for a note when finishing TODO, and put timestamp in as well
(setq org-log-done 'note)

; Put timestamp in for completed repeating tasks
(setq org-log-repeat 'time)

(setq org-capture-templates
  '(("t" "TODO" entry (file+headline "~/Dropbox/org/index.org" "Uncategorized Tasks")
     "* TODO %?\n  %i\n  :PROPERTIES:\n  :CREATED: %U\n  :END:")))

(add-to-list 'org-capture-templates
  '("d" "DONE" entry (file+headline "~/Dropbox/org/index.org" "Uncategorized Tasks")
     "* DONE %?\n  CLOSED: %T\n  %i\n  :PROPERTIES:\n  :CREATED: %U\n  :END:"))


(setq org-agenda-custom-commands
      `(;; TODOs that are not scheduled, are not DONE
        ("ii" "[i]nbox tagged unscheduled tasks" tags "-SCHEDULED={.+}/!+TODO|+STARTED|+WAITING")))

(add-to-list 'org-agenda-custom-commands
	     '("u" "Unscheduled" alltodo ""
	       ((org-agenda-todo-ignore-scheduled t))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;(setq org-todo-keywords
;      '((sequence "TODO(t)" "WAITING(w@/!)" "|" "STARTED" "|" "DONE(d!)")))

;(setq org-todo-keyword-faces
;      '(("TODO" . org-warning) ("STARTED" . "yellow")
;	("STARTED" . (:foreground "blue" :weight bold))))

; put diary file in agenda
(setq org-agenda-include-diary 't)
(setq diary-file "~/Dropbox/org/diary")

; SF:      37.7833° N, 122.4167° W
; Fishers: 39.9561° N,  86.0128° W
(setq calendar-latitude 39.96)
(setq calendar-longitude -86.01)
(setq calendar-location-name "Fishers, IN")

(defun importcals ()
  (let ((diary-filename "~/Dropbox/org/diary")
	(ics-directory "~/Dropbox/org/gcal/ics"))
    (delete-file diary-filename)
    
    (setq ics-filenames (expand-file-name ics-directory "annuals.ics"))
    (dolist (ics-filename ics-filenames)
      '(icalendar-import-file ics-filename diary-filename))
))
    

; http://lists.gnu.org/archive/html/emacs-orgmode/2012-10/msg00191.html
(setq org-agenda-sorting-strategy '(category-keep))

; https://www.gnu.org/software/emacs/manual/html_node/emacs/Fill-Commands.html
; one space after sentences on paragraph reflow
(setq sentence-end-double-space nil)

; better emacs file backups
; see http://www.emacswiki.org/emacs/BackupDirectory
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/conf/common/tmp/emacs"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

; sparser tree (fewer stars), and also much better indenting and
; paragraph reformatting.
;(add-hook 'org-mode-hook
;          (lambda ()
;            (org-indent-mode t))
;          t)

(add-hook 'org-mode-hook 'turn-on-auto-fill)
;(add-hook 'org-mode-hook 'org-trello-mode)

; Change default text size
(set-face-attribute 'default nil :height 140)

; Do not ask to follow symlinks
(setq vc-follow-symlinks 't)

