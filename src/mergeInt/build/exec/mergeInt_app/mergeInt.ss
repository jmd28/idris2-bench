#!/usr/bin/scheme --script

; @generated
(import (chezscheme))
(case (machine-type)
  [(i3le ti3le a6le ta6le) (load-shared-object "libc.so.6")]
  [(i3osx ti3osx a6osx ta6osx) (load-shared-object "libc.dylib")]
  [(i3nt ti3nt a6nt ta6nt) (load-shared-object "msvcrt.dll")                           (load-shared-object "ws2_32.dll")]
  [else (load-shared-object "libc.so")])



(let ()
(define (blodwen-os)
  (case (machine-type)
    [(i3le ti3le a6le ta6le) "unix"]  ; GNU/Linux
    [(i3ob ti3ob a6ob ta6ob) "unix"]  ; OpenBSD
    [(i3fb ti3fb a6fb ta6fb) "unix"]  ; FreeBSD
    [(i3nb ti3nb a6nb ta6nb) "unix"]  ; NetBSD
    [(i3osx ti3osx a6osx ta6osx) "darwin"]
    [(i3nt ti3nt a6nt ta6nt) "windows"]
    [else "unknown"]))

(define blodwen-read-args (lambda (desc)
  (case (vector-ref desc 0)
    ((0) '())
    ((1) (cons (vector-ref desc 2)
               (blodwen-read-args (vector-ref desc 3)))))))
(define b+ (lambda (x y bits) (remainder (+ x y) (ash 1 bits))))
(define b- (lambda (x y bits) (remainder (- x y) (ash 1 bits))))
(define b* (lambda (x y bits) (remainder (* x y) (ash 1 bits))))
(define b/ (lambda (x y bits) (remainder (exact-floor (/ x y)) (ash 1 bits))))

(define integer->bits8 (lambda (x) (modulo x (expt 2 8))))
(define integer->bits16 (lambda (x) (modulo x (expt 2 16))))
(define integer->bits32 (lambda (x) (modulo x (expt 2 32))))
(define integer->bits64 (lambda (x) (modulo x (expt 2 64))))

(define bits16->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits32->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits32->bits16 (lambda (x) (modulo x (expt 2 16))))
(define bits64->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits64->bits16 (lambda (x) (modulo x (expt 2 16))))
(define bits64->bits32 (lambda (x) (modulo x (expt 2 32))))

(define blodwen-bits-shl (lambda (x y bits) (remainder (ash x y) (ash 1 bits))))
(define blodwen-shl (lambda (x y) (ash x y)))
(define blodwen-shr (lambda (x y) (ash x (- y))))
(define blodwen-and (lambda (x y) (logand x y)))
(define blodwen-or (lambda (x y) (logor x y)))
(define blodwen-xor (lambda (x y) (logxor x y)))

(define cast-num
  (lambda (x)
    (if (number? x) x 0)))
(define destroy-prefix
  (lambda (x)
    (cond
      ((equal? x "") "")
      ((equal? (string-ref x 0) #\#) "")
      (else x))))
(define exact-floor
  (lambda (x)
    (inexact->exact (floor x))))
(define cast-string-int
  (lambda (x)
    (exact-floor (cast-num (string->number (destroy-prefix x))))))
(define cast-int-char
  (lambda (x)
    (if (and (>= x 0)
             (<= x #x10ffff))
        (integer->char x)
        0)))
(define cast-string-double
  (lambda (x)
    (cast-num (string->number (destroy-prefix x)))))

(define (from-idris-list xs)
  (if (= (vector-ref xs 0) 0)
    '()
    (cons (vector-ref xs 1) (from-idris-list (vector-ref xs 2)))))
(define (string-pack xs) (apply string (from-idris-list xs)))
(define (to-idris-list-rev acc xs)
  (if (null? xs)
    acc
    (to-idris-list-rev (vector 1 (car xs) acc) (cdr xs))))
(define (string-unpack s) (to-idris-list-rev (vector 0) (reverse (string->list s))))
(define (string-concat xs) (apply string-append (from-idris-list xs)))
(define string-cons (lambda (x y) (string-append (string x) y)))
(define get-tag (lambda (x) (vector-ref x 0)))
(define string-reverse (lambda (x)
  (list->string (reverse (string->list x)))))
(define (string-substr off len s)
    (let* ((l (string-length s))
          (b (max 0 off))
          (x (max 0 len))
          (end (min l (+ b x))))
          (if (> b l)
              ""
              (substring s b end))))

(define (blodwen-string-iterator-new s)
  0)

(define (blodwen-string-iterator-next s ofs)
  (if (>= ofs (string-length s))
      (vector 0)  ; EOF
      (vector 1 (string-ref s ofs) (+ ofs 1))))

(define either-left
  (lambda (x)
    (vector 0 x)))

(define either-right
  (lambda (x)
    (vector 1 x)))

(define blodwen-error-quit
  (lambda (msg)
    (display msg)
    (newline)
    (exit 1)))

(define (blodwen-get-line p)
    (if (port? p)
        (let ((str (get-line p)))
            (if (eof-object? str)
                ""
                str))
        void))

(define (blodwen-get-char p)
    (if (port? p)
        (let ((chr (get-char p)))
            (if (eof-object? chr)
                #\nul
                chr))
        void))

;; Buffers

(define (blodwen-new-buffer size)
  (make-bytevector size 0))

(define (blodwen-buffer-size buf)
  (bytevector-length buf))

(define (blodwen-buffer-setbyte buf loc val)
  (bytevector-u8-set! buf loc val))

(define (blodwen-buffer-getbyte buf loc)
  (bytevector-u8-ref buf loc))

(define (blodwen-buffer-setbits16 buf loc val)
  (bytevector-u16-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits16 buf loc)
  (bytevector-u16-ref buf loc (native-endianness)))

(define (blodwen-buffer-setbits32 buf loc val)
  (bytevector-u32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits32 buf loc)
  (bytevector-u32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setbits64 buf loc val)
  (bytevector-u64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits64 buf loc)
  (bytevector-u64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint32 buf loc val)
  (bytevector-s32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint32 buf loc)
  (bytevector-s32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint buf loc val)
  (bytevector-s64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint buf loc)
  (bytevector-s64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setdouble buf loc val)
  (bytevector-ieee-double-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getdouble buf loc)
  (bytevector-ieee-double-ref buf loc (native-endianness)))

(define (blodwen-stringbytelen str)
  (bytevector-length (string->utf8 str)))

(define (blodwen-buffer-setstring buf loc val)
  (let* [(strvec (string->utf8 val))
         (len (bytevector-length strvec))]
    (bytevector-copy! strvec 0 buf loc len)))

(define (blodwen-buffer-getstring buf loc len)
  (let [(newvec (make-bytevector len))]
    (bytevector-copy! buf loc newvec 0 len)
    (utf8->string newvec)))

(define (blodwen-buffer-copydata buf start len dest loc)
  (bytevector-copy! buf start dest loc len))

;; Threads

(define blodwen-thread-data (make-thread-parameter #f))

(define (blodwen-thread p)
    (fork-thread (lambda () (p (vector 0)))))

(define (blodwen-get-thread-data ty)
  (blodwen-thread-data))

(define (blodwen-set-thread-data a)
  (blodwen-thread-data a))

(define (blodwen-mutex) (make-mutex))
(define (blodwen-lock m) (mutex-acquire m))
(define (blodwen-unlock m) (mutex-release m))
(define (blodwen-thisthread) (get-thread-id))

(define (blodwen-condition) (make-condition))
(define (blodwen-condition-wait c m) (condition-wait c m))
(define (blodwen-condition-wait-timeout c m t)
  (let ((sec (div t 1000000))
        (micro (mod t 1000000)))
  (condition-wait c m (make-time 'time-duration (* 1000 micro) sec))))
(define (blodwen-condition-signal c) (condition-signal c))
(define (blodwen-condition-broadcast c) (condition-broadcast c))

(define (blodwen-sleep s) (sleep (make-time 'time-duration 0 s)))
(define (blodwen-usleep s)
  (let ((sec (div s 1000000))
        (micro (mod s 1000000)))
       (sleep (make-time 'time-duration (* 1000 micro) sec))))

(define (blodwen-time) (time-second (current-time)))
(define (blodwen-clock-time-utc) (current-time 'time-utc))
(define (blodwen-clock-time-monotonic) (current-time 'time-monotonic))
(define (blodwen-clock-time-duration) (current-time 'time-duration))
(define (blodwen-clock-time-process) (current-time 'time-process))
(define (blodwen-clock-time-thread) (current-time 'time-thread))
(define (blodwen-clock-time-gccpu) (current-time 'time-collector-cpu))
(define (blodwen-clock-time-gcreal) (current-time 'time-collector-real))
(define (blodwen-is-time? clk) (if (time? clk) 1 0))
(define (blodwen-clock-second time) (time-second time))
(define (blodwen-clock-nanosecond time) (time-nanosecond time))

(define (blodwen-args)
  (define (blodwen-build-args args)
    (if (null? args)
        (vector 0) ; Prelude.List
        (vector 1 (car args) (blodwen-build-args (cdr args)))))
    (blodwen-build-args (command-line)))

(define (blodwen-hasenv var)
  (if (eq? (getenv var) #f) 0 1))

(define (blodwen-system cmd)
  (system cmd))

;; Randoms
(define random-seed-register 0)
(define (initialize-random-seed-once)
  (if (= (virtual-register random-seed-register) 0)
      (let ([seed (time-nanosecond (current-time))])
        (set-virtual-register! random-seed-register seed)
        (random-seed seed))))

(define (blodwen-random-seed seed)
  (set-virtual-register! random-seed-register seed)
  (random-seed seed))
(define blodwen-random
  (case-lambda
    ;; no argument, pick a real value from [0, 1.0)
    [() (begin
          (initialize-random-seed-once)
          (random 1.0))]
    ;; single argument k, pick an integral value from [0, k)
    [(k)
      (begin
        (initialize-random-seed-once)
        (if (> k 0)
              (random k)
              (assertion-violationf 'blodwen-random "invalid range argument ~a" k)))]))

;; For finalisers

(define blodwen-finaliser (make-guardian))
(define (blodwen-register-object obj proc)
  (let [(x (cons obj proc))]
       (blodwen-finaliser x)
       x))
(define blodwen-run-finalisers
  (lambda ()
    (let run ()
      (let ([x (blodwen-finaliser)])
        (when x
          (((cdr x) (car x)) 'erased)
          (run))))))
(define Prelude-IO-prim__putStr (lambda (farg-0 farg-1) ((foreign-procedure #f "idris2_putStr" (string) void) farg-0) (vector 0 )))
(define prim__add_Integer (lambda (arg-0 arg-1) (+ arg-0 arg-1)))
(define prim__sub_Integer (lambda (arg-0 arg-1) (- arg-0 arg-1)))
(define prim__mul_Integer (lambda (arg-0 arg-1) (* arg-0 arg-1)))
(define prim__lt_Integer (lambda (arg-0 arg-1) (or (and (< arg-0 arg-1) 1) 0)))
(define prim__lte_Integer (lambda (arg-0 arg-1) (or (and (<= arg-0 arg-1) 1) 0)))
(define prim__eq_Integer (lambda (arg-0 arg-1) (or (and (= arg-0 arg-1) 1) 0)))
(define prim__eq_Char (lambda (arg-0 arg-1) (or (and (char=? arg-0 arg-1) 1) 0)))
(define prim__gte_Integer (lambda (arg-0 arg-1) (or (and (>= arg-0 arg-1) 1) 0)))
(define prim__gt_Integer (lambda (arg-0 arg-1) (or (and (> arg-0 arg-1) 1) 0)))
(define prim__strHead (lambda (arg-0) (string-ref arg-0 0)))
(define prim__strAppend (lambda (arg-0 arg-1) (string-append arg-0 arg-1)))
(define prim__cast_IntegerString (lambda (arg-0) (number->string arg-0)))
(define Main-main (lambda () (let ((x (Data-List-sort 'erased (vector 0 (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-EqOrd-C-61C-61_Eq__Integer arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-EqOrd-C-47C-61_Eq__Integer arg-4 arg-5)))) (lambda (arg-369) (lambda (arg-370) (Prelude-EqOrd-compare_Ord__Integer arg-369 arg-370))) (lambda (arg-371) (lambda (arg-372) (Prelude-EqOrd-C-60_Ord__Integer arg-371 arg-372))) (lambda (arg-373) (lambda (arg-374) (Prelude-EqOrd-C-62_Ord__Integer arg-373 arg-374))) (lambda (arg-375) (lambda (arg-376) (Prelude-EqOrd-C-60C-61_Ord__Integer arg-375 arg-376))) (lambda (arg-377) (lambda (arg-378) (Prelude-EqOrd-C-62C-61_Ord__Integer arg-377 arg-378))) (lambda (arg-379) (lambda (arg-380) (Prelude-EqOrd-max_Ord__Integer arg-379 arg-380))) (lambda (arg-381) (lambda (arg-382) (Prelude-EqOrd-min_Ord__Integer arg-381 arg-382)))) (vector 1 8 (vector 1 4 (vector 1 5 (vector 1 7 (vector 1 6 (vector 1 1 (vector 1 3 (vector 1 3 (vector 1 2 (vector 1 6 (vector 1 9 (vector 0 ))))))))))))))) (Prelude-IO-putStrLn 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (Prelude-IO-map_Functor__IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-6794) arg-6794))) (Prelude-Show-show_Show__C-40ListC-32C-36aC-41 'erased (vector 0 (lambda (x-0) (Prelude-Show-show_Show__Integer x-0)) (lambda (d) (lambda (x-0) (Prelude-Show-showPrec_Show__Integer d x-0)))) x)))))
(define Data-List-case--sortBy-3508 (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-3)) (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (Data-List-mergeBy 'erased arg-2 (Data-List-sortBy 'erased arg-2 e-2) (Data-List-sortBy 'erased arg-2 e-3)))))))
(define Data-List-case--mergeBy-3363 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6) (let ((sc0 arg-6)) (cond ((equal? sc0 0) (vector 1 arg-1 (Data-List-mergeBy 'erased arg-5 arg-2 (vector 1 arg-3 arg-4))))(else (vector 1 arg-3 (Data-List-mergeBy 'erased arg-5 (vector 1 arg-1 arg-2) arg-4)))))))
(define Data-List-n--4422-3459-splitRec (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6) (let ((sc0 arg-4)) (case (vector-ref sc0 0) ((1) (let ((e-2 (vector-ref sc0 2))) (let ((sc1 e-2)) (case (vector-ref sc1 0) ((1) (let ((e-5 (vector-ref sc1 2))) (let ((sc2 arg-5)) (case (vector-ref sc2 0) ((1) (let ((e-7 (vector-ref sc2 1))) (let ((e-8 (vector-ref sc2 2))) (Data-List-n--4422-3459-splitRec 'erased arg-1 arg-2 'erased e-5 e-8 (lambda (eta-0) (arg-6 (vector 1 e-7 eta-0)))))))(else (vector 0 arg-5 (arg-6 (vector 0 ))))))))(else (vector 0 arg-5 (arg-6 (vector 0 ))))))))(else (vector 0 arg-5 (arg-6 (vector 0 ))))))))
(define Data-List-n--4422-3460-split (lambda (arg-0 arg-1 arg-2 arg-3) (Data-List-n--4422-3459-splitRec 'erased arg-1 arg-2 'erased arg-3 arg-3 (lambda (eta-0) eta-0))))
(define Data-List-sortBy (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (case (vector-ref sc0 0) ((0) (vector 0 )) ((1) (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (let ((sc1 e-3)) (case (vector-ref sc1 0) ((0) (vector 1 e-2 (vector 0 )))(else (Data-List-case--sortBy-3508 'erased arg-2 arg-1 (Data-List-n--4422-3460-split 'erased arg-2 arg-1 arg-2))))))))(else (Data-List-case--sortBy-3508 'erased arg-2 arg-1 (Data-List-n--4422-3460-split 'erased arg-2 arg-1 arg-2)))))))
(define Data-List-sort (lambda (arg-0 arg-1 ext-0) (Data-List-sortBy 'erased (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-2) (lambda (arg-3) ((e-2 arg-2) arg-3))))) ext-0)))
(define Data-List-mergeBy (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-2)) (case (vector-ref sc0 0) ((0) arg-3)(else (let ((sc0 arg-3)) (case (vector-ref sc0 0) ((0) arg-2)(else (let ((sc0 arg-2)) (let ((e-1 (vector-ref sc0 1))) (let ((e-2 (vector-ref sc0 2))) (let ((sc1 arg-3)) (let ((e-4 (vector-ref sc1 1))) (let ((e-5 (vector-ref sc1 2))) (Data-List-case--mergeBy-3363 'erased e-1 e-2 e-4 e-5 arg-1 ((arg-1 e-1) e-4))))))))))))))))
(define Prelude-Basics-not (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1) (else 0)))))
(define Prelude-Basics-intToBool (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-Basics-id (lambda (arg-0 arg-1) arg-1))
(define Prelude-Basics-C-46 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 ext-0) (arg-3 (arg-4 ext-0))))
(define Prelude-Basics-C-38C-38 (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (cond ((equal? sc0 0) (arg-1)) (else 1)))))
(define Builtin-assert_total (lambda (arg-0 arg-1) arg-1))
(define Builtin-assert_smaller (lambda (arg-0 arg-1 arg-2 arg-3) arg-3))
(define Prelude-Types-case--max-662 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) arg-1) (else arg-0)))))
(define Prelude-Types-case--min-648 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) arg-1) (else arg-0)))))
(define Prelude-Types-min_Ord__Nat (lambda (arg-0 arg-1) (Prelude-Types-case--min-648 arg-1 arg-0 (Prelude-Types-C-60_Ord__Nat arg-0 arg-1))))
(define Prelude-Types-max_Ord__Nat (lambda (arg-0 arg-1) (Prelude-Types-case--max-662 arg-1 arg-0 (Prelude-Types-C-62_Ord__Nat arg-0 arg-1))))
(define Prelude-Types-compare_Ord__Nat (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (cond ((equal? sc0 0) (let ((sc1 arg-1)) (cond ((equal? sc1 0) 1)(else 0))))(else (let ((e-0 (- arg-0 1))) (let ((sc0 arg-1)) (cond ((equal? sc0 0) 2)(else (let ((e-2 (- arg-1 1))) (Prelude-Types-compare_Ord__Nat e-0 e-2)))))))))))
(define Prelude-Types-__Impl_Ord_Nat (lambda () (vector 0 (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-Types-C-61C-61_Eq__Nat arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-Types-C-47C-61_Eq__Nat arg-4 arg-5)))) (lambda (arg-369) (lambda (arg-370) (Prelude-Types-compare_Ord__Nat arg-369 arg-370))) (lambda (arg-371) (lambda (arg-372) (Prelude-Types-C-60_Ord__Nat arg-371 arg-372))) (lambda (arg-373) (lambda (arg-374) (Prelude-Types-C-62_Ord__Nat arg-373 arg-374))) (lambda (arg-375) (lambda (arg-376) (Prelude-Types-C-60C-61_Ord__Nat arg-375 arg-376))) (lambda (arg-377) (lambda (arg-378) (Prelude-Types-C-62C-61_Ord__Nat arg-377 arg-378))) (lambda (arg-379) (lambda (arg-380) (Prelude-Types-max_Ord__Nat arg-379 arg-380))) (lambda (arg-381) (lambda (arg-382) (Prelude-Types-min_Ord__Nat arg-381 arg-382))))))
(define Prelude-Types-__Impl_Eq_Nat (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-Types-C-61C-61_Eq__Nat arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-Types-C-47C-61_Eq__Nat arg-4 arg-5))))))
(define Prelude-Types-C-62_Ord__Nat (lambda (arg-0 arg-1) (Prelude-EqOrd-C-61C-61_Eq__Ordering (Prelude-Types-compare_Ord__Nat arg-0 arg-1) 2)))
(define Prelude-Types-C-62C-61_Ord__Nat (lambda (arg-0 arg-1) (Prelude-EqOrd-C-47C-61_Eq__Ordering (Prelude-Types-compare_Ord__Nat arg-0 arg-1) 0)))
(define Prelude-Types-C-61C-61_Eq__Nat (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (cond ((equal? sc0 0) (let ((sc1 arg-1)) (cond ((equal? sc1 0) 0)(else 1))))(else (let ((e-0 (- arg-0 1))) (let ((sc0 arg-1)) (cond ((equal? sc0 0) 1)(else (let ((e-1 (- arg-1 1))) (Prelude-Types-C-61C-61_Eq__Nat e-0 e-1)))))))))))
(define Prelude-Types-C-60_Ord__Nat (lambda (arg-0 arg-1) (Prelude-EqOrd-C-61C-61_Eq__Ordering (Prelude-Types-compare_Ord__Nat arg-0 arg-1) 0)))
(define Prelude-Types-C-60C-61_Ord__Nat (lambda (arg-0 arg-1) (Prelude-EqOrd-C-47C-61_Eq__Ordering (Prelude-Types-compare_Ord__Nat arg-0 arg-1) 2)))
(define Prelude-Types-C-47C-61_Eq__Nat (lambda (arg-0 arg-1) (Prelude-Basics-not (Prelude-Types-C-61C-61_Eq__Nat arg-0 arg-1))))
(define Prelude-Types-Strings-C-43C-43 (lambda (arg-0 arg-1) (string-append arg-0 arg-1)))
(define Prelude-Num-fromInteger_Num__Integer (lambda (ext-0) ext-0))
(define Prelude-Num-__Impl_Num_Integer (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (+ arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (* arg-4 arg-5))) (lambda (arg-6) arg-6))))
(define Prelude-Num-C-43_Num__Integer (lambda (ext-0 ext-1) (+ ext-0 ext-1)))
(define Prelude-Num-C-42_Num__Integer (lambda (ext-0 ext-1) (* ext-0 ext-1)))
(define Prelude-Num-fromInteger (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-3 (vector-ref sc0 3))) (lambda (arg-2) (e-3 arg-2))))))
(define Prelude-Num-defaultInteger (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (+ arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (* arg-4 arg-5))) (lambda (arg-6) arg-6))))
(define Prelude-EqOrd-case--caseC-32blockC-32inC-32compare-1301 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) 1) (else 2)))))
(define Prelude-EqOrd-case--compare-1284 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) 0) (else (Prelude-EqOrd-case--caseC-32blockC-32inC-32compare-1301 arg-0 arg-1 (Prelude-EqOrd-C-61C-61_Eq__Integer arg-1 arg-0)))))))
(define Prelude-EqOrd-case--max-1267 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) arg-1) (else arg-0)))))
(define Prelude-EqOrd-case--min-1253 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) arg-1) (else arg-0)))))
(define Prelude-EqOrd-min_Ord__Integer (lambda (arg-0 arg-1) (Prelude-EqOrd-case--min-1253 arg-1 arg-0 (Prelude-EqOrd-C-60_Ord__Integer arg-0 arg-1))))
(define Prelude-EqOrd-max_Ord__Integer (lambda (arg-0 arg-1) (Prelude-EqOrd-case--max-1267 arg-1 arg-0 (Prelude-EqOrd-C-62_Ord__Integer arg-0 arg-1))))
(define Prelude-EqOrd-compare_Ord__Integer (lambda (arg-0 arg-1) (Prelude-EqOrd-case--compare-1284 arg-1 arg-0 (Prelude-EqOrd-C-60_Ord__Integer arg-0 arg-1))))
(define Prelude-EqOrd-__Impl_Ord_Integer (lambda () (vector 0 (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-EqOrd-C-61C-61_Eq__Integer arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-EqOrd-C-47C-61_Eq__Integer arg-4 arg-5)))) (lambda (arg-369) (lambda (arg-370) (Prelude-EqOrd-compare_Ord__Integer arg-369 arg-370))) (lambda (arg-371) (lambda (arg-372) (Prelude-EqOrd-C-60_Ord__Integer arg-371 arg-372))) (lambda (arg-373) (lambda (arg-374) (Prelude-EqOrd-C-62_Ord__Integer arg-373 arg-374))) (lambda (arg-375) (lambda (arg-376) (Prelude-EqOrd-C-60C-61_Ord__Integer arg-375 arg-376))) (lambda (arg-377) (lambda (arg-378) (Prelude-EqOrd-C-62C-61_Ord__Integer arg-377 arg-378))) (lambda (arg-379) (lambda (arg-380) (Prelude-EqOrd-max_Ord__Integer arg-379 arg-380))) (lambda (arg-381) (lambda (arg-382) (Prelude-EqOrd-min_Ord__Integer arg-381 arg-382))))))
(define Prelude-EqOrd-__Impl_Eq_Ordering (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-EqOrd-C-61C-61_Eq__Ordering arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-EqOrd-C-47C-61_Eq__Ordering arg-4 arg-5))))))
(define Prelude-EqOrd-__Impl_Eq_Integer (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-EqOrd-C-61C-61_Eq__Integer arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-EqOrd-C-47C-61_Eq__Integer arg-4 arg-5))))))
(define Prelude-EqOrd-C-62_Ord__Integer (lambda (arg-0 arg-1) (let ((sc0 (or (and (> arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-EqOrd-C-62C-61_Ord__Integer (lambda (arg-0 arg-1) (let ((sc0 (or (and (>= arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-EqOrd-C-61C-61_Eq__Ordering (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (cond ((equal? sc0 0) (let ((sc1 arg-1)) (cond ((equal? sc1 0) 0)(else 1)))) ((equal? sc0 1) (let ((sc1 arg-1)) (cond ((equal? sc1 1) 0)(else 1)))) ((equal? sc0 2) (let ((sc1 arg-1)) (cond ((equal? sc1 2) 0)(else 1))))(else 1)))))
(define Prelude-EqOrd-C-61C-61_Eq__Integer (lambda (arg-0 arg-1) (let ((sc0 (or (and (= arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-EqOrd-C-61C-61_Eq__Char (lambda (arg-0 arg-1) (let ((sc0 (or (and (char=? arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-EqOrd-C-60_Ord__Integer (lambda (arg-0 arg-1) (let ((sc0 (or (and (< arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-EqOrd-C-60C-61_Ord__Integer (lambda (arg-0 arg-1) (let ((sc0 (or (and (<= arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define Prelude-EqOrd-C-47C-61_Eq__Ordering (lambda (arg-0 arg-1) (Prelude-Basics-not (Prelude-EqOrd-C-61C-61_Eq__Ordering arg-0 arg-1))))
(define Prelude-EqOrd-C-47C-61_Eq__Integer (lambda (arg-0 arg-1) (Prelude-Basics-not (Prelude-EqOrd-C-61C-61_Eq__Integer arg-0 arg-1))))
(define Prelude-EqOrd-compare (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-2) (lambda (arg-3) ((e-2 arg-2) arg-3)))))))
(define Prelude-EqOrd-C-62 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-4 (vector-ref sc0 4))) (lambda (arg-2) (lambda (arg-3) ((e-4 arg-2) arg-3)))))))
(define Prelude-EqOrd-C-61C-61 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) (lambda (arg-2) (lambda (arg-3) ((e-1 arg-2) arg-3)))))))
(define Prelude-EqOrd-C-60 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-3 (vector-ref sc0 3))) (lambda (arg-2) (lambda (arg-3) ((e-3 arg-2) arg-3)))))))
(define Prelude-Interfaces-C-62C-62C-61 (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-3)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-4) (lambda (arg-5) ((((e-2 'erased) 'erased) arg-4) arg-5)))))))
(define PrimIO-case--unsafePerformIO-442 (lambda (arg-0 arg-1 arg-2 arg-3) (PrimIO-unsafeDestroyWorld 'erased 'erased arg-3)))
(define PrimIO-case--caseC-32blockC-32inC-32io_bind-363 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6 arg-7) (arg-7 arg-6)))
(define PrimIO-case--io_bind-341 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5) (PrimIO-case--caseC-32blockC-32inC-32io_bind-363 'erased 'erased 'erased 'erased 'erased arg-5 'erased (arg-3 arg-5))))
(define PrimIO-unsafePerformIO (lambda (arg-0 arg-1) (PrimIO-unsafeCreateWorld 'erased (lambda (w) (PrimIO-case--unsafePerformIO-442 'erased 'erased 'erased (arg-1 w))))))
(define PrimIO-unsafeDestroyWorld (lambda (arg-0 arg-1 arg-2) arg-2))
(define PrimIO-unsafeCreateWorld (lambda (arg-0 arg-1) (arg-1 #f)))
(define PrimIO-io_pure (lambda (arg-0 arg-1 ext-0) arg-1))
(define PrimIO-io_bind (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (PrimIO-case--io_bind-341 'erased 'erased 'erased arg-3 'erased (arg-2 ext-0))))
(define PrimIO-fromPrim (lambda (arg-0 arg-1) arg-1))
(define Prelude-Show-case--max-5678 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) arg-1) (else arg-0)))))
(define Prelude-Show-case--min-5664 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (cond ((equal? sc0 0) arg-1) (else arg-0)))))
(define Prelude-Show-n--2169-6499-showC-39 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4) (let ((sc0 arg-4)) (case (vector-ref sc0 0) ((0) arg-3) (else (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (let ((sc1 e-3)) (case (vector-ref sc1 0) ((0) (Prelude-Types-Strings-C-43C-43 arg-3 (let ((sc2 arg-1)) (let ((e-1 (vector-ref sc2 1))) (e-1 e-2)))))(else (Prelude-Show-n--2169-6499-showC-39 'erased arg-1 arg-2 (Prelude-Types-Strings-C-43C-43 arg-3 (Prelude-Types-Strings-C-43C-43 (let ((sc1 arg-1)) (let ((e-1 (vector-ref sc1 1))) (e-1 e-2))) ", ")) e-3)))))))))))
(define Prelude-Show-show_Show__Integer (lambda (arg-0) (Prelude-Show-showPrec_Show__Integer (vector 0 ) arg-0)))
(define Prelude-Show-show_Show__C-40ListC-32C-36aC-41 (lambda (arg-0 arg-1 arg-2) (Prelude-Types-Strings-C-43C-43 "[" (Prelude-Types-Strings-C-43C-43 (Prelude-Show-n--2169-6499-showC-39 'erased arg-1 arg-2 "" arg-2) "]"))))
(define Prelude-Show-showPrec_Show__Integer (lambda (ext-0 ext-1) (Prelude-Show-primNumShow 'erased (lambda (eta-0) (number->string eta-0)) ext-0 ext-1)))
(define Prelude-Show-showPrec_Show__C-40ListC-32C-36aC-41 (lambda (arg-0 arg-1 arg-2 arg-3) (Prelude-Show-show_Show__C-40ListC-32C-36aC-41 'erased arg-1 arg-3)))
(define Prelude-Show-min_Ord__Prec (lambda (arg-0 arg-1) (Prelude-Show-case--min-5664 arg-1 arg-0 (Prelude-Show-C-60_Ord__Prec arg-0 arg-1))))
(define Prelude-Show-max_Ord__Prec (lambda (arg-0 arg-1) (Prelude-Show-case--max-5678 arg-1 arg-0 (Prelude-Show-C-62_Ord__Prec arg-0 arg-1))))
(define Prelude-Show-compare_Ord__Prec (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (case (vector-ref sc0 0) ((4) (let ((e-0 (vector-ref sc0 1))) (let ((sc1 arg-1)) (case (vector-ref sc1 0) ((4) (let ((e-1 (vector-ref sc1 1))) (Prelude-Types-compare_Ord__Nat e-0 e-1)))(else (Prelude-EqOrd-compare_Ord__Integer (Prelude-Show-precCon arg-0) (Prelude-Show-precCon arg-1)))))))(else (Prelude-EqOrd-compare_Ord__Integer (Prelude-Show-precCon arg-0) (Prelude-Show-precCon arg-1)))))))
(define Prelude-Show-__Impl_Show_Integer (lambda () (vector 0 (lambda (x) (Prelude-Show-show_Show__Integer x)) (lambda (d) (lambda (x) (Prelude-Show-showPrec_Show__Integer d x))))))
(define Prelude-Show-__Impl_Show_C-40ListC-32C-36aC-41 (lambda (arg-0 arg-1) (vector 0 (lambda (x) (Prelude-Show-show_Show__C-40ListC-32C-36aC-41 'erased arg-1 x)) (lambda (d) (lambda (x) (Prelude-Show-showPrec_Show__C-40ListC-32C-36aC-41 'erased arg-1 d x))))))
(define Prelude-Show-__Impl_Ord_Prec (lambda () (vector 0 (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-Show-C-61C-61_Eq__Prec arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-Show-C-47C-61_Eq__Prec arg-4 arg-5)))) (lambda (arg-369) (lambda (arg-370) (Prelude-Show-compare_Ord__Prec arg-369 arg-370))) (lambda (arg-371) (lambda (arg-372) (Prelude-Show-C-60_Ord__Prec arg-371 arg-372))) (lambda (arg-373) (lambda (arg-374) (Prelude-Show-C-62_Ord__Prec arg-373 arg-374))) (lambda (arg-375) (lambda (arg-376) (Prelude-Show-C-60C-61_Ord__Prec arg-375 arg-376))) (lambda (arg-377) (lambda (arg-378) (Prelude-Show-C-62C-61_Ord__Prec arg-377 arg-378))) (lambda (arg-379) (lambda (arg-380) (Prelude-Show-max_Ord__Prec arg-379 arg-380))) (lambda (arg-381) (lambda (arg-382) (Prelude-Show-min_Ord__Prec arg-381 arg-382))))))
(define Prelude-Show-__Impl_Eq_Prec (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (Prelude-Show-C-61C-61_Eq__Prec arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (Prelude-Show-C-47C-61_Eq__Prec arg-4 arg-5))))))
(define Prelude-Show-C-62_Ord__Prec (lambda (arg-0 arg-1) (Prelude-EqOrd-C-61C-61_Eq__Ordering (Prelude-Show-compare_Ord__Prec arg-0 arg-1) 2)))
(define Prelude-Show-C-62C-61_Ord__Prec (lambda (arg-0 arg-1) (Prelude-EqOrd-C-47C-61_Eq__Ordering (Prelude-Show-compare_Ord__Prec arg-0 arg-1) 0)))
(define Prelude-Show-C-61C-61_Eq__Prec (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (case (vector-ref sc0 0) ((4) (let ((e-0 (vector-ref sc0 1))) (let ((sc1 arg-1)) (case (vector-ref sc1 0) ((4) (let ((e-1 (vector-ref sc1 1))) (Prelude-Types-C-61C-61_Eq__Nat e-0 e-1)))(else (Prelude-EqOrd-C-61C-61_Eq__Integer (Prelude-Show-precCon arg-0) (Prelude-Show-precCon arg-1)))))))(else (Prelude-EqOrd-C-61C-61_Eq__Integer (Prelude-Show-precCon arg-0) (Prelude-Show-precCon arg-1)))))))
(define Prelude-Show-C-60_Ord__Prec (lambda (arg-0 arg-1) (Prelude-EqOrd-C-61C-61_Eq__Ordering (Prelude-Show-compare_Ord__Prec arg-0 arg-1) 0)))
(define Prelude-Show-C-60C-61_Ord__Prec (lambda (arg-0 arg-1) (Prelude-EqOrd-C-47C-61_Eq__Ordering (Prelude-Show-compare_Ord__Prec arg-0 arg-1) 2)))
(define Prelude-Show-C-47C-61_Eq__Prec (lambda (arg-0 arg-1) (Prelude-Basics-not (Prelude-Show-C-61C-61_Eq__Prec arg-0 arg-1))))
(define Prelude-Show-showPrec (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-2) (lambda (arg-3) ((e-2 arg-2) arg-3)))))))
(define Prelude-Show-showParens (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (cond ((equal? sc0 1) arg-1) (else (Prelude-Types-Strings-C-43C-43 "(" (Prelude-Types-Strings-C-43C-43 arg-1 ")")))))))
(define Prelude-Show-show (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) (lambda (arg-2) (e-1 arg-2))))))
(define Prelude-Show-primNumShow (lambda (arg-0 arg-1 arg-2 arg-3) (let ((str (arg-1 arg-3))) (Prelude-Show-showParens (Prelude-Basics-C-38C-38 (Prelude-Show-C-62C-61_Ord__Prec arg-2 (vector 5 )) (lambda () (Prelude-Show-firstCharIs (lambda (arg-4) (Prelude-EqOrd-C-61C-61_Eq__Char arg-4 #\-)) str))) str))))
(define Prelude-Show-precCon (lambda (arg-0) (let ((sc0 arg-0)) (case (vector-ref sc0 0) ((0) 0) ((1) 1) ((2) 2) ((3) 3) ((4) 4) ((5) 5) (else 6)))))
(define Prelude-Show-firstCharIs (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (cond ((equal? sc0 "") 1)(else (arg-0 (string-ref arg-1 0)))))))
(define Prelude-IO-pure_Applicative__IO (lambda (arg-0 arg-1 ext-0) arg-1))
(define Prelude-IO-map_Functor__IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-3 (arg-3 ext-0))) (arg-2 act-3))))
(define Prelude-IO-liftIO_HasIO__IO (lambda (arg-0 arg-1) arg-1))
(define Prelude-IO-join_Monad__IO (lambda (arg-0 arg-1 ext-0) (let ((act-2 (arg-1 ext-0))) (act-2 ext-0))))
(define Prelude-IO-__Impl_Monad_IO (lambda () (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (Prelude-IO-map_Functor__IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-29 (arg-647 eta-0))) (act-29 eta-0))))))))
(define Prelude-IO-__Impl_HasIO_IO (lambda () (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (Prelude-IO-map_Functor__IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-6794) arg-6794)))))
(define Prelude-IO-__Impl_Functor_IO (lambda (ext-4 ext-1 ext-2 ext-3 ext-0) (Prelude-IO-map_Functor__IO 'erased 'erased ext-2 ext-3 ext-0)))
(define Prelude-IO-__Impl_Applicative_IO (lambda () (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (Prelude-IO-map_Functor__IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16)))))))))))
(define Prelude-IO-C-62C-62C-61_Monad__IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-1 (arg-2 ext-0))) ((arg-3 act-1) ext-0))))
(define Prelude-IO-C-60C-42C-62_Applicative__IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-6 (arg-2 ext-0))) (let ((act-5 (arg-3 ext-0))) (act-6 act-5)))))
(define Prelude-IO-putStrLn (lambda (arg-0 arg-1 arg-2) (Prelude-IO-putStr 'erased arg-1 (string-append arg-2 "\xa;"))))
(define Prelude-IO-putStr (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) (lambda (eta-0) (Prelude-IO-prim__putStr arg-2 eta-0)))))))
(define Prelude-IO-primIO (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) arg-3)))))
(define Prelude-IO-liftIO (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-3) ((e-2 'erased) arg-3))))))
(load-shared-object "libidris2_support.so")
(collect-request-handler (lambda () (collect) (blodwen-run-finalisers)))
(PrimIO-unsafePerformIO 'erased (Main-main))(collect 4)
(blodwen-run-finalisers))