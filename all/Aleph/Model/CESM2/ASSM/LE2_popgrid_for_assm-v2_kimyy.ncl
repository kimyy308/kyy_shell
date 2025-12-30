load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/popRemap.ncl"   

begin

  ; frun="b.e21.BHISTsmbb.f09_g17.LE2-1231.011"
  frun="b.e21.BSSP370smbb.f09_g17.LE2-1231.011"
  fdir="/mnt/lustre/proj/jedwards/archive/"+frun+"/ocn/proc/tseries/month_1/"
  fmdl = fdir+frun+".pop.h.VAR.*.nc"
  fnout="/mnt/lustre/proj/earth.system.predictability/OBS_DATA_kyy/POP2_g17_raw/LE2-1231.011/toso."
 

  ; ystr=1952
  ; yend=2014
  ystr=2015
  yend=2025

  ; -- Read DATA
  fall = systemfunc("ls "+str_sub_str(fmdl,"VAR","TEMP"))
  fin = addfiles(fall,"r")
  ListSetType (fin, "cat") 

  ;--- NEVER USE TIME COORDINATE from monthly dataset in CESM2 output
  ;; intime=fin[:]->time
  ;; intime = intime - 1
  ;; utc_date = ut_calendar(intime, 0)
  ;; udate = utc_date(:,0)*100+utc_date(:,1)

  ; odate=yyyymm_time(1850,2015,"integer")
  ; ist = (ystr-1850)*12+1 -1
  ; ied = (yend-1850)*12+12 -1
  odate=yyyymm_time(2015,2026,"integer")
  ist = (ystr-2015)*12+1 -1
  ied = (yend-2015)*12+12 -1
  print("Date from "+odate(ist)+" to "+odate(ied))

  
  mtime=fin[:]->time(ist:ied)
  z_t   = fin[0]->z_t
  TLAT  = fin[0]->TLAT
  TLONG = fin[0]->TLONG
  TEMP  = fin[:]->TEMP(ist:ied,:,:,:)
  
  delete(fin)

  ; -- Read Salinity
  fall = systemfunc("ls "+str_sub_str(fmdl,"VAR","SALT"))
  fin = addfiles(fall,"r")
  ListSetType (fin, "cat") 
  SALT  = fin[:]->SALT(ist:ied,:,:,:)

  delete(fin)

  printVarSummary(TEMP)
  printVarSummary(SALT)


  yyyymm=yyyymm_time(ystr,yend,"string")
  date=str_insert(yyyymm,"-",4)

  do it=0, dimsizes(date)-1
     irec=ist+it

     fnmout=fnout+date(it)+".nc"
     print("  make file : "+fnmout)
     system(" rm -f "+fnmout)
     fout=addfile(fnmout,"c")

     TERR=TEMP(0,:,:,:)
     SERR=SALT(0,:,:,:)
     TERR=1.0
     SERR=1.0

     fout->time=mtime(it)
     fout->z_t=z_t
     fout->TLAT=TLAT
     fout->TLONG=TLONG
     fout->TEMP=TEMP(it,:,:,:)
     fout->TERR=TERR
     fout->SALT=SALT(it,:,:,:)
     fout->SERR=SERR

     delete(fout)
     delete(TERR)
     delete(SERR)
  end do

end

