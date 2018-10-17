;; --------------------------------------------------
;; Settings and requires.
;; --------------------------------------------------

;; Open new files in a running instance of Emacs.
(require 'server)
(setq edit-server-new-frame nil)
(server-start)

(setq inhibit-startup-screen t)
;; (scroll-bar-mode 0)
(menu-bar-mode 0)t
(tool-bar-mode 0)
(setq initial-scratch-message "")
(setq line-number-mode t)

;; Highlight current line.
(global-hl-line-mode t)

;; Copy to kill-ring upon mouse adjustments of the region.
(setq mouse-drag-copy-region t)

;; Ido.
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ; enable fuzzy matching
(setq ido-unc-hosts-cache nil)

;; EasyPG.
;(require 'epa-file)

;; Uniquify.
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")

;; Hit a to open folders in dired but close buffers as you go.
(put 'dired-find-alternate-file 'disabled nil)

;; Make copying to the other dired window the default.
(setq dired-dwim-target t)

;; Quick open of recent files.
(require 'recentf) 
(recentf-mode t)
(setq recentf-max-saved-items 50)

;; "Y or n" instead of "yes or no".
(fset 'yes-or-no-p 'y-or-n-p)

;; Replace audible bell.
(when (equal system-type 'windows-nt)
  (setq visible-bell t))

;; Show column numbers.
(setq column-number-mode t)

;; Make find-grep and find-grep-dired case-insensitive.
(setq find-grep-options "-q -i")

;; Fonts.
;;  NB to find fonts
;; (print (font-family-list))
;; 60 dashes
;; ------------------------------------------------------------
;; 70 dashes
;; ----------------------------------------------------------------------
;; 80 dashes
;; --------------------------------------------------------------------------------
(when (equal system-type 'windows-nt)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  ;; Consolas-12 gives me a frame with two windows each with 78 chars across.
  ;; (set-default-font "consolas-12")
  ;; (set-default-font "lucida console-8")
  ;; As does Droid Sans Mono 11.
  ;; (set-default-font "droid sans mono-8")
  (set-frame-font "inconsolata bold-10" nil t)
  ;; (set-frame-font "ubuntu mono-10" nil t)
  ;; Alternatively this font size lets me see a dired buffer
  ;; (set-default-font "dejavu sans mono-10")
  ;; This is an Ubuntu font alternative
  ;; (set-default-font "terminus-10")
  (global-set-key [C-wheel-up] 'text-scale-decrease)
  (global-set-key [C-wheel-down] 'text-scale-increase))
(when (equal system-type 'darwin)
  ;;(set-default-font "monospace-15")
  ;;(set-default-font "monaco-15")
  (set-frame-font "dejavu sans mono-11" nil t))
(when (equal system-type 'gnu/linux)
  (set-frame-font "monospace-15" nil t))

(require 'package)
(add-to-list
  'package-archives
  '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

;; ;; Package management.
;; (setq package-archives
;;       '(;;("marmalade" . "http://marmalade-repo.org/packages/")
;;         ("melpa" . "http://melpa.org/packages/")))

;; Autosave into a single place.
(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

;; Make deleted files go into the trash.
(setq delete-by-moving-to-trash t)

;; Enable region case conversion.
(put 'upcase-region 'disabled nil)

;; Full stop single space ends sentence.
(setq sentence-end-double-space nil) 

;; Don't wrap line by default. Let them run on off the edge of the screen.
(setq-default truncate-lines t)

;; --------------------------------------------------
;; Plugins & customisations.
;; --------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins")

;; Try to pick up common UNIX tools like grep, gunzip etc
;; from Git's bin folder.
(when (equal system-type 'windows-nt)
  (setenv "PATH"
          (concat
           "C:/Program Files/Haskell Platform/7.10.2/bin" ";"
           "C:/Program Files/Git/mingw64/bin" ";"
           "C:/Program Files/Git/usr/bin" ";"
           (getenv "PATH"))))

(setenv "NODE_PATH" "/usr/local/lib/node_modules")

(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.csc$" . csharp-mode))

(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)
(add-hook 'clojure-mode-hook          'enable-paredit-mode)
(add-hook 'clojure-mode-hook          'rainbow-delimiters-mode)
(add-hook 'markdown-mode-hook         'turn-on-auto-fill)
(add-hook 'eww-mode-hook              'set-font-to-variable-width)

(defun set-font-to-variable-width ()
  "Change font in current window to a variable-width font."
  (interactive)
  (variable-pitch-mode t))

;; --------------------------------------------------

;;
;; ace jump mode major function
;; 
(add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode)

;; PowerShell file editing.
(require 'powershell-mode)
(add-hook 'powershell-mode-hook 'subword-mode)
;; setup files ending in ".ps1" to open in powershell-mode
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))
(add-to-list 'auto-mode-alist '("\\.psm1\\'" . powershell-mode))

;; PowerShell inferior shell,
;; which doesn't like too wide an editor window for some reason,
;; possibly a PowerShell reason.
(autoload 'powershell "powershell"
  "Run powershell as a shell within emacs." t)

;; Improve scrolling on Windows.
(setq redisplay-dont-pause t)

;; Improve clipboard on Linux.
(when (equal system-type 'gnu/linux)
  (setq x-select-enable-clipboard t))

(put 'downcase-region 'disabled nil)

(fset 'tidy_duplicates
   [?\C-s ?\C-q tab ?\C-m backspace ?/ ?\C-f ?\C-f ?\C-d
          ?/ ?\C-s ?\C-q tab ?\C-m backspace ?\C-k ?\C-r
          ?/ ?\C-m ?\C-f ?\C-y ?\C-q tab ?\C-n ?\C-a])

(put 'narrow-to-region 'disabled nil)

(winner-mode 1)

(setq ac-ignore-case nil)

(set-scroll-bar-mode nil)
(setq indent-tabs-mode nil)

(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 4)
            (setq indent-tabs-mode nil)))

(setq-default indent-tabs-mode nil)

(require 'dired+)

(package-initialize)

;; Settings below here must be called AFTER package-initialise.

(ido-vertical-mode 1)
;; (global-smartscan-mode 1)

(setq org-special-ctrl-a t)

; https://www.reddit.com/r/orgmode/comments/3c4xdk/spacing_between_items_when_trees_are_folded/
(setq org-cycle-separator-lines 1)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Yasnippet.
; (yas-global-mode 1)

; (split-window-right)

(when (equal system-type 'windows-nt)
  (setq browse-url-browser-function 'browse-url-generic
         browse-url-generic-program "C:/Program Files (x86)/Mozilla Firefox/firefox.exe"))

; Ensure that Autohotkey always sees Emacs in the title of the "frame"
; https://www.gnu.org/software/emacs/manual/html_node/efaq/Displaying-the-current-file-name-in-the-titlebar.html
(setq frame-title-format "%b - Emacs")
