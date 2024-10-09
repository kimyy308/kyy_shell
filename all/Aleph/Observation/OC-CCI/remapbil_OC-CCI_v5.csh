#!/bin/csh
####!/bin/csh -fx
# Updated  30-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set siy = 2021
set eiy = 1998

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv OC_CCI_ROOT /proj/daewon/OC-CCI/ftp.rsg.pml.ac.uk/occci-v6.0/geographic/netcdf/monthly/chlor_a
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/OC_CCI/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set gridfile = ${SAVE_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc # for atm
    set gridfile = ${SAVE_ROOT}/ocn_cesm2_grid.nc
    set input = ${OC_CCI_ROOT}/${INITY}/ESACCI-OC-L3S-CHLOR_A-MERGED-1M_MONTHLY_4km_GEO_PML_OCx-${iyloop}${mon}-fv6.0.nc 
    set output = ${SAVE_ROOT}/OC_CCI_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O remapbil,${gridfile} ${input} ${output}
    cdo -O remapnn,${gridfile} ${input} ${output}
  end
end


