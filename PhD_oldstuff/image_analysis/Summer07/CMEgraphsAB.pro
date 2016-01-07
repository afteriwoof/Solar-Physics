; Reads in the .png files and the corresponding index and data arrays for fit ellipses.

; Last Edited: 26-07-07

pro CMEgraphsAB, fitsflsA, pngflsA, inA, daA, fitsflsB, pngflsB, inB, daB, savA, savB

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

	
	restore, savA+'height_apexA.sav' ; haA
	restore, savA+'height_centreA.sav' ; hcA
	restore, savA+'angular_widthA.sav' ; awA
	restore, savA+'ellipse_tiltA.sav' ; etA
	restore, savA+'ratioA.sav' ; raA
	restore, savA+'semimajorA.sav' ; semimajA
	restore, savA+'semiminorA.sav' ; semiminA
	
	restore, savB+'height_apexB.sav'
	restore, savB+'height_centreB.sav'
	restore, savB+'angular_widthB.sav'
	restore, savB+'ellipse_tiltB.sav'
	restore, savB+'ratioB.sav'
	restore, savB+'semimajorB.sav'
	restore, savB+'semiminorB.sav'
	
	for i=0,sz_pngflsA[0]-1 do arrA[*,*,i]=read_png(pngflsA[i])
	for i=0,sz_pngflsB[0]-1 do arrB[*,*,i]=read_png(pngflsB[i])
	
	iA = 0
	iB = 0	
	j = 0
	
	while ( iA lt sz_pngflsA[0]-1) do begin
		
		fl1A = pngflsA[iA]
		fl1B = pngflsB[iB]
		
		if strlen(fl1A) le 11 then begin
			
			!p.charsize = 1
			!p.multi = [0,2,2]
			read, 'Enter Ang:', ang
			frontA = arrA[*,*,iA]
			front_ell_info, frontA, inA[j], daA[*,*,j]^0.3, height_centreA, $
				height_apexA, awA, ratioA, ell_tiltA, semimajorA, semiminorA, ang

			iA+=1
		
		endif else begin
			
			case3A = 0
			
			if strlen(fl1A) eq 12 then begin
				front1A = arrA[*,*,iA]
				iA+=1
				if strlen(pngflsA[iA]) eq 12 then begin
					front2A = arrA[*,*,iA]
					if (iA+1) lt sz_pngflsA then begin
						iA += 1
						res = strpos(pngflsA[iA], '_c')
						if res eq 6 then begin
							front3A = arrA[*,*,iA]
							case3A = 1
							iA += 1
						endif
					endif
				endif
			endif else if strlen(fl1A) eq 13 then begin
				front1A = arrA[*,*,iA]
				iA+=1
				if strlen(pngflsA[iA]) eq 13 then begin
					front2A = arrA[*,*,iA]
					if (iA+1) lt sz_pngflsA then begin 
						iA+=1
						res = strpos(pngflsA[iA], '_c')
						if res eq 7 then begin
							front3A = arrA[*,*,iA]
							case3A = 1
							iA+=1
						endif
					endif	
				endif
			endif	
		
			if case3A eq 1 then begin
				lots_fronts, allA, front1A, front2A, front3A
			endif
			if case3A eq 0 then begin
				full_fronts, front1A, front2A, allA
			endif

			!p.charsize = 1
			!p.multi = [0,2,2]
			read, 'Enter Ang:', ang
			front_full_ell, allA, inA[j], daA[*,*,j]^0.3, height_centreA, $
				height_apexA, awA, ratioA, ell_tiltA, semimajorA, semiminorA, ang

		endelse	

		if strlen(fl1B) le 11 then begin		
		
			!p.multi = [2,2,2]
			read, 'Enter Ang:', ang	
			frontB = arrB[*,*,iB]
			front_ell_info, frontB, inB[j], daB[*,*,j]^0.3, height_centreB, $
				height_apexB, awB, ratioB, ell_tiltB, semimajorB, semiminorB, ang

			!p.multi = [9,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], haA, utbasedataA, psym=-2, tit='Height Apex', $
					yr=[min(haB[0:sz_inB[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='km'
			plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(haA[0:sz_inA[0]-1])*0.9, max(haA)*1.1], $
			;	color=255, linestyle=2
			legend, ['Ahead (solid)', 'Behind(dashed)'], psym=[2, 5]
			!p.multi = [7,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], deriv(timeplotA[0:sz_inA[0]-1], haA), utbasedataA, $
				psym=-2, tit='Velocity Apex', yr=[min(haB)*0.9, max(haB)*1.1], /xstyle, ytit='km/s'
			plots, timeplotB[0:sz_inB[0]-1], deriv(timeplotB[0:sz_inB[0]-1], haB), utbasedataB, $
				psym=-5, line=6
			!p.multi = [5,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], deriv(deriv(timeplotA[0:sz_inA[0]-1], haA), haA), utbasedataA, $
				psym=-2, tit='Acceleration Apex', yr=[min(haB)*0.9, max(haB)*1.1], /xstyle, ytit='km/s^2'
			plots, timeplotB[0:sz_inB[0]-1], deriv(deriv(timeplotB[0:sz_inB[0]-1], haB), haB), utbasedataB, $
				psym=-5, line=6
			
			
			;utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
			;	yr=[min(hcB[0:sz_inB[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='km'
			;plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(hcA[0:sz_inA[0]-1])*0.9, max(hcA)*1.1], $
			;	color=255, linestyle=2
			;!p.multi = [5,2,5]
			;!p.charsize = 1.5
			;utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
			;	yr=[min(raB[0:sz_inB[0]-1])*0.9, max(raB)*1.1], /xstyle
			;plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6
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
				yr=[min(haB[0:sz_inA[0]-1])*0.9, max(haB)*1.1], /xstyle, ytit='km'
			plots, timeplotB[0:sz_inB[0]-1], haB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(haA[0:sz_inA[0]-1])*0.9, max(haA)*1.1], $
			;	color=255, linestyle=2
			legend, ['Ahead (solid)', 'Behind(dashed)'], psym=[2, 5]

			!p.multi = [7,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], deriv(timeplotA[0:sz_inA[0]-1], haA), utbasedataA, $
				psym=-2, tit='Velocity Apex', yr=[min(haB)*0.9, max(haB)*1.1], /xstyle, ytit='km/s'
			plots, timeplotB[0:sz_inB[0]-1], deriv(timeplotB[0:sz_inB[0]-1], haB), utbasedataB, $
				psym=-5, line=6
			!p.multi = [5,2,5]
			!p.charsize = 1.5
			utplot, timeplotA[0:sz_inA[0]-1], deriv(deriv(timeplotA[0:sz_inA[0]-1], haA), haA), utbasedataA, $
				psym=-2, tit='Acceleration Apex', yr=[min(haB)*0.9, max(haB)*1.1], /xstyle, ytit='km/s^2'
			plots, timeplotB[0:sz_inB[0]-1], deriv(deriv(timeplotB[0:sz_inB[0]-1], haB), haB), utbasedataB, $
				psym=-5, line=6


			;!p.multi = [7,2,5]
			;!p.charsize = 1.5
			;utplot, timeplotA[0:sz_inA[0]-1], hcA, utbasedataA, psym=-2, tit='Height Centre Point', $
			;	yr=[min(hcB[0:sz_inA[0]-1])*0.9, max(hcB)*1.1], /xstyle, ytit='km'
			;plots, timeplotB[0:sz_inB[0]-1], hcB, utbasedataB, psym=-5, line=6
			;plots, [timeplotA[j], timeplotA[j]], [min(hcA[0:sz_inA[0]-1])*0.9, max(hcA)*1.1], $
			;	color=255, linestyle=2
			;!p.multi = [5,2,5]
			;!p.charsize = 1.5
			;utplot, timeplotA[0:sz_inA[0]-1], raA, utbasedataA, psym=-2, tit='Ratio Major/Minor', $
			;	yr=[min(raB[0:sz_inA[0]-1])*0.9, max(raB)*1.1], /xstyle
			;plots, timeplotB[0:sz_inB[0]-1], raB, utbasedataB, psym=-5, line=6
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

	wr_movie, 'Graphs_plots_AB', mov, framedelay=50

	

end
