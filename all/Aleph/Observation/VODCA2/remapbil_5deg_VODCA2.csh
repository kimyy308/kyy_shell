#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2019
set eiy = 1989
set var = PRECT
#precip
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv VODCA2GPP_ROOT /mnt/lustre/proj/kimyy/Observation/VODCA2GPP/
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/VODCA2GPP/monthly_reg_5deg
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = /mnt/lustre/proj/kimyy/Observation/GPCC/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${VODCA2GPP_ROOT}/VODCA2GPP_v1_monthly.nc 
    set output = ${SAVE_ROOT}/VODCA2GPP_reg_5deg.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_VODCA2GPP.nc
#    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_VODCA2GPP.nc ${output}
    cdo -O remapbil,r72x36 /proj/kimyy/tmp/test_VODCA2GPP.nc ${output}
  end
end
rm -f /proj/kimyy/tmp/test_VODCA2GPP.nc

