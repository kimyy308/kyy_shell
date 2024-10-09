#!/bin/csh

#set mon = feb
set mon = mar
set tosdir = /Volumes/kyy_raid/kimyy/Model/CMIP/CMIP6_analysis/tos/NA_reg/${mon}/runmean_9
set wspddir = /Volumes/kyy_raid/kimyy/Model/CMIP/CMIP6_analysis/wspd/Gobi_reg/apr/runmean_9

set tosmodels = (`ls ${tosdir}/*.nc | cut -d '_' -f 9`)
set wspdmodels = (`ls ${wspddir}/*.nc | cut -d '_' -f 9`)

foreach tmodel ($tosmodels)
  set tosfile = ${tosdir}/runm_tos_NA_reg_${tmodel}_${mon}.nc
  set wspdfile = ${wspddir}/runm_wspd_Gobi_reg_${tmodel}_apr.nc
  echo ${wspdfile}  
  if ( -f ${wspdfile} ) then
    mkdir -p ${tosdir}/duplicated
    mkdir -p ${wspddir}/duplicated
    cp ${tosfile} ${tosdir}/duplicated/ 
    cp ${wspdfile} ${wspddir}/duplicated/ 
  endif
end
