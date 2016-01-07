PRO draw_arrow

;Restore image data

restore, 'diff8.sav'

;Get the dimensions of the image file.

s=size(diff8, /dimensions)

;Prepare display device and display image.

device, decomposed=0
window, 0, xs=512, ys=512, title="Point of Interest"
tv, diff8 

;Draw the arrow.
arrow, 40, 20, 165, 115

END
