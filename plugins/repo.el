(defun svn-repo-open (s)
  "Open a buffer to browse a Subversion repository."
  (interactive "sRepo: ")
  (switch-to-buffer "svn-repo")
  (svn-repo-mode)
  (shell-command (concat "svn ls " (shell-quote-argument s)) "svn-repo")
  (goto-char (point-min))
  (if	(equal "/" (substring s (- (length s) 1) (length s)))
      (insert (concat s "\n\n"))
    (insert (concat s "/\n\n"))))

(defun svn-repo-browse ()
  "Browse to the SVN folder at point in svn-repo buffer."
  (interactive)
  (let (currentFolder rootFolder)
    (setq currentFolder (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
    (goto-char (point-min))
    (setq rootFolder (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
    (svn-repo-open (concat rootFolder currentFolder))))

(defun svn-repo-up ()
  "Browse to the parent of the current SVN folder."
  (interactive)
  (let (rootFolder rootFolderPieces)
    (goto-char (point-min))
    (setq rootFolder (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
    (setq rootFolderPieces (split-string rootFolder "/" nil))
    (svn-repo-open (mapconcat 'identity (butlast(butlast rootFolderPieces)) "/"))))

(define-minor-mode svn-repo-mode
       "Toggle svn-repo mode."
      ;; The initial value.
      nil
      ;; The indicator for the mode line.
      " SVN-Repo"
      ;; The minor mode bindings.
      '(
	(("\^M") . svn-repo-browse)
	((kbd "^") . svn-repo-up)
	((kbd "n") . next-line)
	((kbd "p") . previous-line)
	))
