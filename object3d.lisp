(defstruct object3d
  x y z
  vertices
  faces)

(fn make-object3d-from-vertices-and-faces (vertices faces renderer)
  (with (v      (@ [make-vertex :ox _. :oy ._. :oz .._.] vertices)
         v-map  (list-array v)
         f      (@ [make-face :vertices (filter [aref v-map (-- _)] _)
                              :renderer renderer]
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
      (= (vertex-x i) (number+ (vertex-x i) cx))
      (= (vertex-y i) (number+ (vertex-y i) cy))
      (= (vertex-z i) (number+ (vertex-z i) cz))
      (vertex-project i))
    (@ (i faces)
      (= (face-average-z i) (/ (apply #'number+ (@ #'vertex-z (face-vertices i))) (length (face-vertices i)))))
    (@ (i (reverse (sort-faces faces)))
      (& (face? i)
         (funcall (face-renderer i) i)))))
