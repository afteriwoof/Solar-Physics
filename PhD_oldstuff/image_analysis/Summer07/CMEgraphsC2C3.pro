; Reads in the .png files and the corresponding index and data arrays for fit ellipses.

; Last Edited: 01-08-07

pro CMEgraphsC2C3, fitsflsA, pngflsA, inA, daA, fitsflsB, pngflsB, inB, daB, savA, savB

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
	mov = fltarr(900,900,sz_inA[0])

	time_arA = file2time(fitsflsA)
	utbasedataA = time_arA[0]
	timeplotA = anytim(time_arA)-anytim(time_arA[0])
	
	time_arB = file2time(fitsflsB)
	utbasedataB = time_arB[0]
	timeplotB = anytim(time_arB)-anytim(time_arB[0])
	
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
; re-editing for LASCO C2 and C# movies and graphs
	while ( iA lt sz_pngflsA[0]-1 ) do begin

		pngfl1A = pngflsA[iA]
		
		if strlen(pngfl1A) le 11 then begin
		
			!p.charsize = 1
			!p.multi = [0,2,2]
			read, 'Enter Ang: ', ang
			frontA = arrA[*,*,iA]
			lasco_front_ell, frontA, in[j], da[*,*,j]^0.3, height_centre, $
				height_apex, aw, ratio, ell_tilt, semimajor, semiminor, ang
			if (iA+1) lt sz_pngflsA then iA+=1
		
		endif else begin
		
			case2A = 1
			case3A = 0	
			case4A = 0
			case5A = 0
			case6A = 0
			case7A = 0

			if strlen(pngfl1A) eq 12 then begin
				front1A = arrA[*,*,iA]
				if (iA+1) lt sz_pngflsA then iA+=1
				if strlen(pngflsA[iA]) eq 12 then begin
					front2A = arrA[*,*,iA]
					if (iA+1) lt sz_pngflsA then iA+=1
					res = strpos(pngflsA[iA], '_c')
					if res eq 6 then begin
						front3A = arrA[*,*,i]
						case2=0
						case3=1
						if (iA+1) lt sz_pngflsA then iA+=1
						res = strpos(pngflsA[iA], '_d')
						if res eq 6 then begin
							front4A = arrA[*,*,iA]
							case3=0
							case4=1
							if (iA+1) lt sz_pngflsA then iA+=1
							res = strlen(pngflsA[iA])
							if res eq 6 then begin
								front5A = arrA[*,*,iA]
								case4=0
								case5=1
								if (iA+1) lt sz_pngflsA then i+=1
								res = strpos(pngflsA[iA], '_f')
								if res eq 6 then begin
									front6A = arrA[*,*,iA]
									case5=0
									case6=1
									if (iA+1) lt sz_pngflsA then iA+=1
								endif
							endif
						endif
					endif
				endif
			endif else if strlen(pngfl1A) eq 13 then begin
				front1A = arrA[*,*,iA]
				if (iA+1) lt sz_pngflsA then iA+=1
				if strlen(pngfls[iA]) eq 13 then begin
					front2A = arrA[*,*,iA]
					if (iA+1) lt sz_pngflsA then iA+=1
					res = strpos(pngflsA[iA], '_c')
					if res eq 7 then begin
						front3A = arrA[*,*,iA]
						case2=0
						case3=1
						if (iA+1) lt sz_pngflsA then iA+=1
						res = strpos(pngflsA[iA], '_d')
						if res eq 7 then begin
							front4A = arrA[*,*,iA]
							case3=0
							case4=1
							if (iA+1) lt sz_pngflsA then iA+=1
							res = strpos(pngflsA[iA], '_e')
							if res eq 7 then begin
								front5A = arrA[*,*,iA]
								case4=0
								case5=1
								if (iA+1) lt sz_pngflsA then i+=1
								res =strpos(pngflsA[iA], '_f')
								if res eq 7 then begin
									front6A = arrA[*,*,iA]
									case5=0
									case6=1
									if (iA+1) lt sz_pngflsA then iA+=1
								endif
							endif
						endif
					endif
				endif
			endif

			if case2 eq 1 then full_fronts, front1A, front2A, allA
			if case3 eq 1 then lots_fronts, allA, front1A, front2A, front3A
			if case4 eq 1 then four_fronts, allA, front1A, front2A, front3A, front4A
			if case5 eq 1 then five_fronts, allA, front1A, front2A, front3A, front4A, front5A
			if case6 eq 1 then six_fronts, allA, front1A, front2A, front3A, front4A, front5A, front6A

			!p.charsize=1
			!p.multi=[0,2,2]
			read, 'Enter Ang: ', ang
			lasco_full_fronts_ell, allA, inA[j], daA[*,*,j]^0.3, height_centre, $
				height_apex, aw, ratio, ell_tilt, semimajor, semiminor, ang

			j+=1

		endelse
				
			

