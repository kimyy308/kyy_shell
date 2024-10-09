#!/bin/csh
# Updated 19-Jan-2022 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

module load cdo
set DROOT='/mnt/lustre/proj/kimyy/Model/CMIP/CMIP6'

#set scen='historical'
set var='tos'
#set var='uas'
set cmor='Omon'
#set model='CESM2'
#set ens='r1i1p1f1'
#set grid='gn'

set scens=(`ls ${DROOT}/`)
#echo $scens
foreach scen ( ${scens} )
#  set cmor=`ls ${DROOT}/${scen}/${var}`
  set models=(`ls ${DROOT}/${scen}/${var}/${cmor}/`)
  foreach model ( ${models} )
    echo $model
    set ens=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}`)
    set gn=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}/${ens}`)
    set files=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}/${ens}/${gn}/${var}*nc`)
#    echo $files
    set cmor2='NA_reg'
    set saved=${DROOT}/${scen}/${var}/${cmor2}/${model}/${ens}/${gn}/
    mkdir -p $saved
    foreach file ( ${files} )
      set file_new=`echo $file | sed "s/${cmor}/${cmor2}/g"`
      echo $file_new
#      sleep 1s
      set model3=`echo $model | cut -c 1-3`
      if ( ${model3} == "AWI" ) then
        cdo -O remapycon,global_1 ${file} ~/test.nc        
      else
        cdo -O remapbil,global_1 ${file} ~/test.nc
      endif
      cdo -O sellonlatbox,-60,0,30,90 ~/test.nc $file_new
    end
  end
end
#ls $DROOT/$scen/$var/$cmor/$model/*/*/*tos*nc

#tos_Omon_TaiESM1_ssp585_r1i1p1f1_gn_210001-210012.nc
