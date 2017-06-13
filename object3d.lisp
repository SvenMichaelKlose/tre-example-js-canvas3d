(defstruct object3d
  x y z
  vertices
  faces)

(fn make-object3d-from-vertices-and-faces (vertices faces)
  (with (v      (@ [make-vertex :ox _. :oy ._. :oz .._.] vertices)
         v-map  (list-array v)
         f      (@ [make-face :vertices (filter [aref v-map (-- _)] _)
                              :renderer #'draw-face]
                   faces))
    (make-object3d :vertices v :faces f)))

(fn render-object3d (obj ax ay az cx cy cz)
  (with-object3d obj
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
    (@ (i (reverse (sort-faces faces)))
      (& (face? i)
         (funcall (face-renderer i) *ctx* i *texture*)))))
