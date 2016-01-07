pro circle, xcenter, ycenter, radius
   
points = (2 * !PI / 99.0) * FINDGEN(100)

x = xcenter + radius * COS(points )

y = ycenter + radius * SIN(points )

;plot, x, y

END
