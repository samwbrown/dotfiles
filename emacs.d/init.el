
;; redirect 'customize' settings to other file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; local settings (no vc)
(setq local-file (concat user-emacs-directory "local.el"))
(when (file-exists-p local-file)
  (load local-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI

;; line numbers in all prog mode descendents
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Remove the splash screen
(setq inhibit-splash-screen t)

;; Remove menu bar and toolbar
(customize-set-variable 'menu-bar-mode nil)
(customize-set-variable 'tool-bar-mode nil)

;; disable scrollbars
(customize-set-variable 'scroll-bar-mode nil)
(customize-set-variable 'horizontal-scroll-bar-mode nil)

;; don't let the buffer line spacing be stretched
(setq x-stretch-cursor nil)

;; highlight current line
(global-hl-line-mode 1)

;; cursor is bar not block
;; (customize-set-variable 'cursor-type '(bar . 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; misc keys

;; eval
(global-set-key "\C-\M-R" 'eval-region)
(global-set-key "\C-\M-B" 'eval-buffer)

;; font size adjust
(keymap-global-set "C-+" 'text-scale-adjust)

;; map escape key to c-g... see how it goes
;; esc always quits
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'keyboard-quit)

;; window size
(keymap-global-set "C-{" 'shrink-window-horizontally)
(keymap-global-set "C-}" 'enlarge-window-horizontally)
(keymap-global-set "C-^" 'enlarge-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; behaviour

;; Redirect backup files to temp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

;; redirect backup files
;; (setq auto-save-file-name-transforms
;;      `((".*" ,temporary-file-directory t)))

;; autosaves apply to actual file
(auto-save-visited-mode 1)

;; allow type y / n
(setq use-short-answers t)

;; which key!
;; n.b. less useful than I thought
(which-key-mode 1)

;; recent files!
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

;; Update buffers when the underlying file has changed
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; restore files from previous session
;; note this is very slow
;;(desktop-save-mode 1)

;; restore point from last visit
(save-place-mode 1)

;; eglot
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(lua-mode .( "/opt/homebrew/bin/lua-language-server"))))

;; eww
(customize-set-value 'eww-search-prefix "https://kagi.com/search?token=z6gpEkPMQnUbg0JwIia2YhcZE4dxYfRUIBgrnxdDJvk.dBxyH2fxnyMU-iuzkTKJAn9HyrQSifS1GViGlf33QGI&q=%s")

;;;;;;;;;;;;;;;;;;;
;; org mode

(setq org-agenda-files (concat org-directory "/.org_files"))

(defun my-update-org-files()
  (interactive)
  (shell-command (concat
     "cd " org-directory " && find -name '*.org' ! -wholename './Archive*'  > .org_files")))

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
  :hook
  (lua-mode . eglot-ensure)
  :custom
  (lua-indent-level 4 "Make lua tab indent sane"))

;; auto dark
(use-package auto-dark
;;  :if (eq system-type 'darwin) ;; only on macos
  :custom
  (auto-dark-themes '((modus-vivendi-tinted) (modus-operandi-tinted)))
  :config
  (auto-dark-mode 1))

;; magit
(use-package magit)
	   
;; vertico (command completion)
(use-package vertico
  :config
  (vertico-mode 1))

;; orderless (search mod)
(use-package orderless
  :custom
  (completion-styles '(orderless)))

;; consult (completion for everything else)
(use-package consult
  :config
  (global-set-key "\C-x\ \C-r" 'consult-recent-file)
  (global-set-key "\C-s" 'consult-line)
;;  (global-set-key "\C-r" 'consult-history)
  :custom
  (completion-in-region-function #'consult-completion-in-region))

;; marginalia
(use-package marginalia
  :config
  (marginalia-mode 1))

(use-package kanata-kbd-mode
  :vc
  (:url "https://github.com/chmouel/kanata-kbd-mode/" :rev 0315b56)
  :mode
  ("\\.kbd\\'" . kanata-kbd-mode))

(use-package exec-path-from-shell
  :if (eq system-type 'darwin) ;; only on macos
  :init
  (exec-path-from-shell-initialize))

;; (use-package mixed-pitch
;;   :hook
;;   (text-mode . mixed-pitch-mode))

;; expand-region!
(use-package expand-region
  :config
  (global-set-key (kbd "C-;") 'er/expand-region)) ;
