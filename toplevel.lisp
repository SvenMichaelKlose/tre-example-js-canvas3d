;;;;; Software–rendered 3D canvas – Copyright (c) 2013 Sven Michael Klose <pixel@copei.de>

(defstruct vertex
  ox oy oz
  x y z
  px py)

(defstruct face
  vertices
  average-z
  renderer)

(defmacro define-vertex-rotation (axis)
  (with (others  (remove axis '(x y z))
         n       others.
         m       .others.)
    `(def-vertex ,($ 'vertex-rotate- axis) (vertex angle)
       (with (rad  (deg-rad angle)
              t1   (- (* ,n (cos rad)) (* ,m (sin rad)))
              t2   (+ (* ,n (sin rad)) (* ,m (cos rad))))
         (= (,($ 'vertex- axis) vertex) ,axis)
         (= (,($ 'vertex- n) vertex) t1)
         (= (,($ 'vertex- m) vertex) t2)))))

(define-vertex-rotation x)
(define-vertex-rotation y)
(define-vertex-rotation z)

(defvar *canvas* nil)
(defvar *ctx*)
(defvar *texture*)

(defun face-projections (face)
  (apply #'append (@ [list (vertex-px _) (vertex-py _)] (face-vertices face))))

(defun draw-polygon (face)
  (*ctx*.save)
  (*ctx*.begin-path)
  (alet (car (face-vertices face))
    (*ctx*.move-to (vertex-px !) (vertex-py !)))
  (@ (i (cdr (face-vertices face)))
    (*ctx*.line-to (vertex-px i) (vertex-py i)))
  (*ctx*.close-path)
  (*ctx*.clip)
  (with (v  (face-vertices face)
         x0 (vertex-px v.)
         y0 (vertex-py v.)
         x1 (vertex-px .v.)
         y1 (vertex-py .v.)
         x2 (vertex-px ..v.)
         y2 (vertex-py ..v.)
         u0 1280
         u1 0
         u2 0
         v0 0
         v1 0
         v2 768
         delta   (- (number+ (* u0 v1) (* v0 u2) (* u1 v2)) (* v1 u2) (* v0 u1) (* u0 v2))
         delta-a (- (number+ (* x1 v1) (* v0 x2) (* x1 v2)) (* v1 x2) (* v0 x1) (* x0 v2))
         delta-b (- (number+ (* u0 x1) (* x0 u2) (* u1 x2)) (* x1 u2) (* x0 u1) (* u0 x2))
         delta-c (- (number+ (* u0 v1 x2) (* v0 x1 u2) (* x0 u1 v2)) (* x0 v1 u2) (* v0 u1 x2) (* u0 x1 v2))
         delta-d (- (number+ (* y0 v1) (* v0 y2) (* y1 v2)) (* v1 y2) (* v0 y1) (* y0 v2))
         delta-e (- (number+ (* u0 y1) (* y0 u2) (* u1 y2)) (* y1 u2) (* y0 u1) (* u0 y2))
         delta-f (- (number+ (* u0 v1 y2) (* v0 y1 u2) (* y0 u1 v2)) (* y0 v1 u2) (* v0 u1 y2) (* u0 y1 v2)))
    (*ctx*.set-transform (/ delta-a delta) (/ delta-d delta) (/ delta-b delta) (/ delta-e delta) (/ delta-c delta) (/ delta-f delta))
    (*ctx*.draw-image *texture* 0 0)
    (*ctx*.restore)))

(defun scale (fac x y z)
  (list (* x fac) (* y fac) (* z fac)))

(defvar *width*)
(defvar *height*)

(def-vertex vertex-project (vertex)
  (= (vertex-px vertex) (number+ (half *width*)  (* *width* (/ x z)))
     (vertex-py vertex) (number+ (half *height*) (* *width* (/ y z)))))

(defun clear-canvas ()
  (with ((x y w h) (get-viewport))
    (alet *ctx*
      (= !.fill-style "#000")
      (!.fill-rect 0 0 w h))))

(defvar *x* 0)
(defvar *y* 0)
(defvar *z* 180)

(defun avgz (!)
  (/ (number+ (third !.) (third .!.) (third ..!.) (third ...!.)) 4))

(defun smoothen-edges (ctx)
  (ctx.translate 0.5 0.5))

(defun update-canvas ()
  (with ((x y w h) (get-viewport))
    (unless (& (== w *width*)
               (== h *height*))
      (= *width* w)
      (= *height* h)
      (awhen *canvas*
        (!.remove))
      (= *canvas* (new *element "canvas" (new :width w :height h)))
      (document.body.add *canvas*)
      (= *ctx* (*canvas*.get-context "2d"))
      (smoothen-edges *ctx*)
      (= *ctx*.image-smoothing-enabled nil)
      (= *ctx*.moz-image-smoothing-enabled nil))))

(defun vertex-rotate (v x y z)
  (vertex-rotate-x v x)
  (vertex-rotate-y v y)
  (vertex-rotate-z v z))

(defun zsort (faces)
  (return faces)
  (let r (new bnode 0 "" nil)   ; TODO: Fix sorting.
    (@ (i faces)
      (r.add (face-average-z i) i))
    (with-queue q
      (let x (r.get-first)
        (while (= x (x.next))
               (queue-list q)
          (enqueue q x.value))))))

(defun render-scene (vertices faces ax ay az cx cy cz)
  (@ (i vertices)
    (= (vertex-x i) (vertex-ox i))
    (= (vertex-y i) (vertex-oy i))
    (= (vertex-z i) (vertex-oz i)))
  (@ (i vertices)
    (vertex-rotate i ax ay az)
    (+! (vertex-x i) cx)
    (+! (vertex-y i) cy)
    (+! (vertex-z i) cz)
    (vertex-project i))
  (@ (i faces)
    (= (face-average-z i) (/ (apply #'number+ (@ #'vertex-z (face-vertices i))) 3)))
  (@ (i (reverse (zsort faces)))
    (& (face? i)
       (funcall (face-renderer i) i))))

(defun make-3d-object (vertices faces)
  (with (v      (@ [make-vertex :ox _. :oy ._. :oz .._.] vertices)
         v-map  (list-array v)
         f      (@ [make-face :vertices (filter [aref v-map (-- _)] _)
                              :renderer #'draw-polygon]
                   faces))
    (values v f)))
