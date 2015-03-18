; Created:	2013-04-02	to scale the quadrilaterals from the STEREO triangulation into a soluation space constrained by SOHO lines-of-sight.

pro scale_quads

readcol, '~/temp/vertices.txt', cross1, cross2, cross3, f='D,D,D'

sz = size(cross1, /dim)

lim = sz/4

set_line_color

k = 30 ;take a random slice
i = [0,1,2,3]+4*k
theta = 90.d - cross2[i[0]:i[3]]
phi = cross1[i[0]:i[3]] * !pi/180.d
theta *= !pi/180.d
c1 = cross3[i[0]:i[3]] * sin(theta) * cos(phi)
c2 = cross3[i[0]:i[3]] * sin(theta) * sin(phi)
c3 = cross3[i[0]:i[3]] * cos(theta)
sort3 = sort(c3)
openw, lun, /get_lun, 'measure.txt', error=err
free_lun, lun
openu, lun, 'measure.txt', /append
for j=0,3 do printf, lun, cross1[i[sort3[j]]], cross2[i[sort3[j]]], cross3[i[sort3[j]]], f='(D,D,D)'
free_lun, lun
flatten_plane, 'measure.txt', x, y, z, p1, p2, p3, p4, a, b, c, s, t, angle1, angle2, angle3, angle4, /pause
ellipse_equations, a, b, c, s, t, semimajor, semiminor, hx, hy
x_ell = [0,0,a,s]
y_ell = [0,c,b,t]
ell_quadrilateral, x_ell, y_ell, semimajor, semiminor, hx, hy, ell
plots, ell
;ans = ''
;read, 'flip ellipse?', ans
;if ans eq 'y' then begin




end
