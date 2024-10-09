#!/bin/csh
####!/bin/csh -fx
# Updated  10-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 1969
set eiy = 1960
set var = TS
#tas_mean
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv HadCRUT5_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${HadCRUT5_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    set input = ${HadCRUT5_ROOT}/tas_mean.selvar.mon.mean.nc 
    set output = ${SAVE_ROOT}/HadCRUT5_reg_cesm2.${iyloop}${mon}.nc 
    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_HadCRUT5.nc
    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_HadCRUT5.nc ${output}
  end
end
rm -f /proj/kimyy/tmp/test_HadCRUT5.nc

