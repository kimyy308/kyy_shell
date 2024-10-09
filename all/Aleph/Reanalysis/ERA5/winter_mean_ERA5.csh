#!/bin/csh
####!/bin/csh -fx
# Updated  20-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2021
set eiy = 1950
set var = msl

set region1 = NAOA
set xs1 = -28
set xe1 = -20
set ys1 = 36
set ye1 = 40
set region2 = NAOI
set xs2 = -25
set xe2 = -16
set ys2 = 63
set ye2 = 70



set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  @ nexty = ${iyloop} + 1
  set INITY = ${iyloop}
  setenv ERA5_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam/winter
  setenv SAVE_R1_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam/winter/${region1}
  setenv SAVE_R2_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam/winter/${region2}
 
  mkdir -p $SAVE_ROOT
  mkdir -p $SAVE_R1_ROOT
  mkdir -p $SAVE_R2_ROOT
    set input_dec=${ERA5_ROOT}/ERA5_${var}_reg_cesm2.${iyloop}12.nc
    set input_jan=${ERA5_ROOT}/ERA5_${var}_reg_cesm2.${nexty}01.nc
    set input_feb=${ERA5_ROOT}/ERA5_${var}_reg_cesm2.${nexty}02.nc
    set input_mar=${ERA5_ROOT}/ERA5_${var}_reg_cesm2.${nexty}03.nc

    set outputname=${SAVE_ROOT}/ERA5_${var}_reg_cesm2.${iyloop}-djfm.nc
    set outputname1=${SAVE_R1_ROOT}/${region1}_ERA5_${var}_reg_cesm2.${iyloop}-djfm.nc
    set outputname1_m=${SAVE_R1_ROOT}/M_${region1}_ERA5_${var}_reg_cesm2.${iyloop}-djfm.nc
    set outputname2=${SAVE_R2_ROOT}/${region2}_ERA5_${var}_reg_cesm2.${iyloop}-djfm.nc
    set outputname2_m=${SAVE_R2_ROOT}/M_${region2}_ERA5_${var}_reg_cesm2.${iyloop}-djfm.nc
#    echo "cdo -O fldmean "${input_set} ${outputname}
    cdo -O -w -z zip_5 ensmean ${input_dec} ${input_jan} ${input_feb} ${input_mar} ${outputname} 

    cdo -O -w -z zip_5 -sellonlatbox,${xs1},${xe1},${ys1},${ye1} ${outputname} ${outputname1}
    cdo -O -w -z zip_5 -fldmean ${outputname1} ${outputname1_m}
    cdo -O -w -z zip_5 -sellonlatbox,${xs2},${xe2},${ys2},${ye2} ${outputname} ${outputname2}
    cdo -O -w -z zip_5 -fldmean ${outputname2} ${outputname2_m}
end


