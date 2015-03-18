set_line_color
pwd
print, file

flatten_plane, file, x,y,z,p1, p2, p3, p4, a, b, c, s, t, angle1, angle2, angle3, angle4

put in some code to check that the measure.txt values are in order?!

ellipse_equations, a, b, c, s, t, semimajor, semiminor, hx, hy

x_ell = [0,0,a,s]
y_ell = [0,c,b,t]
ell_quadrilateral, x_ell, y_ell, semimajor, semiminor, hx, hy, ell

unflatten_plane, ell, angle1, angle2, angle3, angle4, [x[0],y[0],z[0]], xe, ye, ze

plot_spacecraft_views, ina, inb, x,y,z, xe, ye, ze, /zoom
;plot_spacecraft_views,ina[3],inb[3],x,y,z,xe,ye,ze,/zoom
