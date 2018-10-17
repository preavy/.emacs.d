; --------------------------------------------------
; Defuns.
; --------------------------------------------------

; Delete all console.log statements from a JavaScript file.
(fset 'delete-console.log-statements
      "\C-sconsole.log\C-m\C-a\C-k\C-k")

; Suppress error "directory  ~/.emacs.d/server is unsafe" on Windows.
(when (and (= emacs-major-version 23) (equal window-system 'w32))
  (defun server-ensure-safe-dir (dir) "Noop" t))

(defun shrink-frame ()
  (interactive)
  (set-frame-size (selected-frame) 80 24))

(defun shrink-frame-width ()
  (interactive)
  (set-frame-width (selected-frame) 80))

(defun jslint-current-file ()
  (interactive)
  (shell-command (concat "jslint " (buffer-file-name))))

; My own adaptation of xah lee's open-in-desktop below.
(defun open-document-outside-emacs ()
  (interactive)
  (shell-command
    (concat "\""
      (car (dired-get-marked-files))
      "\"")))

; http://xahlee.org/emacs/emacs_dired_open_file_in_ext_apps.html
(defun open-in-desktop ()
  "Open the current file in desktop.
Works in Microsoft Windows, Mac OS X, Linux."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute
     "execute"
     (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux") (shell-command "xdg-open ."))))

; http://xahlee.org/emacs/emacs_copy_cut_current_line.html
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is copied.")
       (list (line-beginning-position) (line-beginning-position 2))))))

(defadvice kill-region (before slick-copy activate compile)
  "When called interactively with no active region, cut the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (list (line-beginning-position) (line-beginning-position 2))))))

; Start of PowerShell stuff.

(defun eval-region-powershell ()
  (interactive)
  (shell-command
   (concat "powershell -noprofile -encodedcommand "
           (base64-encode-string
            (encode-coding-string
             (buffer-substring (mark) (point)) 'utf-16le)))))

; about_Splatting
; http://technet.microsoft.com/en-us/library/jj672955.aspx

; Todo handle switch params.
; which should look like this
; "switch" = $true;
;
(defun powershell-make-name-value-pair (myParamPair)
  "Take a string with two words separated by a space and
   return them as a name value pair to include in a PowerShell hash literal."
  (concat "  \""
          (mapconcat 'identity (split-string myParamPair) "\" = \"") "\";"))

; (powershell-make-name-value-pair "key value")

; todo make this prompt for the name of the splat
(defun powershell-splat ()
  "Take the PowerShell cmdlet call at point and extract the splat"
  (interactive)
  (let (boundaries pos1 pos2 myStr chunks cmdlet-name params result)
    (setq boundaries (bounds-of-thing-at-point 'line))
    (setq pos1 (car boundaries))
    (setq pos2 (cdr boundaries))
    (setq myStr (thing-at-point 'line))
    (setq chunks (split-string myStr " -"))
    (setq cmdlet-name (car chunks))
    (setq params (cdr chunks))
    (delete-region pos1 pos2)
    (setq result
          (format
           "$splat = @{\n%s\n}\n%s @splat"
           (mapconcat 'powershell-make-name-value-pair params "\n")
           cmdlet-name))
    (insert result)))

; e.g. Make-Object -jlkjlk jkjkj -asdf ljkjlk -kjlkj


; End of PowerShell stuff.

; http://www.masteringemacs.org/articles/2011/02/08/mastering-key-bindings-emacs/
; Original version.
;; (defun mp-insert-date ()
;;   (interactive)
;;   (insert (format-time-string "%Y.%m.%d (%a)")))

; This is my newer version which, if you type C-u first, starts an Org
; heading with the date in it and creates some space for you to start
; a little org entry
(defun mp-insert-date (arg)
  "Display the value of the raw prefix arg."
  (interactive "P")
  (if (equal arg '(4))
      (progn
        (insert (format-time-string "* %Y.%m.%d (%a)"))
        (org-open-line 2)
        (insert "

"))
    (insert (format-time-string "%Y.%m.%d (%a)"))))

(defun mp-insert-time ()
  (interactive)
  (insert (format-time-string "%X")))
 
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))


(global-set-key [f1] 'shell)
(when (equal system-type 'windows-nt)
  (global-set-key [f2] 'powershell))

(defun soft-wrap-lines ()
  "Make lines wrap at window edge and on word boundary,
in current buffer."
  (interactive)
  (setq truncate-lines nil)
  (setq word-wrap t)
  )

; Sharepoint.
(defun open-sharepoint-url (url)
  "Take a SharePoint URL, convert it to a UNC share and open it (doesn't work in doc lib subfolders yet"
  (interactive "sEnter SharePoint URL: ")
  (let (pieces formremoved)
    ;(message "URL: %s" url)
    (setq pieces (cdr (cdr (nbutlast (split-string url "/") 1))))
    (if (string= (car (last pieces)) "Forms") (setq formremoved (nbutlast pieces 1)) (setq formremoved pieces))
    (setcar formremoved (concat (car formremoved) "@ssl"))
    (find-file (concat "//" (mapconcat 'identity formremoved "/")))
    ))

; http://superuser.com/questions/312723/how-to-break-out-of-ido-find-files-searching-for
(add-hook 'ido-setup-hook 'shab-ido-config)
(defun shab-ido-config()
;; disable auto searching for files unless called explicitly with C-c C-s
(setq ido-auto-merge-delay-time 99999)
(define-key ido-file-dir-completion-map (kbd "C-c C-s")
  (lambda()
    (interactive)
    (ido-initiate-auto-merge (current-buffer)))))

; Launch MS SQL session.
(defun sqlsession ()
  (interactive)
  (sql-ms)
  (rename-buffer "SQL Output")
  (find-file "~/scratch.sql"))

; Maximise when launched on OS X.
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;; http://www.blogbyben.com/2013/09/emacs-function-humanifying-urls.html
(defun url-humanify ()
  "Take the URL at point and make it human readable."
  (interactive)
  (let* ((area (bounds-of-thing-at-point 'url))
         (num-params  (count-occurances-in-region "&" (car area) (cdr area)))
         (i 0))
    (beginning-of-thing 'url)
    (when (search-forward "?" (cdr area) t nil)
      (insert "\n  ")
      (while (< i num-params)
        (search-forward "&" nil t nil)
        (insert "\n  ")
        (save-excursion
          (previous-line)
          (beginning-of-line)
          (let ((start (search-forward "="))
                (end (search-forward "&")))
            (url-decode-region start end)))
        (setq i (+ i 1))))))

(defun url-decode-region (start end)
  "Replace a region with the same contents, only URL decoded."
  (interactive "r")
  (let ((text (url-unhex-string (buffer-substring start end))))
    (delete-region start end)
    (insert text)))

(defun count-occurances-in-region (needle start end)
  (save-excursion
    (let ((found 0))
      (goto-char start)
      (while (search-forward needle end t nil)
        (setq found (+ found 1)))
      found)))

(defun new-post (title)
  "Start a new blog post"
  (setq path "~//preavy.github.com/_posts/")
  (interactive "sTitle: ")
  (find-file (concat path (format-time-string "%Y-%m-%d") "-"
                     (replace-regexp-in-string " " "-" title) ".md"))
  (set-buffer-file-coding-system 'utf-8)
  (insert "---
layout: post
category : nil
tags : []
---
")
  )

; http://www.masteringemacs.org/articles/2010/12/22/fixing-mark-commands-transient-mark-mode/
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))
