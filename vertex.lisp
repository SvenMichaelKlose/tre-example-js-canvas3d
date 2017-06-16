(defclass vertex (_x _y _z)
  (= ox _x
     oy _y
     oz _z)
  this)

(defmember vertex
  ox oy oz      ; Original coordinates
  x y z         ; Rotated/translated coordinates
  px py)        ; Projected coordinates

(defmacro define-vertex-rotation (axis)
  (with (others  (remove axis '(x y z))
         n       others.
         m       .others.)
    `(defmethod vertex ,($ 'rotate- axis) (angle)
       (with (rad (deg-rad angle)
              on  ,n
              om  ,m)
         (= ,n (- (* on (cos rad)) (* om (sin rad))))
         (= ,m (+ (* on (sin rad)) (* om (cos rad))))))))

(define-vertex-rotation x)
(define-vertex-rotation y)
(define-vertex-rotation z)

(defmethod vertex rotate (_x _y _z)
  (rotate-x _x)
  (rotate-y _y)
  (rotate-z _z))

(defmethod vertex project ()
  (= px (number+ (half *width*)  (* *width* (/ x z)))
     py (number+ (half *height*) (* *width* (/ y z)))))

(finalize-class vertex)
