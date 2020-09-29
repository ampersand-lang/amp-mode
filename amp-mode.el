;;; amp-mode.el --- a simple major mode for the programming language &. -*- coding: utf-8; lexical-binding: t -*-

;; Copyright © 2020, Szymon Walter

;; Author: Szymon Walter <walterpie@protonmail.com>
;; Version: 0.0.1
;; Created: 28 Sep 2020
;; Keywords: languages
;; Homepage: https://github.com/ampersand-lang

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the MIT license.
;; For details see LICENSE in the package root.

;;; Commentary:

;; amp-mode.el only defines simple syntax highlighting and basic buffer editting options.

;;; Code:

(setq amp-keywords
      '("with!"
        "yield" "break" "continue" "return" "if" "while" "for" "match" "recur"
        "struct" "enum" "union" "tagged" "class"
        "effectful" "inline-always" "inline-never"
        "type" "node" "unit" "bool"
        "s8" "s16" "s32" "s64" "sint"
        "u8" "u16" "u32" "u64" "uint"
        "float32" "float64" "float"
        "str"
        "true" "false"))

(defun amp-completion-at-point ()
  "This is the function to be used for the hook `completion-at-point-functions'."
  (interactive)
  (let* ((bds (bounds-of-thing-at-point 'symbol))
         (start (car bds))
         (end (cdr bds)))
    (list start end amp-keywords . nil)))

(setq amp-font-lock-keywords
      (let* (
             (x-keywords '("with!"))
             (x-special-forms '("yield" "break" "continue" "return" "defer"
                                "if" "while" "for" "match" "recur"
                                "cast" "typeof" "sizeof" "alignof"
                                "inline" "no-inline" "use" "mod"))
             (x-type-constructors '("struct" "enum" "union" "tagged" "class"))
             (x-attributes '("effectful" "inline-always" "inline-never"))
             (x-types '("type" "node" "unit" "bool"
                        "s8" "s16" "s32" "s64" "sint"
                        "u8" "u16" "u32" "u64" "uint"
                        "float32" "float64" "float"
                        "str"))
             (x-constants '("true" "false"))
             (x-keywords-regexp (regexp-opt x-keywords 'words))
             (x-special-forms-regexp (regexp-opt x-special-forms 'words))
             (x-type-constructors-regexp (regexp-opt x-type-constructors 'words))
             (x-attributes-regexp (regexp-opt x-attributes 'words))
             (x-types-regexp (regexp-opt x-types 'words))
             (x-constants-regexp (regexp-opt x-constants 'words))
             (x-numbers-regexp "[0-9]+\(\.[0-9]+\)?")
             (x-doc-regexp "#!.*"))
        `(
          (,x-types-regexp . font-lock-type-face)
          (,x-constants-regexp . font-lock-constant-face)
          (,x-numbers-regexp . font-lock-constant-face)
          (,x-attributes-regexp . font-lock-function-name-face)
          (,x-special-forms-regexp . font-lock-builtin-face)
          (,x-type-constructors-regexp . font-lock-builtin-face)
          (,x-keywords-regexp . font-lock-keyword-face)
          (,x-doc-regexp . font-lock-doc-face))))

(defvar amp-mode-syntax-table nil "Syntax table for `amp-mode'.")

(setq amp-mode-syntax-table
      (let ((syn-table (make-syntax-table)))
        (modify-syntax-entry ?# "<" syn-table)
        (modify-syntax-entry ?\n ">" syn-table)
        syn-table))
      
;;;###autoload
(define-derived-mode amp-mode prog-mode "& mode"
  "Major mode for editing & (The ampersand language)"
  (setq font-lock-defaults '((amp-font-lock-keywords)))
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (add-hook 'completion-at-point-functions 'amp-completion-at-point nil 'local)
  (set-syntax-table amp-mode-syntax-table))

(provide 'amp-mode)

;;; amp-mode.el ends here
