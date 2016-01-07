; Code to bootstrap the kinematics profile and test how the acceleration result varies.

; Created: 03-02-11

; Last edited: 04-02-11 to call the new plot_kins_diffcadence_fixedpoint_bootstrap.pro

pro bootstrap, n, res

;INPUT	n: number of iterations

cadence1 = 1
cadence2 = 2
cadence1_end = 20
cadence2_begin = 30
fixed = 9

plot_kins_diffcadence_fixedpoint,cadence1,cadence2,cadence1_end,cadence2_begin,fixed,/plot_fixed_point,/no_trunc,/no_legend,al,att,a_max,al_fixed_err;, /no_plot

res = dblarr(n)

restore,'test.sav'

h_noisy_new = dblarr(n_elements(h_sig))

for k=0,n-1 do begin
	for j=0,n_elements(h_sig)-1 do h_noisy_new[j] = h[j] + (randomu(seed,1)*2.-1)*h_sig[j]
	plot_kins_diffcadence_fixedpoint_bootstrap,h_noisy_new,cadence1,cadence2,cadence1_end,cadence2_begin,fixed,/plot_fixed_point,/no_trunc,/no_legend,al,att,a_max,al_fixed_err;, /no_plot
	res[k] = al
endfor

print,'***'
print, 'Acceleration supposed to be: ', att
print, 'Bootstrapped acceleration is: ', ave(res)
print, 'compared to the last instant: ', al
print, '***'

end
