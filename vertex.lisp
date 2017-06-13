(defstruct vertex
  ox oy oz      ; Original coordinates
  x y z         ; Rotated/translated coordinates
  px py)        ; Projected coordinates

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

(fn vertex-rotate (v x y z)
  (vertex-rotate-x v x)
  (vertex-rotate-y v y)
  (vertex-rotate-z v z))

(def-vertex vertex-project (vertex)
  (= (vertex-px vertex) (number+ (half *width*)  (* *width* (/ x z)))
     (vertex-py vertex) (number+ (half *height*) (* *width* (/ y z)))))
