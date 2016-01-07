@rundiff.b

rimg8=roberts(img8)
simg8=sobel(img8)

rimg9=roberts(img9)
simg9=sobel(img9)

rdiff8=rimg9-rimg8

sdiff8=simg9-simg8

!p.multi=[0,3,1]

window, /free, title='Roberts: rimg8, rimg9, rdiff8'
plot_image, rimg8
plot_image, rimg9
plot_image, rdiff8

window, /free, title='Sobel: simg8, simg9, sdiff8'
plot_image, simg8
plot_image, simg9
plot_image, sdiff8

rimg8_scl=roberts(img8_scl)
rimg9_scl=roberts(img9_scl)
rdiff8_scl=rimg9_scl-rimg8_scl

simg8_scl=sobel(img8_scl)
simg9_scl=sobel(img9_scl)
sdiff8_scl=simg9_scl-simg8_scl

window, /free, title='Roberts: rimg8_scl, rimg9_scl, rdiff8_scl'

plot_image, rimg8_scl
plot_image, rimg9_scl
plot_image, rdiff8_scl

window, /free, title='Sobel: simg8_scl, simg9_scl, sdiff8_scl'

plot_image, simg8_scl
plot_image, simg9_scl
plot_image, sdiff8_scl

