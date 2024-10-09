#!/bin/csh
####!/bin/csh -fx
# Updated  09-Jan-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set siy = 2021
set eiy = 1998
#set siy = 2017
#set eiy = 2017

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv CMEMS_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GlobColour/PP
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GlobColour/monthly_reg_5deg/PP
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set gridfile = ${SAVE_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc # for atm
    #set gridfile = ${SAVE_ROOT}/../../../monthly_reg_pop/ocn_cesm2_grid.nc
    set gridfile = ${SAVE_ROOT}/../../../monthly_reg_pop/mygrid
    set input = ${CMEMS_ROOT}/${INITY}/${iyloop}-${mon}.nc 
    set output = ${SAVE_ROOT}/CMEMS_reg_5deg.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    #cdo -O remapnn,${gridfile} ${input} ${output}
    cdo -O remapnn,r72x36 ${input} ${output}
    echo ${output}
  end
end


