#!/bin/csh
####!/bin/csh -fx
# Updated  24-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set siy = 2020
set eiy = 2003

set VGPM_SET = ( s_vgpm e_vgpm cbpm )


set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv VGPM_ROOT /Volumes/kyy_raid/kimyy/Observation/VGPM/netcdf_regrid/
  setenv SAVE_ROOT /Volumes/kyy_raid/kimyy/Observation/VGPM/netcdf_regrid/ensmean
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = /Volumes/kyy_raid/kimyy/Observation/OC_CCI/monthly_reg_pop/ocn_cesm2_grid.nc
    set input1 = ${VGPM_ROOT}/${VGPM_SET[1]}/${VGPM_SET[1]}_reg_cesm2.${iyloop}${mon}.nc 
    set input2 = ${VGPM_ROOT}/${VGPM_SET[2]}/${VGPM_SET[2]}_reg_cesm2.${iyloop}${mon}.nc 
    set input3 = ${VGPM_ROOT}/${VGPM_SET[3]}/${VGPM_SET[3]}_reg_cesm2.${iyloop}${mon}.nc 
    set output = ${SAVE_ROOT}/ensmean_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O ensmean ${input1} ${input2} ${input3} ${output}
  end
end

