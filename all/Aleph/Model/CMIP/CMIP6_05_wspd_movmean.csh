#!/bin/csh
# Updated 27-Jan-2022 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

module load cdo

set DROOT='/mnt/lustre/proj/kimyy/Model/CMIP/CMIP6_analysis'

set var='wspd'
set mon=4
set monstr='apr'
set cmor='Gobi_reg'
set mondir=${DROOT}/${var}/${cmor}/${monstr}
set runm_win=9
cd ${mondir}
#set files=(`ls ${DROOT}/${var}/${cmor}/${mondir}/`)
set files=(`ls *nc`)
foreach file ( ${files} )
  set model=`echo ${file} | cut -d '_' -f 4`
  set file_nc_new=`echo $file | sed "s/${var}/runm_${var}/g"`
#  set file_new=`echo $file | sed "s/${cmor}/${cmor2}/g"`
#  mkdir -p ${mondir}
  mkdir -p ${mondir}/runmean_${runm_win}
  set file_new=${mondir}/runmean_${runm_win}/${file_nc_new}
#  set file_new=${mondir}/${var}'_'${cmor}'_'${model}'_'${monstr}'.nc'
    cdo -O runmean,${runm_win} ${file} ${file_new}
#  echo ${file_new}
end

#ls $DROOT/$scen/$var/$cmor/$model/*/*/*tos*nc

#tos_Omon_TaiESM1_ssp585_r1i1p1f1_gn_210001-210012.nc
