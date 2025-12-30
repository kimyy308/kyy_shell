#!/bin/csh
####!/bin/csh -fx
# Updated  19-Jan-2025 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set siy = 2020
#set eiy = 1993
set siy = 2020
set eiy = 1950

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
#  setenv ERSST_ROOT /proj/daewon/ERSST/monthly/
  setenv SAVE_CMEMS_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/sla/monthly_reg_pop
  setenv ERSST_ROOT /mnt/lustre/proj/kimyy/Observation/ERSST/monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/ERSST/monthly_reg_pop
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set gridfile = ${SAVE_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc # for atm
    set gridfile = ${SAVE_CMEMS_ROOT}/ocn_cesm2_grid.nc
#    set input = ${ERSST_ROOT}/${INITY}/dt_global_allsat_msla_h_y${iyloop}_m${mon}.nc 
    set input = ${ERSST_ROOT}/ersst.v5.${iyloop}${mon}.nc 
    set output = ${SAVE_ROOT}/ERSST_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    cdo -O remapnn,${gridfile} ${input} ${output}
  end
end


