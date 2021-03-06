;; A few handy functions I use in init.el (or not, but they're nice to
;; have)

(defun custom-download-theme (url filename)
  "Downloads a theme through HTTP and places it in ~/.emacs.d/themes"

  ;; Ensure the directory exists
  (unless (file-exists-p "~/.emacs.d/themes")
    (make-directory "~/.emacs.d/themes"))

  ;; Adds the themes folder to the theme load path (if not already
  ;; there)
  (unless (member "~/.emacs.d/themes" custom-theme-load-path)
    (add-to-list 'custom-theme-load-path "~/.emacs.d/themes"))

  ;; Download file if it doesn't exist.

  (let ((file
         (concat "~/.emacs.d/themes/" filename)))
    (unless (file-exists-p file)
      (url-copy-file url file))))

(defun custom-download-script (url filename)
  "Downloads an Elisp script, places it in ~/.emacs/other and then loads it"

  ;; Ensure the directory exists
  (unless (file-exists-p "~/.emacs.d/other")
    (make-directory "~/.emacs.d/other"))

  ;; Download file if it doesn't exist.
  (let ((file
         (concat "~/.emacs.d/other/" filename)))
    (unless (file-exists-p file)
      (url-copy-file url file))

    (load file)))

(defun keychain-password (account &optional keychain)
  "Returns the password for the account, by default it's looked up in the Login.keychain but a
   different keychain can be specified."
  (let ((k (if keychain keychain "Login.keychain")))
    (replace-regexp-in-string
     "\n" ""
     (shell-command-to-string (concat  "security find-generic-password -w -a "
                                       account
                                       " "
                                       k)))))

;; This clones a git repository to 'foldername in .emacs.d
;; if there isn't already a folder with that name
(defun custom-clone-git (url foldername)
  "Clones a git repository to .emacs.d/foldername"
  (let ((fullpath (concat "~/.emacs.d/" foldername)))
    (unless (file-exists-p fullpath)
      (async-shell-command (concat "git clone " url " " fullpath)))))

(defun load-file-if-exists (filename)
  (if (file-exists-p filename)
      (load filename)))

;; These are my own functions, not tazjins
(defun invert-colors ()
  (interactive)
  (invert-face 'default)
)



;; These come from magnars, he's got some awesome things.

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (call-interactively 'goto-line))
    (linum-mode -1)))


(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (indent-buffer))

;; These come from the emacs starter kit

(defun esk-add-watchwords ()
  (font-lock-add-keywords
   nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|DEBUG\\|HACK\\|REFACTOR\\|NOCOMMIT\\)"
          1 font-lock-warning-face t))))

(defun esk-sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun ni-set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun set-window-width ()
  "Set the selected window's width."
  (interactive
   (ni-set-window-width  (read-number "Width: "))
   ))

(defun set-window-width-fill ()
  (interactive)
  (ni-set-window-width fill-column))

(provide 'functions)
