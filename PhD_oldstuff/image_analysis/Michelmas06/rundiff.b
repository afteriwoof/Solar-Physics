print, 'Read in image files(img1-14) and made running-differences(diff1-13)'

files=file_search('18-apr-2000/*.fits')

mreadfits, files, index, data

loadct, 3

img1=data(*,*,1)
img2=data(*,*,2)
img3=data(*,*,3)
img4=data(*,*,4)
img5=data(*,*,5)
img6=data(*,*,6)
img7=data(*,*,7)
img8=data(*,*,8)
img9=data(*,*,9)
img10=data(*,*,10)
img11=data(*,*,11)
img12=data(*,*,12)
img13=data(*,*,13)
img14=data(*,*,14)

diff1=img2-img1
diff2=img3-img2
diff3=img4-img3
diff4=img5-img4
diff5=img6-img5
diff6=img7-img6
diff7=img8-img7
diff8=img9-img8
diff9=img10-img9
diff10=img11-img10
diff11=img12-img11
diff12=img13-img12
diff13=img14-img13

sigdiff1 = sigrange(diff1)
sigdiff2 = sigrange(diff2)
sigdiff3 = sigrange(diff3)
sigdiff4 = sigrange(diff4)
sigdiff5 = sigrange(diff5)
sigdiff6 = sigrange(diff6)
sigdiff7 = sigrange(diff7)
sigdiff8 = sigrange(diff8)
sigdiff9 = sigrange(diff9)
sigdiff10 = sigrange(diff10)
sigdiff11 = sigrange(diff11)
sigdiff12 = sigrange(diff12)
sigdiff13 = sigrange(diff13)

a=make_array(1024,1024,14)
for i=0,13 do begin $
a(*,*,i)=sigrange(data(*,*,i+1)-data(*,*,i))

sa=make_array(1024,1024,14)
for i=0,13 do begin $
sa(*,*,i)=smooth(a(*,*,i), 5, /ed)

window, /free
plot_image, sa(*,*,0)
contour, sa(*,*,0), level=15, /over

window, /free
plot_image, sa(*,*,1)
contour, sa(*,*,1), level=30, /over

window, /free
plot_image, sa(*,*,2)
contour, sa(*,*,2), level=25, /over

window, /free
plot_image, sa(*,*,3)
contour, sa(*,*,3), level=200, /over

window, /free
plot_image, sa(*,*,4)
contour, sa(*,*,4), level=-50, /over

window, /free
plot_image, sa(*,*,5)
contour, sa(*,*,5), level=30, /over

window, /free
plot_image, sa(*,*,6)
contour, sa(*,*,6), level=40, /over

window, /free
plot_image, sa(*,*,7)
contour, sa(*,*,7), level=40, /over

window, /free
plot_image, sa(*,*,8)
contour, sa(*,*,8), level=175, /over

window, /free
plot_image, sa(*,*,9)
contour, sa(*,*,9), level=1, /over

window, /free
plot_image, sa(*,*,10)
contour, sa(*,*,10), level=80, /over

window, /free
plot_image, sa(*,*,11)
contour, sa(*,*,11), level=85, /over

window, /free
plot_image, sa(*,*,12)
contour, sa(*,*,12), level=20, /over

window, /free
plot_image, sa(*,*,13)
contour, sa(*,*,13), level=50, /over

