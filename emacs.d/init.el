
;; redirect 'customize' settings to other file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI


;; line numbers everywhere
(global-display-line-numbers-mode 1)


; Remove the splash screen
(setq inhibit-splash-screen t)


;; Remove menu bar and toolbar
(customize-set-variable 'menu-bar-mode nil)
(customize-set-variable 'tool-bar-mode nil)

;; Remove scroll bars
(customize-set-variable 'set-scroll-bar-mode nil)

;; don't let the buffer line spacing be stretched
(setq x-stretch-cursor nil)

;; try different font
;;(set-default-font "Menlo 10")
(set-face-attribute 'default nil :height 130)

;;;;;;;;;;;;;;;;;;
;; speedbar (see system crafters)
(customize-set-variable 'speedbar-update-flag t)

;; Disable icon images, instead use text
(customize-set-variable 'speedbar-use-images nil)

;; Customize Speedbar Frame
(customize-set-variable 'speedbar-frame-parameters
                        '((name . "speedbar")
                          (title . "speedbar")
                          (minibuffer . nil)
                          (border-width . 2)
                          (menu-bar-lines . 0)
                          (tool-bar-lines . 0)
                          (unsplittable . t)
                          (left-fringe . 10)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; behaviour

;; eval keys
(global-set-key "\C-\M-R" 'eval-region)
(global-set-key "\C-\M-B" 'eval-buffer)

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

;; map escape key to c-g... see how it goes
;;; esc always quits
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'keyboard-quit)

;; which key!
;; n.b. less useful than I thought
;; (which-key-mode 1)

;; recent files!
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

;; Update buffers when the underlying file has changed
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

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
  :hook
  (lua-mode . eglot-ensure)
  :custom
  (lua-indent-level 4 "Make lua tab indent sane")
  )

;; catppuccin theme
(use-package catppuccin-theme
  :custom
  (catppuccin-flavor 'macchiato)
  )

;; auto dark
(use-package auto-dark
  :if (eq system-type 'darwin) ;; only on macos
  :custom
  (auto-dark-themes '((catppuccin) (modus-operandi-tinted)))
  :config
  (auto-dark-mode 1)
  )
	   
;; vertico (command completion)
(use-package vertico
  :config
  (vertico-mode 1)
  )

;; orderless (search mod)
(use-package orderless
  :custom
  (completion-styles '(orderless))
  )

;; consult (completion for everything else)
(use-package consult
  :config
  (global-set-key "\C-x\ \C-r" 'consult-recent-file)
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  )

;; marginalia
(use-package marginalia
  :config
  (marginalia-mode 1)
  )

(use-package kanata-kbd-mode
  :vc
  (:url "https://github.com/chmouel/kanata-kbd-mode/" :rev 0315b56)
  :mode
  ("\\.kbd\\'" . kanata-kbd-mode))
