#!/bin/csh
# Updated 23-Jan-2022 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

module load cdo

set DROOT='/mnt/lustre/proj/kimyy/Model/CMIP/CMIP6_analysis'

set var='wspd'
set mon=4
set monstr='apr'
set cmor='Gobi_reg'
set files=(`ls ${DROOT}/${var}/${cmor}/`)
cd ${DROOT}/${var}/${cmor}
foreach file ( ${files} )
  set model=`echo ${file} | cut -d '_' -f 4`
  set mondir=${DROOT}/${var}/${cmor}/${monstr}
  mkdir -p ${mondir}
  set file_new=${mondir}/${var}'_'${cmor}'_'${model}'_'${monstr}'.nc'
  set tlen=`ncdump ${file} -h | grep UNLIMITED | cut -d '(' -f 2 | cut -d ' ' -f 1`
  if ( ${tlen} == 1812 ) then
    cdo -O selmon,${mon} ${file} ~/test.nc
    #cdo -O -sellonlatbox,90,112,40,45.5 ~/test.nc ~/test2.nc # region 1
    cdo -O -sellonlatbox,90,110,40,45 ~/test.nc ~/test2.nc  # region 2
    cdo -O -fldmean ~/test2.nc ${file_new}
  endif
end

#ls $DROOT/$scen/$var/$cmor/$model/*/*/*tos*nc

#tos_Omon_TaiESM1_ssp585_r1i1p1f1_gn_210001-210012.nc
