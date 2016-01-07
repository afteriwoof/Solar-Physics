dab_rm=fltarr(1024,1024,67)
for i=0,66 do begin & $
mask = get_smask(inb[i]) & $
dab_rm[*,*,i] = mask*dab[*,*,i] & $
ind=where(dab_rm[*,*,i] eq 0) & $
temp=dab_rm[*,*,i] & $
temp[ind]=min(dab[*,*,i]) & $
dab_rm[*,*,i]=temp & $
endfor

