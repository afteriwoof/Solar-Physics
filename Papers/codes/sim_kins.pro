; Created	2012-07-19	from sim_vels_thesis.pro

; Last edited	2013-01-17	to increase the gap between plots.

pro sim_kins, tog=tog


for i = 0, 200 do begin

if keyword_set(tog) then toggle, f='sim_kins'+int2str(i)+'.ps'

  !p.multi = [ 0, 1, 3 ]
  !p.charsize = 2.5
  !p.charthick=4
  !p.thick=4
  !x.thick=4
  !y.thick=4
;  window, xsize = 600, ysize = 800

  h0 = 60. * 1000. ; km
  n_pts = 5
  t = findgen( n_pts ) * 60. ; seconds 
  v0 = 300. ; km/s
  a0 = 2.  ; m/s/s

  h_theory = h0 + v0 * t + 0.5 * a0 * t^2

  sig_h = h_theory * 0.1 * randomn( seed, n_pts ) 

  print, 'Percentage error on heights :'
  print, sig_h / h_theory * 100.
  
  print, ' '
  print, 'Mean percentage error in heights:', mean( abs( sig_h / h_theory ) ) * 100.
  print, ' '

  h_obs = h_theory + sig_h

  xr = [ -10, max( t ) + 10 ]

  plot, t, h_obs / 1000., psym = -2, ytit = 'Height (Mm)', yrange = [ 0, max( h_theory /1000. ) * 1.1 ], $
	line = 2, xr = xr, /xs, pos=[0.15,0.71,0.95,0.96], xtickname=[' ',' ',' ',' ',' ',' ',' ']
  oplot, t, h_theory / 1000.
  oplot_err, t, h_obs / 1000., yerr = sig_h / 1000.

;  axis, yaxis=1, yrange=[0,max(h_theory/1000.)*1.1/695.5], /ys, ytit=symbol_corimp('rs')

  legend, [ 'Kinematic model', 'Simulated measurements' ], line = [ 0, 2 ], psym=[-3,-2], charsize = 1

  v_obs = deriv( t, h_obs )
  v_theory = v0 + a0 * t

  sig_v_obs = derivsig( t, h_obs, 0, sig_h )

  plot, t, v_obs, psym = -2, ytit = 'Velocity (km s!U-1!N)', yr = [ 0, 1200 ], line = 2, xr = xr, /xs, $
	pos=[0.15,0.45,0.95,0.7], xtickname=[' ',' ',' ',' ',' ',' ',' ']
  oplot, t, v_theory 
  oplot_err, t, v_obs, yerr = sig_v_obs
 
  a_obs = deriv( t, v_obs )
  a_theory = replicate( a0, n_pts )

  sig_a_obs = derivsig( t, v_obs, 0, sig_v_obs )

  plot, t, a_obs, psym = -2, xtit = 'Time (s)', ytit = 'Acceleration (m s!U-2!N)', yr = [ -20, 20 ], $
	line = 2, xr = xr, /xs, /ys, pos=[0.15,0.19,0.95,0.44]
  oplot, t, a_theory
  oplot_err, t, a_obs, yerr = sig_a_obs 


  if keyword_set(tog) then begin
	toggle
 ;	spawn, 'open sim_kins.ps'
endif

  ;pause
endfor
 
end
