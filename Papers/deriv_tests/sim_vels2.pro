pro sim_vels2

for i = 0, 40 do begin

  !p.multi = [ 0, 1, 3 ]
  !p.charsize = 3
  window, xsize = 600, ysize = 800

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

  plot, t, h_obs / 1000., psym = -2, xtit = 'Time (s)', ytit = 'Height (Mm)', yrange = [ 0, max( h_theory /1000. ) * 1.1 ], line = 2, xr = xr, /xs
  oplot, t, h_theory / 1000.

  legend, [ 'Theory', 'Simulation' ], line = [ 0, 2 ], charsize = 1.5

  reverse_diff, t, h_obs, t_v_obs, v_obs

  v_theory = v0 + a0 * t

  plot, t_v_obs, v_obs, psym = -2, xtit = 'Time (s)', ytit = 'Velocity (km/s)', yr = [ 0, max( v_theory ) * 1.2 ], line = 2, xr = xr, /xs
  oplot, t, v_theory 
 
  reverse_diff, t_v_obs, v_obs, t_a_obs, a_obs

  a_theory = replicate( a0, n_pts )

  plot, t_a_obs, a_obs, psym = -2, xtit = 'Time (s)', ytit = 'Acceleration (m/s/s)', yr = [ -20, 20 ], line = 2, xr = xr, /xs, /ys
  oplot, t, a_theory

  wait, 1

endfor
 
end
