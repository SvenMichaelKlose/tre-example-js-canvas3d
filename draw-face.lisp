(fn draw-face (ctx face texture)
  (ctx.save)
  (ctx.begin-path)
  (alet (car (face-vertices face))
    (ctx.move-to (vertex-px !) (vertex-py !)))
  (@ (i (cdr (face-vertices face)))
    (ctx.line-to (vertex-px i) (vertex-py i)))
  (ctx.close-path)
  (ctx.clip)
  (with (v  (face-vertices face)
         x0 (vertex-px v.)
         y0 (vertex-py v.)
         x1 (vertex-px .v.)
         y1 (vertex-py .v.)
         x2 (vertex-px ..v.)
         y2 (vertex-py ..v.)
         u0 1280
         u1 0
         u2 0
         v0 0
         v1 0
         v2 768
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
