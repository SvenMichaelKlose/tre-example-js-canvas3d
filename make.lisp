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
;(= (transpiler-backtrace? *js-transpiler*) t)
;(= (transpiler-cps-transformation? *js-transpiler*) t)
;(= (transpiler-inject-debugging? *js-transpiler*) t)
;(= (transpiler-dump-passes? *js-transpiler*) t)

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
                                   "unicode.lisp"
                                   "log.lisp"))
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
                                   "viewport.lisp"
                                   "disable-scrollbars.lisp"))
                          (list+ "js/event/"
                                 '("native.lisp"
                                   "keycodes.lisp")))))
         (list+ "caroshi/"
	            `("base/dom/objects/video.lisp"
	              "base/dom/objects/canvas.lisp"
	              "base/tk/preload-images.lisp"
	              "base/tk/widgets/progress.lisp"
	              "base/tk/widgets/progressmeter.lisp"
	              "base/tk/widgets/image-loader.lisp"
	              "base/init/predefined-symbols.lisp"
	              "base/init/application.lisp"
	              "base/init/onload.lisp"))

         '("box.lisp"
           "caroshi/base/db/btree.lisp"
           "toplevel.lisp"
           "test.lisp"))
         :transpiler  *js-transpiler*
         :emitter     [make-html-script "compiled/index.html" _]))

(make-site)
(quit)
