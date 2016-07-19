; --------------------------------------------------
; Set keybindings; also open frequently used files.
; --------------------------------------------------

; Use the right option key as control on a Mac
; and use command as meta.
(when (equal system-type 'darwin)
  (setq mac-right-option-modifier 'control)
  (setq mac-command-modifier 'meta)
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin")))

(global-set-key (kbd "<f12>") 'open-document-outside-emacs)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-o") 'other-window)
(eval-after-load "dired"
  '(define-key dired-mode-map (kbd "M-o") nil))
(global-set-key (kbd "<f8>") 'svn-repo-open)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "<f11>") 'add-link-from-clipboard)
(global-set-key (kbd "C-c i d") 'mp-insert-date)
(global-set-key (kbd "C-c i t") 'mp-insert-time)
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(global-set-key (kbd "C-`") 'push-mark-no-activate)
(global-set-key (kbd "M-`") 'jump-to-mark)
(global-set-key (kbd "C-c a") 'org-agenda)

; Collapse lines.
(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


