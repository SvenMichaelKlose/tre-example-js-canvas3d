;;;;; Caroshi – Copyright (c) 2008–2014,2016 Sven Michael Klose <pixel@copei.de>

(load "caroshi/conf/shared.lisp")
(load "caroshi/conf/compile-time.lisp")
(load "environment/platforms/shared/html/doctypes.lisp")
(load "environment/platforms/shared/html/script.lisp")
(load "environment/platforms/shared/lml.lisp")
(load "environment/platforms/shared/lml2xml.lisp")
(load "environment/platforms/js/event/names.lisp")

(= *application-name* "Software-rendered 3D test")
(= (transpiler-funinfo-comments? *js-transpiler*) nil)

(defun make-site ()
  (unix-sh-mkdir "compiled" :parents t)
  (make-project
      "Software 3D"
      (+ (list+ "caroshi/"
                `("conf/shared.lisp"
	              "conf/run-time.lisp"))

         (list+ "environment/"
                (list+ "platforms/"
                       (+ (list+ "shared/"
	                             `("continued.lisp"))
                          (list+ "shared/url/"
                                 `("path-pathlist.lisp"
                                   "path-parent.lisp"
                                   "path-suffix.lisp"
                                   "pathname-filename.lisp"
                                   "url-path.lisp"
                                   "path-append.lisp"))
                          (list+ "js/"
                                 `("milliseconds-since-1970.lisp"
                                   "wait.lisp"
                                   "unicode.lisp"))
                          (list+ "js/dom/"
                                 '("def-aos.lisp"
                                   "do.lisp"
                                   "clone-element-array.lisp"
                                   "objects/native-symbols.lisp"
                                   "objects/node-predicates.lisp"
                                   "objects/visible-node.lisp"
                                   "objects/text-node.lisp"
                                   "objects/element.lisp"
                                   "objects/document.lisp"
                                   "objects/extend.lisp"
                                   "objects/video.lisp"
                                   "objects/canvas.lisp"
                                   "viewport.lisp"
                                   "disable-scrollbars.lisp"))
                          (list+ "js/event/"
                                 '("native.lisp"
                                   "keycodes.lisp")))))
         '("caroshi/lib/add-onload.lisp")

         '("caroshi/lib/db/btree.lisp"
           "canvas.lisp"
           "vertex.lisp"
           "face.lisp"
           "draw-face.lisp"
           "object3d.lisp"
           "toplevel.lisp"))
         :transpiler  *js-transpiler*
         :emitter     [make-html-script "compiled/index.html" _]))

(make-site)
(quit)
