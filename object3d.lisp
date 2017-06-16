(defstruct object3d
  x y z
  vertices
  faces)

(fn make-object3d-from-vertices-and-faces (vertices faces renderer)
  (with (v      (@ [new vertex _. ._. .._.] vertices)
         v-map  (list-array v)
         f      (@ [make-face :vertices (filter [aref v-map (-- _)] _)
                              :renderer renderer]
                   faces))
    (make-object3d :vertices v :faces f)))

(fn render-object3d (obj ax ay az cx cy cz)
  (with-object3d obj
    (@ (i vertices)
      (= i.x i.ox)
      (= i.y i.oy)
      (= i.z i.oz))
    (@ (i vertices)
      (i.rotate ax ay az)
      (= i.x (number+ i.x cx))
      (= i.y (number+ i.y cy))
      (= i.z (number+ i.z cz))
      (i.project))
    (@ (i faces)
      (= (face-average-z i) (/ (apply #'number+ (@ [identity _.z] (face-vertices i))) (length (face-vertices i)))))
    (@ (i (reverse (sort-faces faces)))
      (& (face? i)
         (funcall (face-renderer i) i)))))
