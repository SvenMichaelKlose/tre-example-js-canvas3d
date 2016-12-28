;;;;; Software–rendered 3D canvas – Copyright (c) 2013 Sven Michael Klose <pixel@copei.de>

(defun whirl (vertices faces)
  (do-wait 10
    (update-canvas)
    (clear-canvas)
    (render-scene vertices faces *x* *y* *z* 0 0 80)
    (++! *x*)
    (++! *y*)
    (++! *z*)
    (whirl vertices faces)))

(defun junicube ()
  (document-extend)
  (disable-scrollbars)
  (with ((vertices faces) (make-3d-object *vertices* *faces*))
    (= *texture* (make-video :width 640 :height 480 :webm "video.webm" :loop? t :autoplay? t))
    (document.body.add *texture*)
    (*texture*.hide)
    (= *texture*.muted t)
    (native-add-event-listener *texture* "play" #'(() (whirl vertices faces)))))

(application.add-component #'junicube)
