; Reads in the .png files and the corresponding index and data arrays for fit ellipses.

; Last Edited: 09-08-07

pro CMEgraphsC2C3_seperate, fitsflsA, pngflsA, inA, daA, fitsflsB, pngflsB, inB, daB, savA, savB

	!p.multi=0

	angans = ''

	sz_pngflsA = size(pngflsA,/dim)
	sz_pngflsB = size(pngflsB,/dim)
	tempA = read_png(pngflsA[0])
	tempB = read_png(pngflsB[0])
	sz_pngA = size(tempA,/dim)
	sz_pngB = size(tempB,/dim)
	arrA = fltarr(sz_pngA[0],sz_pngA[1],sz_pngflsA[0])
	arrB = fltarr(sz_pngB[0],sz_pngB[1],sz_pngflsB[0])
	
	sz_daA = size(daA, /dim)
	sz_daB = size(daB, /dim)
	sz_inA = size(inA, /dim)
	sz_inB = size(inB, /dim)

	window, 0, xs=900, ys=900, xpos=100, ypos=100
	mov = fltarr(900,900,sz_inA[0]+sz_inB[0])

	time_arA = file2time(fitsflsA)
	utbasedataA = time_arA[0]
	timeplotA = anytim(time_arA)-anytim(time_arA[0])
	
	time_arB = file2time(fitsflsB)
	utbasedataB = time_arB[0]
	timeplotB = anytim(time_arB)-anytim(time_arB[0])

	time_ar = [time_arA, time_arB]
	utbasedata = time_ar[0]
	timeplot = anytim(time_ar)-anytim(utbasedata)

	restore, savA+'height_apexC2.sav' ; haA
	restore, savA+'height_centreC2.sav' ; hcA
	restore, savA+'angular_widthC2.sav' ; awA
	restore, savA+'ellipse_tiltC2.sav' ; etA
	restore, savA+'ratioC2.sav' ; raA
	restore, savA+'semimajorC2.sav' ; semimajA
	restore, savA+'semiminorC2.sav' ; semiminA
	
	restore, savB+'height_apexC3.sav'
	restore, savB+'height_centreC3.sav'
	restore, savB+'angular_widthC3.sav'
	restore, savB+'ellipse_tiltC3.sav'
	restore, savB+'ratioC3.sav'
	restore, savB+'semimajorC3.sav'
	restore, savB+'semiminorC3.sav'
	
	for i=0,sz_pngflsA[0]-1 do arrA[*,*,i]=read_png(pngflsA[i])
	for i=0,sz_pngflsB[0]-1 do arrB[*,*,i]=read_png(pngflsB[i])

	iA = 0
	iB = 0	
	j = 0
