;;; espuds-movement.el --- Movement related definitions


;; Goes to LINE if it exist.
;;
;; Usage:
;;   When I go to line "12"
(When "^I go to line \"\\([0-9]+\\)\"$"
      (lambda (line)
        (let ((num-lines (count-lines (point-min) (point-max)))
              (line-num (string-to-number line))
              (message "Requested line '%s', but buffer only has '%d' line(s)."))
          (assert (<= line-num num-lines) nil message line num-lines)
          (goto-line line-num))))

;; Goes to POINT if it exist.
;;
;; Usage:
;;   When I go to point "12"
(When "^I go to point \"\\([0-9]+\\)\"$"
      (lambda (point)
        (let ((size (buffer-size))
              (point-num (string-to-number point))
              (message "Requested point '%s', but buffer only has '%d' point(s)."))
          (assert (<= point-num size) nil message point-num size)
          (goto-char point-num))))

;; Go to WORD if it exist.
;;
;; Usage:
;;   When I go to word "SOME WORD"
(When "^I go to word \"\\(.+\\)\"$"
      (lambda (word)
        (goto-char (point-min))
        (let ((search (re-search-forward (format "\\b%s\\b" word) nil t))
              (message "Can not go to word '%s' since it does not exist in the current buffer: %s"))
          (assert search nil message word (espuds-buffer-contents)))
        (backward-char (length word))))

;; Checks that the cursor is before some text.
;;
;; Usage:
;;   Then the cursor should be before "Foo"
(Then "^the cursor should be before \"\\(.+\\)\"$"
      (lambda (expected)
        (let ((actual
               (progn
                 (buffer-substring-no-properties (point) (min (point-max) (+ (point) 5)))))
              (message "Expected '%s' to be before point but was '%s'."))
          (assert (looking-at (regexp-quote expected)) nil message expected actual))))

;; Checks that the cursor is after some text.
;;
;; Usage:
;;   Then the cursor should be after "Foo"
(Then "^the cursor should be after \"\\(.+\\)\"$"
      (lambda (expected)
        (let ((actual
               (progn
                 (buffer-substring-no-properties (point) (max (point-min) (- (point) 5)))))
              (message "Expected '%s' to be after point but was '%s'."))
          (assert (looking-back (regexp-quote expected)) nil message expected actual))))

;; Checks that the cursor is between some text.
;;
;; Usage:
;;   Then the cursor should be between "Foo" and "Bar"
(Then "^the cursor should be between \"\\(.+\\)\" and \"\\(.+\\)\"$"
      (lambda (left right)
        (let ((search
               (and
                (looking-back (regexp-quote left))
                (looking-at (regexp-quote right))))
              (message "Expected '%s' to be left of point and '%s' to be right of point, but was: '%s[CURSOR]%s'")
              (before
               (buffer-substring-no-properties
                (max (point-min) (- (point) 5))
                (point)))
              (after
               (buffer-substring-no-properties
                (point)
                (min (point-max) (+ (point) 5)))))
          (assert search nil message left right before after))))

;; Places the cursor between text.
;;
;; Usage:
;;   When I place the cursor between "Foo" and "Bar"
(When "^I place the cursor between \"\\(.+\\)\" and \"\\(.+\\)\"$"
      (lambda (left right)
        (goto-char (point-min))
        (let ((search (search-forward (concat left right) nil t))
              (message "Can not place cursor between '%s' and '%s', because there is no such point: '%s'"))
          (assert search nil message left right (espuds-buffer-contents)))
        (backward-char (length right))))

;; Places the cursor at the beginning of buffer.
;;
;; Usage:
;;   When I go to beginning of buffer
(When "^I go to beginning of buffer$" 'beginning-of-buffer)

;; Places the cursor at the end of buffer.
;;
;; Usage:
;;   When I go to end of buffer
(When "^I go to end of buffer$" 'end-of-buffer)


(provide 'espuds-movement)

;;; espuds-movement.el ends here
