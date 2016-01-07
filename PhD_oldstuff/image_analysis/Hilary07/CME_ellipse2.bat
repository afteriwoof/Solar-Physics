;pro CME_ellipse2

fls = file_search('~/PhD/Data_from_James/21apr2002/*.fts')
mreadfits, fls, in, da

c2da = where(in.detector eq 'C2')
c3da = where(in.detector eq 'C3')

mreadfits, fls(c2da), inc2, c2da
mreadfits, fls(c3da), inc3, c3da

sz_c2da = size(c2da, /dim)
sz_c3da = size(c3da, /dim)

for i=0,sz_c2da[2]-1 do begin & $
	c2da[*,*,i] = rm_inner(c2da[*,*,i], inc2[i], dr_px, thr=2.3, plot=plot, fill=MEDIAN(c2da[*,*,i])) & $
endfor 

c2danew = c2da^0.3



