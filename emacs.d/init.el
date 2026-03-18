
;; redirect 'customize' settings to other file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))


;; redirect autosave files to temp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; map escape key to c-g... see how it goes
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))


;; which key!
(which-key-mode 1)


;; recent files!
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)


;; line numbers everywhere
(global-display-line-numbers-mode 1)


;; Update buffers when the underlying file has changed
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)


;; don't let the buffer line spacing be stretched
(setq x-stretch-cursor nil)


;; eglot
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(lua-mode .( "/opt/homebrew/bin/lua-language-server"))))


;;;;;;;;;;;;;;;;;;;
;; external packages

;; add MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;; make all packages auto-install
(require 'use-package-ensure)
(setq use-package-always-ensure t)


;; lua-mode
(use-package lua-mode
  :defer t
  ;; auto start eglot lsp
  :hook (lua-mode . eglot-ensure)
  :config (
	   ;; default tab==3???
	   setq lua-indent-level 4)
  )


;; catppuccin theme
(use-package catppuccin-theme
  :config (setq catppuccin-flavor 'macchiato))


;; auto dark
(use-package auto-dark
  :if (eq system-type 'darwin) ;; only on macos
  :hook (
	 (auto-dark-dark-mode .  (lambda ()
				   (setq catppuccin-flavor 'macchiato)
				   (catppuccin-reload)))
	 (auto-dark-light-mode .  (lambda ()
				   (setq catppuccin-flavor 'latte)
				   (catppuccin-reload))))
  :config (
    ignore-errors
    (setq auto-dark-themes '((catppuccin) (catppuccin)))
    (auto-dark-mode 1)))
