(defstruct face
  vertices
  average-z
  renderer)

(fn face-projections (face)
  (apply #'append (@ [list (vertex-px _) (vertex-py _)] (face-vertices face))))

(fn avgz (!)
  (/ (number+ (third !.) (third .!.) (third ..!.) (third ...!.)) 4))

(fn sort-faces (faces)
  (let r (new bnode 0 "" nil)
    (@ (i faces)
      (r.add (face-average-z i) i))
    (with-queue q
      (let x (r.get-first)
        (while (= x (x.next))
               (queue-list q)
          (enqueue q x.value))))))
