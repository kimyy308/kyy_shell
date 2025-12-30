#!/bin/csh
####!/bin/csh -fx
# Updated  09-May-2025 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr
# for ORAS5


set siy = 2024
set eiy = 1958
#set siy = 2017
#set eiy = 2017

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv CMEMS_ROOT /mnt/lustre/proj/kimyy/Observation/ORAS5/mixed_layer_depth_0_03_p/raw_monthly
#  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GlobColour/monthly_reg_5deg/PP
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/ORAS5/mixed_layer_depth_0_03_p/monthly_reg_pop
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = /mnt/lustre/proj/kimyy/Observation/CMEMS/ocn_grid.nc
    set input = ${CMEMS_ROOT}/ORAS5_mixed_layer_depth_0_03_${iyloop}${mon}.nc 
    set output = ${SAVE_ROOT}/CMEMS_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    cdo -O remapnn,${gridfile} ${input} ${output}
#    cdo -O remapnn,r72x36 ${input} ${output}
    echo ${output}
  end
end


