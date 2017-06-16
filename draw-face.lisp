(fn make-face-path (ctx face)
  (ctx.begin-path)
  (let v face.vertices
    (!= v.
      (ctx.move-to !.px !.py))
    (@ (i .v)
      (ctx.line-to i.px i.py)))
  (ctx.close-path))

(fn draw-face-image (ctx face texture)
  (ctx.save)
  (make-face-path ctx face)
  (ctx.clip)
  (with (v  (face.vertices)
         x0 (car px)
         y0 (car py)
         x1 (cadr px)
         y1 (cadr py)
         x2 (caddr px)
         y2 (caddr py)
         u0 1280    ; TODO: Oops. Calculate this!
         u1 0
         u2 0
         v0 0
         v1 0
         v2 768     ; TODO: Oops. Calculate this!
         delta   (- (number+ (* u0 v1) (* v0 u2) (* u1 v2)) (* v1 u2) (* v0 u1) (* u0 v2))
         delta-a (- (number+ (* x1 v1) (* v0 x2) (* x1 v2)) (* v1 x2) (* v0 x1) (* x0 v2))
         delta-b (- (number+ (* u0 x1) (* x0 u2) (* u1 x2)) (* x1 u2) (* x0 u1) (* u0 x2))
         delta-c (- (number+ (* u0 v1 x2) (* v0 x1 u2) (* x0 u1 v2)) (* x0 v1 u2) (* v0 u1 x2) (* u0 x1 v2))
         delta-d (- (number+ (* y0 v1) (* v0 y2) (* y1 v2)) (* v1 y2) (* v0 y1) (* y0 v2))
         delta-e (- (number+ (* u0 y1) (* y0 u2) (* u1 y2)) (* y1 u2) (* y0 u1) (* u0 y2))
         delta-f (- (number+ (* u0 v1 y2) (* v0 y1 u2) (* y0 u1 v2)) (* y0 v1 u2) (* v0 u1 y2) (* u0 y1 v2)))
    (ctx.set-transform (/ delta-a delta) (/ delta-d delta) (/ delta-b delta) (/ delta-e delta) (/ delta-c delta) (/ delta-f delta))
    (ctx.draw-image texture 0 0)
    (ctx.restore)))

(fn draw-face-filled (ctx face color)
  (ctx.save)
  (make-face-path ctx face)
  (= ctx.fill-style color)
  (ctx.fill)
  (ctx.restore))
