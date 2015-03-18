; Created	2014-04-29	to download and prep STEREO data on my machines.

; INPUTS	- startdatetime	the starting date and time in format 'yyyy/mm/ddThh:mm'
;		- enddatetime	the ending date and time
;		- detector	the telescope 'cor1/2' etc.
;		- source	the spacecraft 'stereo_a/b'


pro download_prep_stereo, startdatetime, enddatetime, detector, source

date_range = startdatetime+'-'+enddatetime

data = vso_search(date=date_range, inst='secchi', detector=detector, source=source, /url)

outdir = 'data_dl_'+detector+'_'+source
spawn, 'mkdir -p '+outdir

sock_copy, data.url, out_dir=outdir

sccingest, files=file_search(outdir+'/*')

spawn, 'mv -r '+outdir+' ~/.Trash'

; Create fits directory		
home = getenv('HOME')
fits_dir = home+'/Postdoc/Data_Stereo/'+strjoin(strsplit(strmid(enddatetime,0,10),'/',/extract))+'/fits'
spawn, 'mkdir -p '+fits_dir

spc = strmid(source,7)
out_fits = fits_dir+'/'+spc+'/'+detector
spawn, 'mkdir -p '+out_fits

case detector of
	'cor1': begin
		list = cor1_pbseries([startdatetime,enddatetime],spc)
		secchi_prep, list.filename, in, da, /polariz_on, /calroll, /interpolate, /write_fts, savepath=out_fits
		end
	'cor2': begin
		list = cor1_pbseries([startdatetime,enddatetime],spc,/cor2)
		secchi_prep, list.filename, in, da, /polariz_on, /calfac_off, /calimg_off, /write_fts, savepath=out_fits
		end
endcase

end
