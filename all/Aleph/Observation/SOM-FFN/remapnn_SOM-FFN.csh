#!/bin/csh
####!/bin/csh -fx
# Updated  30-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set siy = 2020
#set eiy = 1993
set siy = 2021
set eiy = 1982

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv CMEMS_ROOT /mnt/lustre/proj/kimyy/Observation/SOM-FFN
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/SOM-FFN/monthly_reg_pop
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set gridfile = ${SAVE_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc # for atm
    set gridfile = ${SAVE_ROOT}/ocn_cesm2_grid.nc
    set input = ${CMEMS_ROOT}/time_mod3_MPI_SOM-FFN_v2023_NCEI_OCADS.nc 
#    set input = ${CMEMS_ROOT}/dt_global_allsat_msla_h_y${iyloop}_m${mon}.nc 
    set output = ${SAVE_ROOT}/SOM-FFN_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_SOM.nc	
    cdo -O remapnn,${gridfile} /proj/kimyy/tmp/test_SOM.nc ${output}
  end
end
rm -f /proj/kimyy/tmp/test_SOM.nc

