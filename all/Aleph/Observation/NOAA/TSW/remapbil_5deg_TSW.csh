#!/bin/csh
####!/bin/csh -fx
# Updated  09-Jan-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2020
set eiy = 1950
#precip
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv TSW_ROOT /mnt/lustre/proj/kimyy/Observation/NOAA/TSW/
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/NOAA/TSW/monthly_reg_5deg
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${TSW_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${TSW_ROOT}/data.nc 
    set output = ${SAVE_ROOT}/TSW_reg_5deg.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_TSW.nc
    #cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_TSW.nc ${output}
    cdo -O remapbil,r72x36 /proj/kimyy/tmp/test_TSW.nc ${output}
  end
end
rm -f /proj/kimyy/tmp/test_TSW.nc

