#!/bin/csh
# Updated 23-Jan-2022 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

module load cdo



set DROOT='/mnt/lustre/proj/kimyy/Model/CMIP/CMIP6'

set scen='historical'
set scen2='ssp585'
#set var='uas'
set var='vas'
#set model='CESM2'
#set ens='r1i1p1f1'
#set grid='gn'

#set scens=(`ls ${DROOT}/`)
#echo $scens
#set cmor=`ls ${DROOT}/${scen}/${var}`
set cmor='Gobi_reg'
set models=(`ls ${DROOT}/${scen}/${var}/${cmor}/`)
foreach model ( ${models} )
#  echo $model
  set sspdir=${DROOT}/${scen2}/${var}/${cmor}/${model}
#  echo $sspdir
  if ( -d ${sspdir} ) then
    set ens=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}`)
    set ens2=(`ls ${DROOT}/${scen2}/${var}/${cmor}/${model}`)
    set gr=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}/${ens}`)
    set gr2=(`ls ${DROOT}/${scen2}/${var}/${cmor}/${model}/${ens2}`)
    set files=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}/${ens}/${gr}/${var}*nc`)
    set files2=(`ls ${DROOT}/${scen2}/${var}/${cmor}/${model}/${ens2}/${gr2}/${var}*nc`)
  #set cmor2='NA_reg'
    echo $files
    echo $files2
    set saved=${DROOT}'_analysis'/${var}/${cmor}
    mkdir -p $saved
    set file_new=${saved}/${var}'_'${cmor}'_'${model}'_195001-210012.nc'
#    echo $file_new
#     sleep 1s
     cdo -O mergetime $files $files2 ~/test.nc
     cdo -O selyear,1950/2100 ~/test.nc $file_new
#    set model3=`echo $model | cut -c 1-3`
#    cdo remapbil,global_1 ${file} ~/test.nc
#    cdo sellonlatbox,-60,0,30,90 ~/test.nc $file_new
  endif
end

#ls $DROOT/$scen/$var/$cmor/$model/*/*/*tos*nc

#tos_Omon_TaiESM1_ssp585_r1i1p1f1_gn_210001-210012.nc
