(defclass object3d (vertices_ faces_)
  (= vertices vertices_
     faces (ensure-list faces_))
  this)

(defmember object3d
  x y z
  vertices
  faces)

(finalize-class object3d)

(fn make-object3d-from-vertices-and-faces (vertices faces renderer)
  (with (v      (@ [new vertex _. ._. .._.] vertices)
         v-map  (list-array v)
         f      (@ [make-face :vertices (filter [aref v-map (-- _)] _)
                              :renderer renderer]
                   faces))
    (new object3d v f)))

(fn render-object3d (obj ax ay az cx cy cz)
  (@ (i obj.vertices)
    (= i.x i.ox)
    (= i.y i.oy)
    (= i.z i.oz))
  (@ (i obj.vertices)
    (i.rotate ax ay az)
    (= i.x (number+ i.x cx))
    (= i.y (number+ i.y cy))
    (= i.z (number+ i.z cz))
    (i.project))
  (@ (i (reverse (sort-faces obj.faces)))
    (& (face? i)
       (funcall i.renderer i))))
