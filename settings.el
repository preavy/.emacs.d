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

;; Ido.
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ; enable fuzzy matching
(setq ido-unc-hosts-cache nil)

;; EasyPG.
; (require 'epa-file)

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

(when (equal system-type 'windows-nt)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  ;; Consolas-12 gives me a frame with two windows each with 78 chars across.
  ;; (set-default-font "consolas-12")
  ;; (set-default-font "lucida console-10")
  ;; As does Droid Sans Mono 11.
  (set-default-font "droid sans mono-9")
  ;; Alternatively this font size lets me see a dired buffer
  ;; (set-default-font "dejavu sans mono-10")
  ;; This is an Ubuntu font alternative
  ;; (set-default-font "terminus-10")
  (global-set-key [C-wheel-up] 'text-scale-decrease)
  (global-set-key [C-wheel-down] 'text-scale-increase))
(when (equal system-type 'darwin)
  ;;(set-default-font "monospace-15")
  ;;(set-default-font "monaco-15")
  (set-default-font "dejavu sans mono-11"))
(when (equal system-type 'gnu/linux)
  (set-default-font "monospace-15"))

;; Package management.
(setq package-archives
      '(;;("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

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

;; --------------------------------------------------
;; Plugins & customisations.
;; --------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins")

;; Try to pick up common UNIX tools like grep, gunzip etc
;; from Git's bin folder.
(when (equal system-type 'windows-nt)
  (setenv "PATH"
          (concat
           "C:/Program Files (x86)/Git/bin" ";"
           "C:/Program Files/Haskell Platform/7.10.2/bin" ";"
           "C:/Program Files/Git/usr/bin" ";"
           (getenv "PATH"))))

;;; Install fsharp-mode
;;(unless (package-installed-p 'fsharp-mode)
;;  (package-install 'fsharp-mode))

;; fsharp mode doesn't work because it looks for fsautocomplete.exe, which I don't have
;; in the file fsharp-mode-completion.el

;; perhaps I would also need?
;; C:/Program Files (x86)/Microsoft SDKs/F#/4.0/Framework/v4.0/Fsi.exe
;; C:/Program Files (x86)/Microsoft SDKs/F#/4.0/Framework/v4.0/Fsc.exe

;; (require 'fsharp-mode)

(setenv "NODE_PATH" "/usr/local/lib/node_modules")

(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))

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

;; --------------------------------------------------
;; (require 'inf-haskell)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc)
;; (remove-hook 'haskell-mode-hook 'turn-on-haskell-indent)

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

;; Edit with Emacs Chrome extension.
(require 'edit-server)
(edit-server-start)

(put 'downcase-region 'disabled nil)

(fset 'tidy_duplicates
   [?\C-s ?\C-q tab ?\C-m backspace ?/ ?\C-f ?\C-f ?\C-d
          ?/ ?\C-s ?\C-q tab ?\C-m backspace ?\C-k ?\C-r
          ?/ ?\C-m ?\C-f ?\C-y ?\C-q tab ?\C-n ?\C-a])

(put 'narrow-to-region 'disabled nil)

(winner-mode 1)

(setq ac-ignore-case nil)

;; (when (equal system-type 'windows-nt)
;;   (set-frame-parameter nil 'fullscreen 'fullboth))

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

;; Js2-mode: currently disabled because I'm fed up with 'timer' errors.
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (setq js2-basic-offset 4)
;; (require 'js2-refactor)
;; (js2r-add-keybindings-with-prefix "C-c C-m")
;; subword-mode breaks m-n and m-p and transpose word
;;(add-hook 'js-mode-hook 'subword-mode)

;; ;; Auto-complete mode.
;; ;; Load the default autocomplete configuration.
;; (require 'auto-complete-config)
;; ;; Make sure we can find the dictionaries.
;; (add-to-list 'ac-dictionary-directories
;;              "~/.emacs.d/elpa/auto-complete-20130724.1750/dict")
;; ;; Use dictionaries by default.
;; (setq-default ac-sources
;;               (add-to-list 'ac-sources 'ac-source-dictionary))
;; (global-auto-complete-mode t)
;; ;; Start auto-completion after 2 characters of a word.
;; (setq ac-auto-start 2)
;; ;; Case sensitivity is important when finding matches.

(ido-vertical-mode 1)
(global-smartscan-mode 1)

(setq org-special-ctrl-a t)

;; Yasnippet.
(yas-global-mode 1)

(split-window-right)

(when (equal system-type 'windows-nt)
  (setq browse-url-browser-function 'browse-url-generic
         browse-url-generic-program "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"))


