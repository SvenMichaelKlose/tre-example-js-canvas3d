(var *canvas* nil)
(var *ctx*)
(var *texture*)
(var *width*)
(var *height*)

(fn clear-canvas ()
  (with ((x y w h) (get-viewport))
    (alet *ctx*
      (= !.fill-style "#000")
      (!.fill-rect 0 0 w h))))

(fn smoothen-edges (ctx)
  (ctx.translate 0.5 0.5))

(fn update-canvas ()
  (with ((x y w h) (get-viewport))
    (unless (& (== w *width*)
               (== h *height*))
      (= *width* w)
      (= *height* h)
      (awhen *canvas*
        (!.remove))
      (= *canvas* (new *element "canvas" (new :width w :height h)))
      (document.body.add *canvas*)
      (= *ctx* (*canvas*.get-context "2d"))
      (? t
         (smoothen-edges *ctx*)
         (progn
           (= *ctx*.image-smoothing-enabled nil)
           (= *ctx*.moz-image-smoothing-enabled nil))))))
