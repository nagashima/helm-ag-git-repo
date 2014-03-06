;;; helm-ag-git-repo.el

;; Copyright (C) 2014 by NAGASHIMA Masahiko

;; Author: NAGASHIMA Masahiko <nagashima"at"gmail.com>
;; URL: https://github.com/nagashima/helm-ag-git-repo
;; Version: 0.0.1
;; Package-Requires: ((helm-ag "0.14"))
;; Keywords: Searching

;;; License:
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(require 'helm-ag)

(defgroup helm-ag-git-repo nil
  "the silver searcher with helm interface from git repository"
  :group 'helm-ag)

;;;###autoload
(defun helm-ag-git-repo ()
  (interactive)
  (let* ((helm-ag-default-directory (helm-ag-git-repo-get-top-dir))
         (header-name (format "Search at %s" helm-ag-default-directory)))
    (helm-attrset 'search-this-file nil helm-ag-source)
    (helm-attrset 'name header-name helm-ag-source)
    (helm :sources (helm-ag--select-source) :buffer "*helm-ag-git*")))

(defun helm-ag-git-repo-get-top-dir (&optional cwd)
  (setq cwd (expand-file-name (file-truename (or cwd default-directory))))
  (when (file-directory-p cwd)
    (let* ((chomp (lambda (str)
                    (when (equal (elt str (- (length str) 1)) ?\n)
                      (substring str 0 (- (length str) 1)))))
           (default-directory (file-name-as-directory cwd))
           (repository-top
            (funcall chomp
                     (shell-command-to-string "git rev-parse --show-toplevel"))))
      (when repository-top
        (file-name-as-directory (expand-file-name repository-top cwd))))))

(provide 'helm-ag-git-repo)
