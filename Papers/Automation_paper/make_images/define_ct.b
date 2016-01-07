restore, 'plots_201003120506__C2.sav'
max_da = max(da)

fls = file_Search('~/Postdoc/Automation/Test/201003/12/*cme*')
fls = sort_fls(fls)
mreadfits_corimp, fls[21], inc2, dac2
dac2 = reflect_inner_outer(inc2, dac2)
canny_atrous2d, dac2, modgrad
dac2 = dac2[96:1119,96:1119]
modgrad = modgrad[96:1119,96:1119,*]
thr_inner = replicate(2.35,4)
thr_outer = replicate(5.95,4)
for k=0,3 do begin & $
modgrad[*,*,k+3]=rm_inner_corimp(modgrad[*,*,k+3],inc2,dr_px,thr=thr_inner[k]) & $
modgrad[*,*,k+3]=rm_outer_corimp(modgrad[*,*,k+3],inc2,dr_px,thr=thr_outer[k]) & $
endfor
multmodsc2 = modgrad[*,*,3]*modgrad[*,*,4]*modgrad[*,*,5]*modgrad[*,*,6]

da[res[0,*],res[1,*]] = multmodsc2[res[0,*],res[1,*]]



