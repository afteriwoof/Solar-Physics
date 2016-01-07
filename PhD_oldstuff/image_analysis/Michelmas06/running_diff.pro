PRO running_diff

files=findfile('18-apr-2000/*.fits')

mreadfits, files, index, data


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

print, 'Read in image files(img1-14) and made running-differences(diff1-13)'

END
