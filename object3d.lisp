(defclass object3d (vertices_ faces_)
  (= vertices vertices_
     faces (ensure-list faces_))
  (= x 0
     y 0
     z 0
     rx 0
     ry 0
     rz 0)
  this)

(defmember object3d
  x y z
  rx ry rz
  vertices
  faces)

(defmethod object3d render ()
  (@ (i vertices)
    (= i.x i.ox)
    (= i.y i.oy)
    (= i.z i.oz))
  (@ (i vertices)
    (i.rotate rx ry rz)
    (= i.x (number+ i.x x))
    (= i.y (number+ i.y y))
    (= i.z (number+ i.z z))
    (i.project))
  (@ (i (reverse (sort-faces faces)))
    (& (face? i)
       (funcall i.renderer i))))

(finalize-class object3d)

(fn make-object3d-from-vertices-and-faces (vertices faces renderer)
  (with (v      (@ [new vertex _. ._. .._.] vertices)
         v-map  (list-array v)
         f      (@ [make-face :vertices (filter [aref v-map (-- _)] _)
                              :renderer renderer]
                   faces))
    (new object3d v f)))
