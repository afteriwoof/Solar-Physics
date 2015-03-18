;Created	2013-05-24	to get the heights from the 3D coordinates along specific angles, such as from those given by the model in get_model_heights.pro

pro get_heights_along_angles, x, y, z, angs, heights

print, 'Assuming Earth-directed model'
;EARTH DIRECTED

recpol, x, z, r, a, /degrees

if 360-round(max(a)) lt 1 then a=(a+180) mod 360

a_round = round(a)

heights = fltarr(n_elements(angs))

for i=min(angs),max(angs) do heights[i-min(angs)] = max(r[where(a_round eq i)])

plot, a, r, psym=3
plots, a_round, r, psym=3, color=5
plots, angs, heights, psym=2, color=3


end
