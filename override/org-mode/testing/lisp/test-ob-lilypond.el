;;; test-ob-lilypond.el --- tests for ob-lilypond.el

;; Copyright (c) 2010-2014 Martyn Jago
;; Authors: Martyn Jago

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:
(unless (featurep 'ob-lilypond)
  (signal 'missing-test-dependency "Support for Lilypond code blocks"))

(save-excursion
  (set-buffer (get-buffer-create "test-ob-lilypond.el"))
  (setq org-babel-lilypond-here
        (file-name-directory
         (or load-file-name (buffer-file-name)))))

(ert-deftest ob-lilypond/assert ()
  (should t))

(ert-deftest ob-lilypond/feature-provision ()
  (should (featurep 'ob-lilypond)))

(ert-deftest ob-lilypond/check-lilypond-alias ()
  (should (fboundp 'lilypond-mode)))

(ert-deftest ob-lilypond/org-babel-tangle-lang-exts ()
  (let ((found nil)
        (list org-babel-tangle-lang-exts))
    (while list
      (when (equal (car list) '("LilyPond" . "ly"))
        (setq found t))
      (setq list (cdr list)))
    (should found)))

(ert-deftest ob-lilypond/org-babel-prep-session:lilypond ()
  (should-error (org-babel-prep-session:lilypond nil nil))
  :type 'error)

(ert-deftest ob-lilypond/ly-compile-lilyfile ()
  (should (equal
           `(,(org-babel-lilypond-determine-ly-path)    ;program
             nil                        ;infile
             "*lilypond*"               ;buffer
             t                          ;display
             ,(if org-babel-lilypond-gen-png  "--png"  "") ;&rest...
             ,(if org-babel-lilypond-gen-html "--html" "")
             ,(if org-babel-lilypond-gen-pdf "--pdf" "")
             ,(if org-babel-lilypond-use-eps  "-dbackend=eps" "")
             ,(if org-babel-lilypond-gen-svg  "-dbackend=svg" "")
             "--output=test-file"
             "test-file.ly")
           (org-babel-lilypond-compile-lilyfile "test-file.ly" t))))

(ert-deftest ob-lilypond/ly-compile-post-tangle ()
  (should (boundp 'org-babel-lilypond-compile-post-tangle)))

(ert-deftest ob-lilypond/ly-display-pdf-post-tangle ()
  (should (boundp 'org-babel-lilypond-display-pdf-post-tangle)))

(ert-deftest ob-lilypond/ly-play-midi-post-tangle ()
  (should (boundp 'org-babel-lilypond-play-midi-post-tangle)))

(ert-deftest ob-lilypond/ly-OSX-ly-path ()
  (should (boundp 'org-babel-lilypond-OSX-ly-path))
  (should (stringp org-babel-lilypond-OSX-ly-path)))

(ert-deftest ob-lilypond/ly-OSX-pdf-path ()
  (should (boundp 'org-babel-lilypond-OSX-pdf-path))
  (should (stringp org-babel-lilypond-OSX-pdf-path)))

(ert-deftest ob-lilypond/ly-OSX-midi-path ()
  (should (boundp 'org-babel-lilypond-OSX-midi-path))
  (should (stringp org-babel-lilypond-OSX-midi-path)))

(ert-deftest ob-lilypond/ly-nix-ly-path ()
  (should (boundp 'org-babel-lilypond-nix-ly-path))
  (should (stringp org-babel-lilypond-nix-ly-path)))

(ert-deftest ob-lilypond/ly-nix-pdf-path ()
  (should (boundp 'org-babel-lilypond-nix-pdf-path))
  (should (stringp org-babel-lilypond-nix-pdf-path)))

(ert-deftest ob-lilypond/ly-nix-midi-path ()
  (should (boundp 'org-babel-lilypond-nix-midi-path))
  (should (stringp org-babel-lilypond-nix-midi-path)))

(ert-deftest ob-lilypond/ly-w32-ly-path ()
  (should (boundp 'org-babel-lilypond-w32-ly-path))
  (should (stringp org-babel-lilypond-w32-ly-path)))

(ert-deftest ob-lilypond/ly-w32-pdf-path ()
  (should (boundp 'org-babel-lilypond-w32-pdf-path))
  (should (stringp org-babel-lilypond-w32-pdf-path)))

(ert-deftest ob-lilypond/ly-w32-midi-path ()
  (should (boundp 'org-babel-lilypond-w32-midi-path))
  (should (stringp org-babel-lilypond-w32-midi-path)))

(ert-deftest ob-lilypond/ly-gen-png ()
  (should (boundp 'org-babel-lilypond-gen-png)))

(ert-deftest ob-lilypond/ly-gen-svg ()
  (should (boundp 'org-babel-lilypond-gen-svg)))

(ert-deftest ob-lilypond/ly-gen-html ()
  (should (boundp 'org-babel-lilypond-gen-html)))

(ert-deftest ob-lilypond/ly-gen-html ()
  (should (boundp 'org-babel-lilypond-gen-pdf)))

(ert-deftest ob-lilypond/use-eps ()
  (should (boundp 'org-babel-lilypond-use-eps)))

(ert-deftest ob-lilypond/ly-arrange-mode ()
  (should (boundp 'org-babel-lilypond-arrange-mode)))

;; (ert-deftest ob-lilypond/org-babel-default-header-args:lilypond ()
;;   (should (equal  '((:tangle . "yes")
;;                     (:noweb . "yes")
;;                     (:results . "silent")
;;                     (:comments . "yes"))
;;                   org-babel-default-header-args:lilypond)))

;;TODO finish...
(ert-deftest ob-lilypond/org-babel-expand-body:lilypond ()
  (should (equal "This is a test"
                 (org-babel-expand-body:lilypond "This is a test" ()))))

;;TODO (ert-deftest org-babel-lilypond-test-org-babel-execute:lilypond ())
(ert-deftest ob-lilypond/ly-check-for-compile-error ()
  (set-buffer (get-buffer-create "*lilypond*"))
  (erase-buffer)
  (should (not (org-babel-lilypond-check-for-compile-error nil t)))
  (insert-file-contents (concat org-babel-lilypond-here
                                "../examples/ob-lilypond-test.error")
                        nil nil nil t)
  (goto-char (point-min))
  (should (org-babel-lilypond-check-for-compile-error nil t))
  (kill-buffer "*lilypond*"))

(ert-deftest ob-lilypond/ly-process-compile-error ()
  (find-file-other-window (concat
                           org-babel-lilypond-here
                           "../examples/ob-lilypond-broken.org"))
  (set-buffer (get-buffer-create "*lilypond*"))
  (insert-file-contents (concat
                         org-babel-lilypond-here
                         "../examples/ob-lilypond-test.error")
                        nil nil nil t)
  (goto-char (point-min))
  (search-forward "error:" nil t)
  (should-error
   (org-babel-lilypond-process-compile-error (concat
                              org-babel-lilypond-here
                              "../examples/ob-lilypond-broken.ly"))
   :type 'error)
  (set-buffer "ob-lilypond-broken.org")
  (should (equal 238 (point)))
  (exchange-point-and-mark)
  (should (equal (+ 238 (length "line 25")) (point)))
  (kill-buffer "*lilypond*")
  (kill-buffer "ob-lilypond-broken.org"))

(ert-deftest ob-lilypond/ly-mark-error-line ()
  (let ((file-name (concat
                    org-babel-lilypond-here
                    "../examples/ob-lilypond-broken.org"))
        (expected-point-min 198)
        (expected-point-max 205)
        (line "line 20"))
    (find-file-other-window file-name)
    (org-babel-lilypond-mark-error-line file-name line)
    (should (equal expected-point-min (point)))

    (exchange-point-and-mark)
    (should (= expected-point-max (point)))
    (kill-buffer (file-name-nondirectory file-name))))

(ert-deftest ob-lilypond/ly-parse-line-num ()
  (with-temp-buffer
    (insert-file-contents (concat
                           org-babel-lilypond-here
                           "../examples/ob-lilypond-test.error")
                          nil nil nil t)
    (goto-char (point-min))
    (search-forward "error:")
    (should (equal 25 (org-babel-lilypond-parse-line-num (current-buffer))))))

(ert-deftest ob-lilypond/ly-parse-error-line ()
  (let ((org-babel-lilypond-file (concat
                  org-babel-lilypond-here
                  "../examples/ob-lilypond-broken.ly")))
    (should (equal "line 20"
                   (org-babel-lilypond-parse-error-line org-babel-lilypond-file 20)))
    (should (not (org-babel-lilypond-parse-error-line org-babel-lilypond-file 0)))))

(ert-deftest ob-lilypond/ly-attempt-to-open-pdf ()
  (let ((post-tangle org-babel-lilypond-display-pdf-post-tangle)
        (org-babel-lilypond-file (concat
                  org-babel-lilypond-here
                  "../examples/ob-lilypond-test.ly"))
        (pdf-file (concat
                   org-babel-lilypond-here
                   "../examples/ob-lilypond-test.pdf")))
    (setq org-babel-lilypond-display-pdf-post-tangle t)
    (when (not (file-exists-p pdf-file))
      (set-buffer (get-buffer-create (file-name-nondirectory pdf-file)))
      (write-file pdf-file))
    (should (equal
             (concat
              (org-babel-lilypond-determine-pdf-path) " " pdf-file)
             (org-babel-lilypond-attempt-to-open-pdf org-babel-lilypond-file t)))
    (delete-file pdf-file)
    (kill-buffer (file-name-nondirectory pdf-file))
    (should (equal
             "No pdf file generated so can't display!"
             (org-babel-lilypond-attempt-to-open-pdf pdf-file)))
    (setq org-babel-lilypond-display-pdf-post-tangle post-tangle)))

(ert-deftest ob-lilypond/ly-attempt-to-play-midi ()
  (let ((post-tangle org-babel-lilypond-play-midi-post-tangle)
        (org-babel-lilypond-file (concat
                  org-babel-lilypond-here
                  "../examples/ob-lilypond-test.ly"))
        (midi-file (concat
                    org-babel-lilypond-here
                    "../examples/ob-lilypond-test.midi")))
    (setq org-babel-lilypond-play-midi-post-tangle t)
    (when (not (file-exists-p midi-file))
      (set-buffer (get-buffer-create (file-name-nondirectory midi-file)))
      (write-file midi-file))
    (should (equal
             (concat
              (org-babel-lilypond-determine-midi-path) " " midi-file)
             (org-babel-lilypond-attempt-to-play-midi org-babel-lilypond-file t)))
    (delete-file midi-file)
    (kill-buffer (file-name-nondirectory midi-file))
    (should (equal
             "No midi file generated so can't play!"
             (org-babel-lilypond-attempt-to-play-midi midi-file)))
    (setq org-babel-lilypond-play-midi-post-tangle post-tangle)))

(ert-deftest ob-lilypond/ly-determine-ly-path ()
  (should (equal org-babel-lilypond-OSX-ly-path
                 (org-babel-lilypond-determine-ly-path "darwin")))
  (should (equal org-babel-lilypond-w32-ly-path
                 (org-babel-lilypond-determine-ly-path "windows-nt")))
  (should (equal org-babel-lilypond-nix-ly-path
                 (org-babel-lilypond-determine-ly-path "nix"))))

(ert-deftest ob-lilypond/ly-determine-pdf-path ()
  (should (equal org-babel-lilypond-OSX-pdf-path
                 (org-babel-lilypond-determine-pdf-path "darwin")))
  (should (equal org-babel-lilypond-w32-pdf-path
                 (org-babel-lilypond-determine-pdf-path "windows-nt")))
  (should (equal org-babel-lilypond-nix-pdf-path
                 (org-babel-lilypond-determine-pdf-path "nix"))))

(ert-deftest ob-lilypond/ly-determine-midi-path ()
  (should (equal org-babel-lilypond-OSX-midi-path
                 (org-babel-lilypond-determine-midi-path "darwin")))
  (should (equal org-babel-lilypond-w32-midi-path
                 (org-babel-lilypond-determine-midi-path "windows-nt")))
  (should (equal org-babel-lilypond-nix-midi-path
                 (org-babel-lilypond-determine-midi-path "nix"))))

(ert-deftest ob-lilypond/ly-toggle-midi-play-toggles-flag ()
  (if org-babel-lilypond-play-midi-post-tangle
      (progn
        (org-babel-lilypond-toggle-midi-play)
         (should (not org-babel-lilypond-play-midi-post-tangle))
        (org-babel-lilypond-toggle-midi-play)
        (should org-babel-lilypond-play-midi-post-tangle))
    (org-babel-lilypond-toggle-midi-play)
    (should org-babel-lilypond-play-midi-post-tangle)
    (org-babel-lilypond-toggle-midi-play)
    (should (not org-babel-lilypond-play-midi-post-tangle))))

(ert-deftest ob-lilypond/ly-toggle-pdf-display-toggles-flag ()
  (if org-babel-lilypond-display-pdf-post-tangle
      (progn
        (org-babel-lilypond-toggle-pdf-display)
         (should (not org-babel-lilypond-display-pdf-post-tangle))
        (org-babel-lilypond-toggle-pdf-display)
        (should org-babel-lilypond-display-pdf-post-tangle))
    (org-babel-lilypond-toggle-pdf-display)
    (should org-babel-lilypond-display-pdf-post-tangle)
    (org-babel-lilypond-toggle-pdf-display)
    (should (not org-babel-lilypond-display-pdf-post-tangle))))

(ert-deftest ob-lilypond/ly-toggle-pdf-generation-toggles-flag ()
  (if org-babel-lilypond-gen-pdf
      (progn
        (org-babel-lilypond-toggle-pdf-generation)
         (should (not org-babel-lilypond-gen-pdf))
        (org-babel-lilypond-toggle-pdf-generation)
        (should org-babel-lilypond-gen-pdf))
    (org-babel-lilypond-toggle-pdf-generation)
    (should org-babel-lilypond-gen-pdf)
    (org-babel-lilypond-toggle-pdf-generation)
    (should (not org-babel-lilypond-gen-pdf))))

(ert-deftest ob-lilypond/ly-toggle-arrange-mode ()
  (if org-babel-lilypond-arrange-mode
      (progn
        (org-babel-lilypond-toggle-arrange-mode)
        (should (not org-babel-lilypond-arrange-mode))
        (org-babel-lilypond-toggle-arrange-mode)
        (should org-babel-lilypond-arrange-mode))
    (org-babel-lilypond-toggle-arrange-mode)
    (should org-babel-lilypond-arrange-mode)
    (org-babel-lilypond-toggle-arrange-mode)
    (should (not org-babel-lilypond-arrange-mode))))

(ert-deftest ob-lilypond/ly-toggle-png-generation-toggles-flag ()
  (if org-babel-lilypond-gen-png
      (progn
        (org-babel-lilypond-toggle-png-generation)
         (should (not org-babel-lilypond-gen-png))
        (org-babel-lilypond-toggle-png-generation)
        (should org-babel-lilypond-gen-png))
    (org-babel-lilypond-toggle-png-generation)
    (should org-babel-lilypond-gen-png)
    (org-babel-lilypond-toggle-png-generation)
    (should (not org-babel-lilypond-gen-png))))

(ert-deftest ob-lilypond/ly-toggle-html-generation-toggles-flag ()
  (if org-babel-lilypond-gen-html
      (progn
        (org-babel-lilypond-toggle-html-generation)
         (should (not org-babel-lilypond-gen-html))
        (org-babel-lilypond-toggle-html-generation)
        (should org-babel-lilypond-gen-html))
    (org-babel-lilypond-toggle-html-generation)
    (should org-babel-lilypond-gen-html)
    (org-babel-lilypond-toggle-html-generation)
    (should (not org-babel-lilypond-gen-html))))

(ert-deftest ob-lilypond/ly-switch-extension-with-extensions ()
  (should (equal "test-name.xyz"
                 (org-babel-lilypond-switch-extension "test-name" ".xyz")))
  (should (equal "test-name.xyz"
                 (org-babel-lilypond-switch-extension "test-name.abc" ".xyz")))
  (should (equal "test-name"
                 (org-babel-lilypond-switch-extension "test-name.abc" ""))))

(ert-deftest ob-lilypond/ly-switch-extension-with-paths ()
  (should (equal "/some/path/to/test-name.xyz"
                  (org-babel-lilypond-switch-extension "/some/path/to/test-name" ".xyz"))))

(ert-deftest ob-lilypond/ly-get-header-args ()
  (should (equal '((:tangle . "yes")
                   (:noweb . "yes")
                   (:results . "silent")
                   (:cache . "yes")
                   (:comments . "yes"))
                 (org-babel-lilypond-set-header-args t)))
  (should (equal '((:results . "file")
                   (:exports . "results"))
                 (org-babel-lilypond-set-header-args nil))))

(ert-deftest ob-lilypond/ly-set-header-args ()
  (org-babel-lilypond-set-header-args t)
  (should (equal '((:tangle . "yes")
                   (:noweb . "yes")
                   (:results . "silent")
                   (:cache . "yes")
                   (:comments . "yes"))
                 org-babel-default-header-args:lilypond))
  (org-babel-lilypond-set-header-args nil)
  (should (equal '((:results . "file")
                   (:exports . "results"))
                 org-babel-default-header-args:lilypond)))

(provide 'test-ob-lilypond)

;;; test-ob-lilypond.el ends here