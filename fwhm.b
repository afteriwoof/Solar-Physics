mu=moment(y, sdev=sdev)
f=2*sqrt(2*alog(2))*sdev
y1=y[0:where(y eq max(y))]
x1=indgen(n_elements(y1))
y2=y[where(y eq max(y)):*]
x2=indgen(n_elements(y2))
i1=interpol(x1,y1,f)
i2=interpol(x2,y2,f)
help,  f, i1, i2
print, where(y eq max(y))
print, where(y eq max(y))-i1
