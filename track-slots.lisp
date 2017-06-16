(defclass track-slots (obj params params-start params-end)
  (= _obj obj)
  (= _params params)
  (= _params-start params-start)
  (= _params-end params-end)
  this)

(defmember track-slots
    _obj
    _params)

(defmethod track-slots set (p)
  (mapcar #'((name start end)
               (= (aref _obj name) (percent (- end start) p)))
          _params
          _params-start
          _params-end))

(finalize-class track-slots)