;*************************

		pngfl1B = pngflsB[iB]

		if strlen(pngfl1B) le 11 then begin		
		
			!p.multi = [2,2,2]
			read, 'Enter Ang: ', ang	
			frontB = arrB[*,*,iB]
			lasco_front_ell, frontB, inB[j], daB[*,*,j]^0.3, height_centreB, $
				height_apexB, awB, ratioB, ell_tiltB, semimajorB, semiminorB, ang

			!p.multi = [9,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], haA, utbasedataA, psym=-2, tit='Height Apex', $
					yr=[min(haB[0:sz_inB[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='arcsec'
			plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(haA[0:sz_inA[0]-1])*0.9, max(haA)*1.1], $
			;	color=255, linestyle=2
			legend, ['Ahead (solid)', 'Behind(dashed)'], psym=[2, 5]
			!p.multi = [7,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
				yr=[min(hcB[0:sz_inB[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='arcsec'
			plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(hcA[0:sz_inA[0]-1])*0.9, max(hcA)*1.1], $
			;	color=255, linestyle=2
			!p.multi = [5,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
				yr=[min(raB[0:sz_inB[0]-1])*0.9, max(raB)*1.1], /xstyle
			plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(raA[0:sz_inA[0]-1])*0.9, max(raA)*1.1], $
			;        color=255, linestyle=2
			!p.multi = [3,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], angwA, utbasedataA, psym=-2, tit='Angular Width', $
				yr=[min(angwB[0:sz_inB[0]-1])*0.9, max(angwB)*1.1], /xstyle, ytit='degrees'
			plots, timeplotB[0:sz_inB[0]-1], angwB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(angwA[0:sz_inA[0]-1])*0.9, max(angwA)*1.1], $
			;        color=255, linestyle=2
			!p.multi = [1,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], etA, utbasedataA, psym=-2, tit='Ellipse Tilt Angle', $
				yr=[min(etB[0:sz_inB[0]-1])*0.9, max(etB)*1.1], /xstyle, ytit='degrees'
			plots, timeplotB[0:sz_inB[0]-1], etB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(etA[0:sz_inA[0]-1])*0.9, max(etA)*1.1], $
			;        color=255, linestyle=2

			plots, [timeplotA[j], timeplotA[j]], [-9999999, 9999999], color=255, linestyle=2
		
			pause
			
			mov[*,*,j] = tvrd()
		
			iB += 1
			j += 1
		
		endif else begin

			case3B = 0

			if strlen(fl1B) eq 12 then begin
				front1B = arrB[*,*,iB]
				iB+=1
				if strlen(pngflsB[iB]) eq 12 then begin
					front2B = arrB[*,*,iB]
					if (iB+1) lt sz_pngflsB then begin
						iB+=1
						res = strpos(pngflsB[iB], '_c')
						if res eq 6 then begin
							front3B = arrB[*,*,iB]
							case3B = 1
							iB+=1
						endif
					endif
				endif
			endif else if strlen(fl1B) eq 13 then begin
				front1B = arrB[*,*,iB]
				iB+=1
				if strlen(pngflsB[iB]) eq 13 then begin
					front2B = arrB[*,*,iB]
					iB+=1
					res = strpos(pngflsB[iB],'_c')
					if res eq 7 then begin
						front3B = arrB[*,*,iB]
						case3B = 1
						iB+=1
					endif
				endif
			endif
			
			if case3B eq 1 then begin
				lots_fronts, allB, front1B, front2B, front3B
			endif
			if case3B eq 0 then begin
				full_fronts, front1B, front2B, allB
			endif




			!p.multi = [2,2,2]
			read, 'Enter Ang:', ang
			front_full_ell, allB, inB[j], daB[*,*,j]^0.3, height_centreB, $
				height_apexB, awB, ratioB, ell_tiltB, semimajorB, semiminorB, ang
			!p.multi = [9,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], haA, utbasedataA, psym=-2, tit='Height Apex', $
				yr=[min(haB[0:sz_inA[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='arcsec'
			plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(haA[0:sz_inA[0]-1])*0.9, max(haA)*1.1], $
			;	color=255, linestyle=2
			legend, ['Ahead (solid)', 'Behind(dashed)'], psym=[2, 5]
			!p.multi = [7,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
				yr=[min(hcB[0:sz_inA[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='arcsec'
			plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(hcA[0:sz_inA[0]-1])*0.9, max(hcA)*1.1], $
			;	color=255, linestyle=2
			!p.multi = [5,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
				yr=[min(raB[0:sz_inA[0]-1])*0.9, max(raB)*1.1], /xstyle
			plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(raA[0:sz_inA[0]-1])*0.9, max(raA)*1.1], $
			;        color=255, linestyle=2
			!p.multi = [3,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], angwA, utbasedataA, psym=-2, tit='Angular Width', $
				yr=[min(angwB[0:sz_inA[0]-1])*0.9, max(angwB)*1.1], /xstyle, ytit='degrees'
			plots, timeplotB[0:sz_inB[0]-1], angwB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(angwA[0:sz_inA[0]-1])*0.9, max(angwA)*1.1], $
			;        color=255, linestyle=2
			!p.multi = [1,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], etA, utbasedataA, psym=-2, tit='Ellipse Tilt Angle', $
				yr=[min(etB[0:sz_inA[0]-1])*0.9, max(etB)*1.1], /xstyle, ytit='degrees'
			plots, timeplotB[0:sz_inB[0]-1], etB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(etA[0:sz_inA[0]-1])*0.9, max(etA)*1.1], $
			;        color=255, linestyle=2
			
			plots, [timeplotA[j], timeplotA[j]], [-9999999, 9999999], color=255, linestyle=2
			
			pause
			mov[*,*,j] = tvrd()

			
			j += 1

		endelse

		print, fl1A & print, fl1B
		print, iA, iB
	endwhile

	wr_movie, 'Graphs_plots', mov, framedelay=50

	

end
