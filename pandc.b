read, 'How many points?', count
xf=dblarr(count) & $
yf=dblarr(count) & $
for temp=0,count-1 do begin & $
cursor, x, y, /data, /down & $
xf[temp] = x & $
yf[temp] = y & $
plots, xf, yf, psym=1 & $
print, temp & $
endfor
