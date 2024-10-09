#!/bin/csh
####!/bin/csh -fx
# Updated  20-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set siy = 2022
set eiy = 1950
#set var = msl
set var = t2m

set region = GLO
set xs = -180
set xe = 180
set ys = -90
set ye = 90
#set region = NINO34
#set xs = -170
#set xe = -120
#set ys = -5
#set ye = 5
#set region = IODw
#set xs = 50
#set xe = 70
#set ys = -10
#set ye = 10
#set region = IODe
#set xs = 90
#set xe = 110
#set ys = -10
#set ye = 0
#set region = TBVAI
#set xs = -40
#set xe = 60
#set ys = -15
#set ye = 15
#set region = TBVCP
#set xs = -180
#set xe = -150
#set ys = -15
#set ye = 15
#set region = AZM
#set xs = -20
#set xe = 10
#set ys = -5
#set ye = 3
#set region = AMM
#set xs = -74
#set xe = 15
#set ys = -21
#set ye = 32
#set region = NAOA
#set xs = -28
#set xe = -20
#set ys = 36
#set ye = 40
#set region = NAOI
#set xs = -25
#set xe = -16
#set ys = 63
#set ye = 70



set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv ERA5_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Reanalysis/ERA5/${var}/monthly_reg_cam/${region}
 
 # set outputnc_new=(`echo ${outputnc} | sed "s/${RESOLN}/${var}_${RESOLN}/g"`)
 
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
    set inputname=${ERA5_ROOT}/ERA5_${var}_reg_cesm2.${iyloop}${mon}.nc
    set outputname1=${SAVE_ROOT}/${region}_ERA5_${var}_reg_cesm2.${iyloop}${mon}.nc
    set outputname2=${SAVE_ROOT}/M_${region}_ERA5_${var}_reg_cesm2.${iyloop}${mon}.nc
#    echo "cdo -O fldmean "${input_set} ${outputname}
    cdo -O -sellonlatbox,${xs},${xe},${ys},${ye} ${inputname} ${outputname1}
#    cdo -O -sellonlatbox,${xs},${xe},${ys},${ye} ${inputname} ~/test_ERA5.nc
#    cdo -O setmissval,0 ~/test_ERA5.nc ${outputname1}
    cdo -O fldmean ${outputname1} ${outputname2}
  end
end


