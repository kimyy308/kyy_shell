#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2016
set eiy = 1982
set var = GPP
#precip
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv ORNL_DAAC_ROOT /mnt/lustre/proj/kimyy/Observation/ORNL_DAAC/
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/ORNL_DAAC/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = /mnt/lustre/proj/kimyy/Observation/GPCC/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${ORNL_DAAC_ROOT}/gross_primary_productivity_monthly_1982-2016.nc4 
    set output = ${SAVE_ROOT}/ORNL_DAAC_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_ORNL_DAAC.nc
    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_ORNL_DAAC.nc ${output}
  end
end
rm -f /proj/kimyy/tmp/test_ORNL_DAAC.nc

