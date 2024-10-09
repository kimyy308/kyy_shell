#!/bin/csh
####!/bin/csh -fx
# Updated  12-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2022
set eiy = 1997

#precip

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv FIRE_CLOSS_ROOT /mnt/lustre/proj/iwkimi/GFED4_1/NC4/emission
  setenv grid_ROOT /mnt/lustre/proj/kimyy/Observation/GFED/TSW/
  setenv SAVE_monthly_ROOT /mnt/lustre/proj/kimyy/Observation/GFED/FIRE_CLOSS/monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/GFED/FIRE_CLOSS/monthly_reg_cam
  mkdir -p $SAVE_monthly_ROOT
  mkdir -p $SAVE_ROOT
  set gridfile = ${grid_ROOT}//SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
  set input = ${FIRE_CLOSS_ROOT}/GFED4.1s_${INITY}.nc 

  set output1 = ${SAVE_monthly_ROOT}/FIRE_CLOSS_monthly.${iyloop}.nc 
  cdo -w -z zip_5 -monmean ${input} ${output1}

  foreach mon ( ${M_SET} )
    set output2 = ${SAVE_ROOT}/FIRE_CLOSS_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${output1} /proj/kimyy/tmp/test_FIRE_CLOSS.nc
    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_FIRE_CLOSS.nc ${output2}
  end
end
rm -f /proj/kimyy/tmp/test_FIRE_CLOSS.nc

