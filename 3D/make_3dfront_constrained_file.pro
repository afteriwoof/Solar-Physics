; Code to take the slices and put them into a file for Jose to make 3D vis.

pro make_3dfront_constrained_file

openw, lun, /get_lun, '3dfront_constrained_file.txt', error=err
free_lun,lun

restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/ahead_location.sav'
restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/behind_location.sav'

openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'STEREO HEEQ'
printf, lun, 'Ecliptic normal  0.011381749   0.12571795   0.99200073'
printf, lun, 'Ahead position ', xa, ya, za
printf, lun, 'Behind position ', xb, yb, zb
printf, lun, 'Earth position	211.7	0.0	-2.4'
printf, lun, 'Sun position	0.0	0.0	0.0'
printf, lun, 'Mercury position	-82.3	-49.5	-3.3'
printf, lun, 'Venus position	69.5	-139.3	8.8'
printf, lun, 'NumberOfFrames 37'
printf, lun, 'Frame 0'
printf, lun, '  Time 2008:12:12:06:05'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 64'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [61,63]
num=[2,3,4,6,64,66,67,68,70]

ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0605/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=8,62 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0605/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,8 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0605/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 1'
printf, lun, '  Time 2008:12:12:06:15'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 65'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [50,52,53,indgen(64-55+1)+55]
num=[2,3,5,7,8,9,10,11,59,60,61,62,63,64,65,66,68,69,70,73]
ellipse_count = 0
for j=0,7 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0615/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=13,57 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0615/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=8,19 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0615/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 2'
printf, lun, '  Time 2008:12:12:06:25'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 73'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [57,59,61,indgen(72-63+1)+63]
num=[9,11,13,76,77,78,79,81,82,83,87,88,89]
ellipse_count = 0
for j=0,2 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0625/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=15,74 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0625/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=3,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0625/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 3'
printf, lun, '  Time 2008:12:12:06:35'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 72'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [55,57,indgen(71-59+1)+59]
num=[3,5,7,8,9,72,74,75,76,78,80,84]
ellipse_count = 0
for j=0,4 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0635/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=11,70 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0635/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=5,11 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0635/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 4'
printf, lun, '  Time 2008:12:12:06:45'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [51,52,55,indgen(69-57+1)+57]
num=[3,5,6,8,11,68,69,70,71,72,73,74,75,76,79,81,82]
ellipse_count = 0
for j=0,4 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0645/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=13,66 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0645/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=5,16 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0645/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 5'
printf, lun, '  Time 2008:12:12:06:55'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 78'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [53,55,57,indgen(77-60+1)+60]
num=[6,8,10,11,13,86,87,89,90]
ellipse_count = 0
for j=0,4 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0655/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=15,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0655/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=5,8 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0655/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 6'
printf, lun, '  Time 2008:12:12:07:05'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 75'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [49,51,53,55,indgen(74-57+1)+57]
num=[9,76,77,78,79,80,81,83,85,87,88]
ellipse_count = 0
for j=0,0 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0705/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=11,74 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0705/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=1,10 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0705/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 7'
printf, lun, '  Time 2008:12:12:07:15'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 82'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [56,58,60,62,indgen(81-64+1)+64]
num=[8,10,12,13,14,15,16,17,18,19,20,21,83,84,85,86,87,88,89,91,93,95,98]
ellipse_count = 0
for j=0,11 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0715/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=23,81 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0715/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=12,22 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0715/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 8'
printf, lun, '  Time 2008:12:12:07:35'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 76'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [48,50,52,54,indgen(75-56+1)+56]
num=[3,8,10,11,12,14,79,80,81,82,83,84,87,91]
ellipse_count = 0
for j=0,5 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=16,77 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=6,13 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 9'
printf, lun, '  Time 2008:12:12:08:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 86'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(85-71+1)+71]
ellipse_count = 0
for k=13,98 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0822/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0822/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 10'
printf, lun, '  Time 2008:12:12:08:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 84'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(83-67+1)+67]
ellipse_count = 0
for k=13,15 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0852/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0852/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=17,97 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0852/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0852/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 11'
printf, lun, '  Time 2008:12:12:09:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 81'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(80-59+1)+59]
ellipse_count = 0
for k=11,11 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0922/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=13,92 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0922/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 12'
printf, lun, '  Time 2008:12:12:09:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 79'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(78-59+1)+59]
ellipse_count = 0
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0952/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0952/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0952/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/0952/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 13'
printf, lun, '  Time 2008:12:12:10:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(70-48+1)+48]
ellipse_count = 0
for k=2,72 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1022/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1022/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 14'
printf, lun, '  Time 2008:12:12:10:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(70-46+1)+46]
ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1052/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1052/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,73 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1052/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1052/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 15'
printf, lun, '  Time 2008:12:12:11:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 76'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,indgen(75-46+1)+46]
ellipse_count = 0
for k=3,78 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1122/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1122/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 16'
printf, lun, '  Time 2008:12:12:11:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 83'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,1,2,3,indgen(82-45+1)+45]
ellipse_count = 0
for k=1,1 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1152/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1152/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,85 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1152/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1152/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 17'
printf, lun, '  Time 2008:12:12:12:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 89'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(14+1),indgen(88-50+1)+50]
ellipse_count = 0
for k=1,1 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1222/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1222/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=3,90 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1222/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1222/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 18'
printf, lun, '  Time 2008:12:12:12:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 87'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(15+1),indgen(86-52+1)+52]
ellipse_count = 0
for k=4,90 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1252/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1252/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 19'
printf, lun, '  Time 2008:12:12:13:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 89'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(15+1), indgen(88-53+1)+53]
ellipse_count = 0
for k=3,91 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1322/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1322/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 20'
printf, lun, '  Time 2008:12:12:13:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 84'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(10+1),indgen(83-54+1)+54]
num = [87,89,91,92,93,94]
ellipse_count = 0
for k=6,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1352/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=0,5 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1352/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 21'
printf, lun, '  Time 2008:12:12:14:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 92'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(11+1),indgen(91-55+1)+55]
ellipse_count = 0
for k=5,96 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1422/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1422/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 22'
printf, lun, '  Time 2008:12:12:14:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 88'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [indgen(9+1),indgen(87-55+1)+55]
num = [5,7]
ellipse_count = 0
for j=0,1 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,76 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=78,95 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining2/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 23'
printf, lun, '  Time 2008:12:12:16:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 75'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=9,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1649/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1649/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 24'
printf, lun, '  Time 2008:12:12:17:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 67'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,70 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 25'
printf, lun, '  Time 2008:12:12:18:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 79'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=5,5 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=7,12 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=14,85 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 26'
printf, lun, '  Time 2008:12:12:18:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 83'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=7,7 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=91,91 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 27'
printf, lun, '  Time 2008:12:12:19:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 93'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,3 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=7,9 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=11,96 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=98,100 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 28'
printf, lun, '  Time 2008:12:12:20:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 95'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,3 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,94 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=96,100 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 29'
printf, lun, '  Time 2008:12:12:20:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 88'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0]
ellipse_count = 0
for k=1,1 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,87 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=89,92 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 30'
printf, lun, '  Time 2008:12:12:21:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 84'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,75,78,80,81,82,83]
ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,80 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=82,86 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=88,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 31'
printf, lun, '  Time 2008:12:12:22:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 89'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,1,2,3,5,7,82,84,87,88]
ellipse_count = 0
for k=9,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=91,95 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=97,97 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=99,100 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 32'
printf, lun, '  Time 2008:12:12:22:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 88'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,1,2,3,6,indgen(87-81+1)+81]
num=[1,2,3,5,7,85,86,88,89,90,91,92,94]
ellipse_count = 0
for j=0,4 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=5,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 33'
printf, lun, '  Time 2008:12:12:23:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 92'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,1,2,3,4,7,81,83,indgen(91-85+1)+85]
num=[4,5,7,9,95,96,97,98,99,100]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=12,93 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,9 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 34'
printf, lun, '  Time 2008:12:13:00:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 90'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,1,2,3,79,82,83,85,86,87,88,89]
num=[2,7,9,10,89,90,91,92,93,94,95,96,98,99,100]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=12,86 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,14 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 35'
printf, lun, '  Time 2008:12:13:00:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 85'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,2,69,71,73,indgen(84-75+1)+75]
num=[2,5,6,7,84,85,86,88,89,90,91]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,82 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,10 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'Frame 36'
printf, lun, '  Time 2008:12:13:01:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 87'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

constrained = [0,75,77,80,81,82,83,84,85,86]
num=[1,3,4,7,8,10,11,13,14,15,16,17,18,19,87,88,89,91,92,93,95,99]
ellipse_count = 0
for j=0,13 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=21,85 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=14,21 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_constrained_file.txt',/append
	if where(constrained eq ellipse_count) ne [-1] then begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)+' constrained'
	endif else begin
		printf, lun, '  Ellipse '+int2str(ellipse_count)
	endelse
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor



openu, lun, '3dfront_constrained_file.txt', /append
printf, lun, 'EndOfFile'
free_lun, lun


end
