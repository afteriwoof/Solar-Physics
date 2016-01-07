pro get_lasco_data_jpb, tstart, tend, test=test

cd,'.',curr=currdir
;j;savedir=getenv('SOHO_DATA')+'/lasco/lz/level_05'
savedir='/home/gail/jbyrne/lasco/lz/level_05'

com=wget()


goto,skipstart
print,'Checking directories...'
dirs=getfilenames_corimp(savedir,'*',/silent)
dirs=dirs[where(is_dir(dirs))]
days=file_basename(dirs)
yrcheck=strmid(days,0,1)
ind=where(yrcheck eq '9',comp=nind)
days[ind]='19'+days[ind]
days[nind]='20'+days[nind]
days=strmid(days,0,4)+'/'+strmid(days,4,2)+'/'+strmid(days,6,2)+' 00:00'
t=anytim2tai(days)
;void=max(t,ind)
;tstart=days[ind]
skipstart:

if n_elements(tstart) eq 0 then begin
  tstart='2010/08/01'
  tend='2011/07/01';+systime2yymmdd()
endif
tstart=anytim2cal(tstart,form=11,/date)
tend=anytim2cal(tend,form=11,/date)
dates=anytim2cal(timegrid(tstart,tend,/days,/str),form=8,/date)
dirs=strmid(dates,2,6)
ndates=n_elements(dates)

local=savedir+'/'+dirs
;remote='http://lasco-www.nrl.navy.mil/lz/level_05/'+dirs
remote='ftp://sohoftp.nascom.nasa.gov/qkl/lasco/quicklook/level_05/'+dirs
for idate=0,ndates-1 do begin
  for iinst=0,1 do begin
    inst=iinst eq 0?'c2':'c3'
    
    localnow=local[idate]+'/'+inst
    remotenow=remote[idate]+'/'+inst
    
    print,localnow
    
    if not(file_exist(local[idate])) then begin
      print,'Creating directory ',local[idate]
      spawn,'mkdir '+local[idate]
    endif
    if not(file_exist(localnow)) then begin
      print,'Creating directory ',localnow
      spawn,'mkdir '+localnow
    endif
    
    cd,localnow
    
    thisoneagain:
    
    if ~file_exist(localnow+'/img_hdr.txt') then begin
      print,'Wgetting img hdr'
      spawn,com+' '+' -r -l1 --no-parent  -N -nd -erobots=off '+remotenow+'/img_hdr.txt'
    endif
    
    if ~file_exist(localnow+'/img_hdr.txt') then begin
      print,'Img hdr file does not exist: ',localnow+'/img_hdr.txt'
      ;stop
      goto,skipthisone
    endif
    
    nl=file_lines(localnow+'/img_hdr.txt')
    openr,lun,localnow+'/img_hdr.txt',/get_lun
    str=''
    for j=0,nl-1 do begin
      readf,lun,str
      str2=(strsplit(str,' ',/extract))(0)
      if j eq 0 then dateimghdr=(strsplit(str,' ',/extract))(1)
      str2=strlowcase(strcompress(str2,/remove_all))
      if strmatch(str2,'*.fts') ne 0 then $
      build_loop_array,str2,files,reset=j eq 0
    endfor
    free_lun,lun
    
    dateimghdr=anytim2cal(dateimghdr,form=8,/date)
    if dateimghdr ne dates[idate] then begin
      print,'Problem with image header: date does not match!!!'
      print,'Deleting img_hdr, and sorting directory from scratch'
      spawn,'rm '+localnow+'/img_hdr.txt'
      goto,thisoneagain
    endif
    
    f=getfilenames_corimp(localnow,'*.fts',cnt=cntloc,/silent)
    fgz=getfilenames_corimp(localnow,'*.fts.gz',cnt=cntlocgz,/silent)
    for i=0,cntloc-1 do begin
      s=total(strmatch(files,file_basename(f[i])))
      sgz=total(strmatch(file_basename(fgz,'.gz'),file_basename(f[i])))
      if s eq 0 or sgz eq 1 then begin
        print,'Deleting due not on img hdr list, or gzipped file exists: '+f[i],s,sgz
        spawn,'rm '+f[i]
      endif
    endfor
    f=getfilenames_corimp(localnow,'*.fts.gz',cnt=cntloc,/silent)
    for i=0,cntloc-1 do begin
      s=total(strmatch(files,file_basename(f[i],'.gz')))
      if s eq 0 then begin
        print,'Deleting due not on img hdr list: '+f[i]
        spawn,'rm '+f[i]
      endif
    endfor
    
    for i=0,n_elements(files)-1 do begin
      if ~file_exist(localnow+'/'+files[i]) and $
          ~file_exist(localnow+'/'+files[i]+'.gz') then begin
          print,'Wgetting '+remotenow+'/'+files[i]
          spawn,com+' '+' -r -l1 --no-parent -nd -m -N -erobots=off '+remotenow+'/'+files[i]
      endif 
    endfor
     
    f=getfilenames_corimp(localnow,'*.fts',cnt=cntnogz,/silent)
    if cntnogz gt 0 then begin
      for i=0,cntnogz-1 do begin
        print,'Gzipping '+f[i]
        spawn,'gzip '+f[i]
      endfor
    endif
  
  skipthisone:
    
  endfor;iinst
endfor;idate


cd,currdir

end

