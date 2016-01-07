pro multipleplots

	x = findgen(100)
	t = exp(-(x-50)^2/300)
	erase
	u = exp(-x/30)
	y = sin(x)
	r = reverse(y*u)

	!p.multi = [0,2,2,0,0]
	multiplot

	plot, x, y*u, tit='MULTIPLOT'
	multiplot & plot, x, r
	multiplot
	plot, x, y*t, ytit='ylabels'
	multiplot
	plot, x, y*t, xtit='xlabels'
	multiplot, /reset

	wait, 5 & erase
	multiplot, [1,3]
	plot, x, y*u, tit='TEST'
	multiplot
	plot, x, y*t, ytit='HEIGHT'
	multiplot
	plot, x, r, xtit='PHASE'
	multiplot, /reset

	multiplot, [1,1], /init, /verbose

end
