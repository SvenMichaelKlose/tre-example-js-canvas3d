(load "conf-shared.lisp")
(load "conf-compile-time.lisp")
(load "tre_modules/js/event/names.lisp")

(var *application-name* "Software-rendered 3D test")
(= (transpiler-funinfo-comments? *js-transpiler*) nil)

(defun make-site ()
  (unix-sh-mkdir "compiled" :parents t)
  (make-project
      "Software 3D"
      (+ `("conf-shared.lisp")

         (list+ "tre_modules/"
                (+ (list+ "shared/"
	                      `("continued.lisp"
                            "btree.lisp"))
                   (list+ "js/"
                          `("milliseconds-since-1970.lisp"
                            "wait.lisp"
                            "unicode.lisp"))
                   (list+ "js/dom/"
                          '("add-onload.lisp"
                            "def-aos.lisp"
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
                            "keycodes.lisp"))
                   (list+ "timetable/"
                          '("timetable.lisp"
                            "timetable-player.lisp"
                            "timetable-utils.lisp"))))
         '("track-slots.lisp"
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
