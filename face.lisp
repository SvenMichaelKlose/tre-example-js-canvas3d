(defclass face (_vertices _renderer)
  (= vertices _vertices
     renderer _renderer)
  this)

(defmember face
  vertices
  renderer)

(defmethod face average-z ()
  (/ (apply #'number+ (@ [identity _.z] vertices)) (length vertices)))

(finalize-class face)

(fn sort-faces (faces)
  (let r (new bnode 0 "" nil)
    (@ (i faces)
      (r.add (i.average-z) i))
    (with-queue q
      (let x (r.get-first)
        (while (= x (x.next))
               (queue-list q)
          (enqueue q x.value))))))
