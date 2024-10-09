#!/bin/csh
# Updated 23-Jan-2022 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

module load cdo



set DROOT='/mnt/lustre/proj/kimyy/Model/CMIP/CMIP6_analysis'

set scen='historical'
set scen2='ssp585'
set uvar='uas'
set vvar='vas'
set wspd='wspd'
#set cmor='NA_reg'
set cmor='Gobi_reg'
set umodels=(`ls ${DROOT}/${uvar}/${cmor}/ | cut -d '_' -f 4`)
foreach umodel ( ${umodels} )
  set vvarfile=${DROOT}/${vvar}/${cmor}/${vvar}_${cmor}_${umodel}_195001-210012.nc
  set uvarfile=${DROOT}/${uvar}/${cmor}/${uvar}_${cmor}_${umodel}_195001-210012.nc
  
  if ( -f ${vvarfile} ) then
#    set ens=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}`)
#    set ens2=(`ls ${DROOT}/${scen2}/${var}/${cmor}/${model}`)
#    set gr=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}/${ens}`)
#    set gr2=(`ls ${DROOT}/${scen2}/${var}/${cmor}/${model}/${ens2}`)
#    set files=(`ls ${DROOT}/${scen}/${var}/${cmor}/${model}/${ens}/${gr}/${var}*nc`)
#    set files2=(`ls ${DROOT}/${scen2}/${var}/${cmor}/${model}/${ens2}/${gr2}/${var}*nc`)
#    echo $files
#    echo $files2
    set saved=${DROOT}/${wspd}/${cmor}
    mkdir -p $saved
    set file_new=${saved}/${wspd}'_'${cmor}'_'${umodel}'_195001-210012.nc'
     #cdo chname,uas,ws -sqrt -add -sqr -selname,${uvar} ${uvarfile} -sqr -selname,${vvar} ${vvarfile} ${file_new}
     cdo -sqr ${uvarfile} ${saved}/test_usq.nc
     cdo -sqr ${vvarfile} ${saved}/test_vsq.nc
     cdo -L -sqrt -add ${saved}/test_usq.nc ${saved}/test_vsq.nc ${saved}/test_wspd.nc
     cdo -chname,'uas','wspd'  ${saved}/test_wspd.nc ${file_new}
  endif
end
rm -f ${saved}/test_usq.nc
rm -f ${saved}/test_vsq.nc
rm -f ${saved}/test_wspd.nc


