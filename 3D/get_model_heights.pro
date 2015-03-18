; Created:	2013-05-24	to get the heights from the model flux-rope CME.

pro get_model_heights, model_fl, r_heights, a_heights

restore, model_fl
; restores cme

print, 'Assuming Earth-directed model.'
;EARTH DIRECTED

x_model = cme.x
z_model = cme.z

recpol, x_model, z_model, r_model, a_model, /degrees

if 360-round(max(a_model)) lt 1 then a_model=(a_model+180) mod 360

plot, a_model, r_model, psym=3

a_round = round(a_model)

plots, a_round, r_model, psym=3, color=5

; find the maximum heights closest to each of the rounded angles.
a_heights = fltarr(max(a_round)-min(a_round)+1)
r_heights = fltarr(max(a_round)-min(a_round)+1)
set_gap = 0.1
for i=min(a_round),max(a_round) do begin
	print, 'i ', i
	gap = set_gap
	help, where(abs(a_model-i) lt gap)
	help, where(abs(a_model-i) lt 0.5)
	help, where(abs(a_model-i) lt gap AND abs(a_model-i) lt 0.5)
	print, n_elements(where(abs(a_model-i) lt gap AND abs(a_model-i) lt 0.5))
	while n_elements(where(abs(a_model-i) lt gap AND abs(a_model-i) lt 0.5)) lt 100 do begin
		gap+=0.1
		if gap eq 0.5 then goto, jump1
	endwhile
	jump1:
	print, 'gap ', gap
	a_close = a_model[where(abs(a_model-i) lt gap AND abs(a_model-i) lt 0.5)]
	r_close = r_model[where(abs(a_model-i) lt gap AND abs(a_model-i) lt 0.5)]
	plots, a_close, r_close, psym=1, color=3
	pause
	plots, a_close[where(r_close eq max(r_close))], max(r_close), psym=2, color=4
	pause
	r_heights[i-min(a_round)] = max(r_close)
	a_heights[i-min(a_round)] = a_close[where(r_close eq max(r_close))]
	plots, a_heights[i-min(a_round)], r_heights[i-min(a_round)], psym=2, color=2
	pause
endfor

;a_heights = indgen((max(a_round)-min(a_round)+1))+min(a_round)
;r_heights = fltarr(max(a_round)-min(a_round)+1)

;for i=min(a_round),max(a_round) do r_heights[i-min(a_round)] = max(r_model[where(a_round eq i)])

;plots, a_heights, r_heights, psym=2, color=3
;plots, a_close[where(r_close eq max(r_close))], max(r_close), psym=2, color=2

end
