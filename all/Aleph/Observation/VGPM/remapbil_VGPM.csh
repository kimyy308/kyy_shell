#!/bin/csh
####!/bin/csh -fx
# Updated  24-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set siy = 2020
set eiy = 2003

set VGPM_SET = ( s_vgpm e_vgpm cbpm )

foreach VGPM_name ( ${VGPM_SET} )

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv VGPM_ROOT /Volumes/kyy_raid/kimyy/Observation/VGPM/netcdf/${VGPM_name}
  setenv SAVE_ROOT /Volumes/kyy_raid/kimyy/Observation/VGPM/netcdf_regrid/${VGPM_name}
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set gridfile = ${SAVE_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc # for atm
    set gridfile = /Volumes/kyy_raid/kimyy/Observation/OC_CCI/monthly_reg_pop/ocn_cesm2_grid.nc
    set input = ${VGPM_ROOT}/${VGPM_name}_${iyloop}${mon}.nc 
    set output = ${SAVE_ROOT}/${VGPM_name}_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    cdo -O remapnn,${gridfile} ${input} ${output}
  end
end

end
