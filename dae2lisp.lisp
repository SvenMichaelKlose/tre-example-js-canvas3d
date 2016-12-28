;;;;; DAE to Lisp converter – Copyright (c) 2013 Sven Michael Klose <pixel@copei.de>

(defun dae2lisp (in)
  (xml2lml in))

(with-open-file in (open "junicube.dae" :direction 'input)
  (print (dae2lisp in)))
