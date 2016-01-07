pro reverse_diff, x, y, x_new, dydx

  dy = fltarr( n_elements( y ) - 1 )
  dx = dy
  x_new = dy
 
  for i = 0, n_elements( y ) - 2 do begin

    dy[ i ] = y[ i + 1 ] - y[ i ]
    dx[ i ] = x[ i + 1 ] - x[ i ]

    dydx = dy / dx

    x_new[ i ] = x[ i ] + ( x[ i + 1 ] - x[ i ] ) / 2. 
 
  endfor





end
