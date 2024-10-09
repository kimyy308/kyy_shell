#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set siy = 2022
#set eiy = 2022
set siy = 2021
set eiy = 1950
set var = SST

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv ERSST_ROOT /mnt/lustre/proj/kimyy/Observation/ERSST/monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/ERSST/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${ERSST_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${ERSST_ROOT}/ersst.v5.${iyloop}${mon}.nc 
    set output = ${SAVE_ROOT}/ersst_reg_cesm2.v5.${iyloop}${mon}.nc 
    cdo -O remapbil,${gridfile} ${input} ${output}
  end
end


