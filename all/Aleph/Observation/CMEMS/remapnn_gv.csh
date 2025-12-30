#!/bin/csh
####!/bin/csh -fx
# Updated  09-Jan-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set siy = 2022
set eiy = 1993
#set siy = 2017
#set eiy = 2017

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv CMEMS_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GLOBCURRENT
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GLOBCURRENT/monthly_reg_pop/gv
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = /mnt/lustre/proj/kimyy/Observation/CMEMS/ocn_grid.nc
    set input = ${CMEMS_ROOT}/${INITY}/GLob_Vel_${iyloop}-${mon}.nc 
    set output = ${SAVE_ROOT}/CMEMS_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O remapnn,${gridfile} ${input} ${output}
    echo ${output}
  end
end


