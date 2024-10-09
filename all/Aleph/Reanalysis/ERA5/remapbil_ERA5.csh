#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2022
set eiy = 1950
#set var = msl
set var = t2m

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv ERA5_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = ${ERA5_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
    @ tind = `expr \( ${INITY} - 1950 \) \* 12`
    @ tind2 = $tind + $mon
    set input = ${ERA5_ROOT}/ERA5_${var}_monthly_1950_2022.nc 
    set temp1 = ${ERA5_ROOT}/temp1.nc
    set output = ${SAVE_ROOT}/ERA5_${var}_reg_cesm2.${iyloop}${mon}.nc
    cdo -O -w -seltimestep,$tind2 $input $temp1 
    cdo -O -w -z zip_5 remapbil,${gridfile} ${temp1} ${output}
  end
end
rm -f $temp1

