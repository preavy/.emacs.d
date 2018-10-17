(prefer-coding-system 'utf-8)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load "~/.emacs.d/settings")
(load "~/.emacs.d/defuns")
(load "~/.emacs.d/workstation" "NOERROR")
(load "~/.emacs.d/keybindings")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(package-selected-packages
   (quote
    (zenburn-theme yaml-mode solarized-theme smex smartscan smart-mode-line-powerline-theme rainbow-delimiters php-mode paredit markdown-mode magit js2-refactor intero ido-vertical-mode fsharp-mode expand-region dired+ csharp-mode auto-complete ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
