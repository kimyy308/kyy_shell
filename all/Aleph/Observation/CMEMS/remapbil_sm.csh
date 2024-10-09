#!/bin/csh
####!/bin/csh -fx
# Updated  07-Sep-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2022
set eiy = 1979
#precip
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv SM_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/SOIL_MOISTURE/COMBINED
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/SOIL_MOISTURE/COMBINED/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${SM_ROOT}/cam_grid.nc
    set input = ${SM_ROOT}/C3S-SOILMOISTURE-L3S-SSMV-COMBINED-MONTHLY-${iyloop}${mon}01000000-TCDR-v202012.0.0.nc
    set output = ${SAVE_ROOT}/SM_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O remapbil,${gridfile} ${input} ${output}
  end
end

