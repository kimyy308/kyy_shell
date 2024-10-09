#!/bin/csh
####!/bin/csh -fx
# Updated  30-Apr-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set siy = 2020
#set eiy = 1993
set siy = 2020
set eiy = 1960

set var = temperature # temperature , salinity

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv IAP_ROOT /mnt/lustre/proj/kimyy/Observation/IAP/${var}
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/IAP/monthly_reg_pop/${var}
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set gridfile = ${SAVE_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc # for atm
    set gridfile = ${SAVE_ROOT}/ocn_cesm2_grid.nc
    set input = ${IAP_ROOT}/IAPv4_Temp_monthly_1_6000m_year_${iyloop}_month_${mon}.nc 
    set output = ${SAVE_ROOT}/IAP_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    cdo -O remapnn,${gridfile} ${input} ${output}
  end
end