;*************************
; re-editing for LASCO C2 and C3 movies and graphs
	while ( iA lt sz_pngflsA[0]-1 ) do begin


		pngfl1A = pngflsA[iA]
		print, pngfl1A

		if strlen(pngfl1A) le 11 then begin
	
			print, 'strlen(pngfl1A) le 11'	
			!p.charsize = 1
			!p.multi = [0,2,2]
			read, 'Enter Ang: ', ang
			frontA = arrA[*,*,iA]
			lasco_front_ell, frontA, inA[j], daA[*,*,j], height_centre, $
				height_apex, aw, ratio, ell_tilt, semimajor, semiminor, ang
	
			!p.multi = [2,2,2]
			plot_image, daA[*,*,j]^0.3
		
			!p.multi=[9,2,5]
                        !p.charsize=2
			ha_tot = [haA, haB]
			utplot, timeplot, ha_tot/1000, utbasedata, psym=-2, tit='Height Apex', $
				yr=[min(ha_tot/1000)*0.9, max(ha_tot/1000)*1.1], /xstyle, ytit='Mm'
                        ;utplot, timeplotA[0:sz_inA[0]-1], haA, utbasdataA, psym=-2, tit='Height Apex', $
                        ;        yr=[min(haB[0:sz_inB[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6
			
                        !p.multi=[7,2,5]
			utplot, timeplot, deriv(timeplot, ha_tot), utbasedata, psym=-2, tit='Velocity Apex', $
				ytit='km/sec'
			;hc_tot = [hcA, hcB]
			;utplot, timeplot, hc_tot, utbasedata, psym=-2, tit='Height Centre Pt.', $
			;	yr=[min(hc_tot)*0.9, max(hc_tot)*1.1], /xstyle, ytit='km'
                        ;utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
                        ;        yr=[min(hcB[0:sz_inB[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6

                        !p.multi=[5,2,5]
			utplot, timeplot, deriv(deriv(timeplot, ha_tot), ha_tot)*1000, utbasedata, psym=-2, $
				tit='Acceleration Apex', ytit='m/sec^2'
			;ra_tot = [raA, raB]
			;utplot, timeplot, ra_tot, utbasedata, psym=-2, tit='Ratio Major/Minor', $
			;	yr=[min(ra_tot)*0.9, max(ra_tot)*1.1], /xstyle
                        ;utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
                        ;        yr=[min(raB[0:sz_inB[0]-1])*0.9, max(raB)*1.1], /xstyle
                        ;plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6

                        !p.multi=[3,2,5]
			angw_tot = [angwA, angwB]
			utplot, timeplot, angw_tot, utbasedata, psym=-2, tit='Angular Width', $
				yr=[min(angw_tot)*0.9, max(angw_tot)*1.1], /xstyle, ytit='degrees'
                        ;utplot, timeplotA[0:sz_inA[0]-1], angwA, utbasedataA, paym=-2, tit='Angular Width', $
                        ;        yr=[min(angwB[0:sz_inB[0]-1])*0.9, max(angwB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], angwB, utbasedataB, psym=-5, line=6

                        !p.multi=[1,2,5]
                        et_tot = [etA, etB]
			utplot, timeplot, et_tot, utbasedata, psym=-2, tit='Ellipse Tilt Angle', $
				yr=[min(et_tot)*0.9, max(et_tot)*1.1], /xstyle, ytit='degrees'
			;utplot, timeplotA[0:sz_inA[0]-1], etA, utbasedataA, psym=-2, tit='Ellipse Tilt Angle', $
                        ;        yr=[min(etB[0:sz_inB[0]-1])*0.9, max(etB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], etB, utbasedataB, psym=-5, line=6

                        plots, [timeplot[j], timeplot[j]], [-9999999, 9999999], color=255, linestyle=2

                        pause
                        mov[*,*,j] = tvrd()
                        j+=1
			
			if (iA+1) lt sz_pngflsA[0] then iA+=1
		
			help, iA, j
			
		endif else begin
		
			case2A = 1
			case3A = 0	
			case4A = 0
			case5A = 0
			case6A = 0
			case7A = 0
			case8A = 0
			
			if strlen(pngfl1A) eq 12 then begin
				print, 'strlen(pngfl1A) eq 12'
				front1A = arrA[*,*,iA]
				help, front1A
				if (iA+1) lt sz_pngflsA[0] then iA+=1
				if strlen(pngflsA[iA]) eq 12 then begin
					front2A = arrA[*,*,iA]
					if (iA+1) lt sz_pngflsA[0] then iA+=1
					res = strpos(pngflsA[iA], '_c')
					if res eq 6 then begin
						front3A = arrA[*,*,iA]
						case2A=0
						case3A=1
						if (iA+1) lt sz_pngflsA[0] then iA+=1
						res = strpos(pngflsA[iA], '_d')
						if res eq 6 then begin
							front4A = arrA[*,*,iA]
							case3A=0
							case4A=1
							if (iA+1) lt sz_pngflsA[0] then iA+=1
							res = strpos(pngflsA[iA], '_e')
							if res eq 6 then begin
								front5A = arrA[*,*,iA]
								case4A=0
								case5A=1
								if (iA+1) lt sz_pngflsA[0] then iA+=1
								res = strpos(pngflsA[iA], '_f')
								if res eq 6 then begin
									front6A = arrA[*,*,iA]
									case5A=0
									case6A=1
									if (iA+1) lt sz_pngflsA[0] then iA+=1
									res = strpos(pngflsA[iA], '_g')
									if res eq 6 then begin
										front7A = arrA[*,*,iA]
										case6A=0
										case7A=1
										if (iA+1) lt sz_pngflsA[0] then iA+=1
										res = strpos(pngflsA[iA], '_h')
										if res eq 6 then begin
											front8A = arrA[*,*,iA]
											case7A=0
											case8A=1
											if (iA+1) lt sz_pngflsA[0] then iA+=1
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif else if strlen(pngfl1A) eq 13 then begin
				print, 'strlen(pngfl1A eq 13'
				front1A = arrA[*,*,iA]
				help, front1A
				if (iA+1) lt sz_pngflsA[0] then iA+=1
				if strlen(pngflsA[iA]) eq 13 then begin
					front2A = arrA[*,*,iA]
					if (iA+1) lt sz_pngflsA[0] then iA+=1
					res = strpos(pngflsA[iA], '_c')
					if res eq 7 then begin
						front3A = arrA[*,*,iA]
						case2A=0
						case3A=1
						if (iA+1) lt sz_pngflsA[0] then iA+=1
						res = strpos(pngflsA[iA], '_d')
						if res eq 7 then begin
							front4A = arrA[*,*,iA]
							case3A=0
							case4A=1
							if (iA+1) lt sz_pngflsA[0] then iA+=1
							res = strpos(pngflsA[iA], '_e')
							if res eq 7 then begin
								front5A = arrA[*,*,iA]
								case4A=0
								case5A=1
								if (iA+1) lt sz_pngflsA[0] then iA+=1
								res =strpos(pngflsA[iA], '_f')
								if res eq 7 then begin
									front6A = arrA[*,*,iA]
									case5A=0
									case6A=1
									if (iA+1) lt sz_pngflsA[0] then iA+=1
									res = strpos(pngflsA[iA], '_g')
									if res eq 7 then begin
										front7A = arrA[*,*,iA]
										case6A=0
										case7A=1
										if (iA+1) lt sz_pngflsA[0] then iA+=1
										res = strpos(pngflsA[iA], '_h')
										if res eq 7 then begin
											front8A = arrA[*,*,iA]
											case7A=0
											case8A=1
											if (iA+1) lt sz_pngflsA[0] then iA+=1
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif

			help, iA, j
			
			if case2A eq 1 then full_fronts, front1A, front2A, allA
			if case3A eq 1 then lots_fronts, allA, front1A, front2A, front3A
			if case4A eq 1 then four_fronts, allA, front1A, front2A, front3A, front4A
			if case5A eq 1 then five_fronts, allA, front1A, front2A, front3A, front4A, front5A
			if case6A eq 1 then six_fronts, allA, front1A, front2A, front3A, front4A, front5A, front6A
			if case7A eq 1 then seven_fronts, allA, front1A, front2A, front3A, front4A, front5A, front6A, front7A
			if case8A eq 1 then eight_fronts, allA, front1A, front2A, front3A, front4A, front5A, front6A, front7A, front8A
			
			!p.charsize=1
			!p.multi=[0,2,2]
			read, 'Enter Ang: ', ang
			lasco_full_fronts_ell, allA, inA[j], daA[*,*,j], height_centre, $
				height_apex, aw, ratio, ell_tilt, semimajor, semiminor, ang

			!p.multi=[2,2,2]
			plot_image, daA[*,*,j]^0.3
	
			!p.multi=[9,2,5]
                        !p.charsize=2
			ha_tot = [haA, haB]
			utplot, timeplot, ha_tot/1000, utbasedata, psym=-2, tit='Height Apex', $
				yr=[min(ha_tot/1000)*0.9, max(ha_tot/1000)*1.1], /xstyle, ytit='Mm'
                        ;utplot, timeplotA[0:sz_inA[0]-1], haA, utbasdataA, psym=-2, tit='Height Apex', $
                        ;        yr=[min(haB[0:sz_inB[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6

                        !p.multi=[7,2,5]
			utplot, timeplot, deriv(timeplot, ha_tot), utbasedata, psym=-2, tit='Velocity Apex', $
				ytit='km/sec'
			;hc_tot = [hcA, hcB]
			;utplot, timeplot, hc_tot, utbasedata, psym=-2, tit='Height Centre Pt.', $
			;	yr=[min(hc_tot)*0.9, max(hc_tot)*1.1], /xstyle, ytit='km'
                        ;utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
                        ;        yr=[min(hcB[0:sz_inB[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6

                        !p.multi=[5,2,5]
			utplot, timeplot, deriv(deriv(timeplot, ha_tot), ha_tot)*1000, utbasedata, psym=-2, $
				tit='Acceleration Apex', ytit='m/sec^2'
			;ra_tot = [raA, raB]
			;utplot, timeplot, ra_tot, utbasedata, psym=-2, tit='Ratio Major/Minor', $
			;	yr=[min(ra_tot)*0.9, max(ra_tot)*1.1], /xstyle
                        ;utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
                        ;        yr=[min(raB[0:sz_inB[0]-1])*0.9, max(raB)*1.1], /xstyle
                        ;plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6

                        !p.multi=[3,2,5]
			angw_tot = [angwA, angwB]
			utplot, timeplot, angw_tot, utbasedata, psym=-2, tit='Angular Width', $
				yr=[min(angw_tot)*0.9, max(angw_tot)*1.1], /xstyle, ytit='degrees'
                        ;utplot, timeplotA[0:sz_inA[0]-1], angwA, utbasedataA, paym=-2, tit='Angular Width', $
                        ;        yr=[min(angwB[0:sz_inB[0]-1])*0.9, max(angwB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], angwB, utbasedataB, psym=-5, line=6

                        !p.multi=[1,2,5]
                        et_tot = [etA, etB]
			utplot, timeplot, et_tot, utbasedata, psym=-2, tit='Ellipse Tilt Angle', $
				yr=[min(et_tot)*0.9, max(et_tot)*1.1], /xstyle, ytit='degrees'
			;utplot, timeplotA[0:sz_inA[0]-1], etA, utbasedataA, psym=-2, tit='Ellipse Tilt Angle', $
                        ;        yr=[min(etB[0:sz_inB[0]-1])*0.9, max(etB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], etB, utbasedataB, psym=-5, line=6

                        plots, [timeplot[j], timeplot[j]], [-9999999, 9999999], color=255, linestyle=2

			pause
			mov[*,*,j] = tvrd()
			j+=1
			help, iA, j

		endelse
		
	endwhile

	iB = 0
	k = 0
	
	while ( iB lt sz_pngflsB[0]-1 ) do begin

		pngfl1B = pngflsB[iB]

		if strlen(pngfl1B) le 11 then begin

			!p.charsize = 1
			!p.multi = [0,2,2]
			read, 'Enter Ang: ', ang
			frontB = arrB[*,*,iB]
			lasco_front_ell, frontB, inB[k], daB[*,*,k], height_centre, $
				height_apex, aw, ratio, ell_tilt, semimajor, semiminor, ang

			!p.multi=[2,2,2]
			plot_image, daB[*,*,k]^0.3

			!p.multi=[9,2,5]
                        !p.charsize=2
			ha_tot = [haA, haB]
			utplot, timeplot, ha_tot/1000, utbasedata, psym=-2, tit='Height Apex', $
				yr=[min(ha_tot/1000)*0.9, max(ha_tot/1000)*1.1], /xstyle, ytit='Mm'
                        ;utplot, timeplotA[0:sz_inA[0]-1], haA, utbasdataA, psym=-2, tit='Height Apex', $
                        ;        yr=[min(haB[0:sz_inB[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6

                        !p.multi=[7,2,5]
			utplot, timeplot, deriv(timeplot, ha_tot), utbasedata, psym=-2, tit='Velocity Apex', $
				ytit='km/sec'
			;hc_tot = [hcA, hcB]
			;utplot, timeplot, hc_tot, utbasedata, psym=-2, tit='Height Centre Pt.', $
			;	yr=[min(hc_tot)*0.9, max(hc_tot)*1.1], /xstyle, ytit='km'
                        ;utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
                        ;        yr=[min(hcB[0:sz_inB[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6

                        !p.multi=[5,2,5]
			utplot, timeplot, deriv(deriv(timeplot, ha_tot), ha_tot)*1000, utbasedata, psym=-2, $
				tit='Acceleration Apex', ytit='m/sec^2'
			;ra_tot = [raA, raB]
			;utplot, timeplot, ra_tot, utbasedata, psym=-2, tit='Ratio Major/Minor', $
			;	yr=[min(ra_tot)*0.9, max(ra_tot)*1.1], /xstyle
                        ;utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
                        ;        yr=[min(raB[0:sz_inB[0]-1])*0.9, max(raB)*1.1], /xstyle
                        ;plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6

                        !p.multi=[3,2,5]
			angw_tot = [angwA, angwB]
			utplot, timeplot, angw_tot, utbasedata, psym=-2, tit='Angular Width', $
				yr=[min(angw_tot)*0.9, max(angw_tot)*1.1], /xstyle, ytit='degrees'
                        ;utplot, timeplotA[0:sz_inA[0]-1], angwA, utbasedataA, paym=-2, tit='Angular Width', $
                        ;        yr=[min(angwB[0:sz_inB[0]-1])*0.9, max(angwB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], angwB, utbasedataB, psym=-5, line=6

                        !p.multi=[1,2,5]
                        et_tot = [etA, etB]
			utplot, timeplot, et_tot, utbasedata, psym=-2, tit='Ellipse Tilt Angle', $
				yr=[min(et_tot)*0.9, max(et_tot)*1.1], /xstyle, ytit='degrees'
			;utplot, timeplotA[0:sz_inA[0]-1], etA, utbasedataA, psym=-2, tit='Ellipse Tilt Angle', $
                        ;        yr=[min(etB[0:sz_inB[0]-1])*0.9, max(etB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], etB, utbasedataB, psym=-5, line=6

                        plots, [timeplot[j], timeplot[j]], [-9999999, 9999999], color=255, linestyle=2

                        pause
                        mov[*,*,j] = tvrd()

			if (iB+1) lt sz_pngflsB then iB+=1
			j+=1
			k+=1
			
		endif else begin

			case2B=1
			case3B=0
			case4B=0
			case5B=0
			case6B=0
			case7B=0
			case8B=0
			
			if strlen(pngfl1B) eq 12 then begin
				front1B = arrB[*,*,iB]
				if (iB+1) lt sz_pngflsB then iB+=1
				if strlen(pngflsB[iB]) eq 12 then begin
					front2B = arrB[*,*,iB]
					if (iB+1) lt sz_pngflsB then iB+=1
					res = strpos(pngflsB[iB], '_c')
					if res eq 6 then begin
						front3B = arrB[*,*,iB]
						case2B=0
						case3B=1
						if (iB+1) lt sz_pngflsB then iB+=1
						res = strpos(pngflsB[iB], '_d')
						if res eq 6 then begin
							front4B = arrB[*,*,iB]
							case3B=0
							case4B=1
							if (iB+1) lt sz_pngflsB then iB+=1
							res = strpos(pngflsB[iB], '_e')
							if res eq 6 then begin
								front5B = arrB[*,*,iB]
								case4B=0
								case5B=1
								if (iB+1) lt sz_pngflsB then iB+=1
								res = strpos(pngflsB[iB], '_f')
								if res eq 6 then begin
									front6B = arrB[*,*,iB]
									case5B=0
									case6B=1
									if (iB+1) lt sz_pngflsB then iB+=1
									res = strpos(pngflsB[iB], '_g')
									if res eq 6 then begin
										front7B = arrB[*,*,iB]
										case6B=0
										case7B=1
										if (iB+1) lt sz_pngflsB then iB+=1
										res = strpos(pngflsB[iB], '_h')
										if res eq 6 then begin
											front8B = arrB[*,*,iB]
											case7B=0
											case8B=1
											if (iB+1) lt sz_pngflsB then iB+=1
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif else if strlen(pngfl1B) eq 13 then begin
				front1B = arrB[*,*,iB]
				if (iB+1) lt sz_pngflsB then iB+=1
				if strlen(pngflsB[iB]) eq 13 then begin
					front2B = arrB[*,*,iB]
					if (iB+1) lt sz_pngflsB then iB+=1
					res = strpos(pngflsB[iB], '_c')
					if res eq 7 then begin
						front3B = arrB[*,*,iB]
						case2B=0
						case3B=1
						if (iB+1) lt sz_pngflsB then iB+=1
						res = strpos(pngflsB[iB], '_d')
						if res eq 7 then begin
							front4B = arrB[*,*,iB]
							case3B=0
							case4B=1
							if (iB+1) lt sz_pngflsB then iB+=1
							res = strpos(pngflsB[iB], '_e')
							if res eq 7 then begin
								front5B = arrB[*,*,iB]
								case4B=0
								case5B=1
								if (iB+1) lt sz_pngflsB then iB+=1
								res = strpos(pngflsB[iB], '_f')
								if res eq 7 then begin
									front6B = arrB[*,*,iB]
									case5B=0
									case6B=1
									if (iB+1) lt sz_pngflsB then iB+=1
									res = strpos(pngflsB[iB], '_g')
									if res eq 7 then begin
										front7B = arrB[*,*,iB]
										case6B=0
										case7B=1
										if (iB+1) lt sz_pngflsB then iB+=1
										res = strpos(pngflsB[iB], '_h')
										if res eq 7 then begin
											front8B = arrB[*,*,iB]
											case7B=0
											case8B=1
											if (iB+1) lt sz_pngflsB then iB+=1
										endif
									endif	
								endif
							endif
						endif
					endif
				endif
			endif

			if case2B eq 1 then full_fronts, front1B, front2B, allB
			if case3B eq 1 then lots_fronts, allB, front1B, front2B, front3B
			if case4B eq 1 then four_fronts, allB, front1B, front2B, front3B, front4B
			if case5B eq 1 then five_fronts, allB, front1B, front2B, front3B, front4B, front5B
			if case6B eq 1 then six_fronts, allB, front1B, front2B, front3B, front4B, front5B, front6B
			if case7B eq 1 then seven_fronts, allB, front1B, front2B, front3B, front4B, front5B, front6B, front7B
			if case8B eq 1 then eight_fronts, allB, front1B, front2B, front3B, front4B, front5B, front6B, front7B, front8B
			
			!p.charsize=1
			!p.multi=[0,2,2]
			read, 'Enter Ang: ', ang
			lasco_full_fronts_ell, allB, inB[k], daB[*,*,k], height_centre, $
				height_apex, aw, ratio, ell_tilt, semimajor, semiminor, ang

			!p.multi=[2,2,2]
			plot_image, daB[*,*,k]^0.3

			!p.multi=[9,2,5]
                        !p.charsize=2
			ha_tot = [haA, haB]
			utplot, timeplot, ha_tot/1000, utbasedata, psym=-2, tit='Height Apex', $
				yr=[min(ha_tot/1000)*0.9, max(ha_tot/1000)*1.1], /xstyle, ytit='Mm'
                        ;utplot, timeplotA[0:sz_inA[0]-1], haA, utbasdataA, psym=-2, tit='Height Apex', $
                        ;        yr=[min(haB[0:sz_inB[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6

                        !p.multi=[7,2,5]
			utplot, timeplot, deriv(timeplot, ha_tot), utbasedata, psym=-2, tit='Velocity Apex', $
				ytit='km/sec'
			;hc_tot = [hcA, hcB]
			;utplot, timeplot, hc_tot, utbasedata, psym=-2, tit='Height Centre Pt.', $
			;	yr=[min(hc_tot)*0.9, max(hc_tot)*1.1], /xstyle, ytit='km'
                        ;utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
                        ;        yr=[min(hcB[0:sz_inB[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='arcsec'
                        ;plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6

                        !p.multi=[5,2,5]
			utplot, timeplot, deriv(deriv(timeplot, ha_tot), ha_tot)*1000, utbasedata, psym=-2, $
				tit='Acceleration Apex', ytit='m/sec^2'
			;ra_tot = [raA, raB]
			;utplot, timeplot, ra_tot, utbasedata, psym=-2, tit='Ratio Major/Minor', $
			;	yr=[min(ra_tot)*0.9, max(ra_tot)*1.1], /xstyle
                        ;utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
                        ;        yr=[min(raB[0:sz_inB[0]-1])*0.9, max(raB)*1.1], /xstyle
                        ;plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6

                        !p.multi=[3,2,5]
			angw_tot = [angwA, angwB]
			utplot, timeplot, angw_tot, utbasedata, psym=-2, tit='Angular Width', $
				yr=[min(angw_tot)*0.9, max(angw_tot)*1.1], /xstyle, ytit='degrees'
                        ;utplot, timeplotA[0:sz_inA[0]-1], angwA, utbasedataA, paym=-2, tit='Angular Width', $
                        ;        yr=[min(angwB[0:sz_inB[0]-1])*0.9, max(angwB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], angwB, utbasedataB, psym=-5, line=6

                        !p.multi=[1,2,5]
                        et_tot = [etA, etB]
			utplot, timeplot, et_tot, utbasedata, psym=-2, tit='Ellipse Tilt Angle', $
				yr=[min(et_tot)*0.9, max(et_tot)*1.1], /xstyle, ytit='degrees'
			;utplot, timeplotA[0:sz_inA[0]-1], etA, utbasedataA, psym=-2, tit='Ellipse Tilt Angle', $
                        ;        yr=[min(etB[0:sz_inB[0]-1])*0.9, max(etB)*1.1], /xstyle, ytit='degrees'
                        ;plots, timeplotB[0:sz_inB[0]-1], etB, utbasedataB, psym=-5, line=6

                        plots, [timeplot[j], timeplot[j]], [-9999999, 9999999], color=255, linestyle=2
			
			pause
			mov[*,*,j] = tvrd()
			j+=1
			k+=1

		endelse

	endwhile
		
		
	wr_movie, 'Graphs_plots_lasco', mov, framedelay=50
	

END

