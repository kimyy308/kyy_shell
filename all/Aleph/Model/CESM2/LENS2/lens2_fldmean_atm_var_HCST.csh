#!/bin/csh
####!/bin/csh -fx
# Updated  15-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST

set RESOLN = f09_g17
set siy = 2025
set eiy = 2025
#set siy = 2024
#set eiy = 2021
set var = SST
#set var = PRECT
#set var = TS
#set var = PSL

#set region = GLO
#set xs = -180
#set xe = 180
#set ys = -90
#set yn = 90
set region = NINO34
set xs = -170
set xe = -120
set ys = -5
set yn = 5
#set region = IODw
#set xs = 50
#set xe = 70
#set ys = -10
#set yn = 10
#set region = IODe
#set xs = 90
#set xe = 110
#set ys = -10
#set yn = 0
#set region = TBVAI
#set xs = -40
#set xe = 60
#set ys = -15
#set yn = 15
#set region = TBVCP
#set xs = -180
#set xe = -150
#set ys = -15
#set yn = 15
#set region = AZM
#set xs = -20
#set xe = 10
#set ys = -5
#set yn = 3
#set region = AMM
#set xs = -74
#set xe = 15
#set ys = -21
#set yn = 32
#set region = NAOA
#set xs = -28
#set xe = -20
#set ys = 36
#set yn = 40
#set region = NAOI
#set xs = -25
#set xe = -16
#set ys = 63
#set yn = 70


set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv ARC_ROOT /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/atm/${var}/ens_all
  setenv SAVE_ROOT /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/atm/${var}/ens_all/${region}
 
 # set outputnc_new=(`echo ${outputnc} | sed "s/${RESOLN}/${var}_${RESOLN}/g"`)
 
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
    set inputname=${ARC_ROOT}/${var}_ensmean_${iyloop}-${mon}.nc
    set outputname1=${SAVE_ROOT}/${region}_${var}_ensmean_${iyloop}-${mon}.nc
    set outputname2=${SAVE_ROOT}/M_${region}_${var}_ensmean_${iyloop}-${mon}.nc
#    echo "cdo -O fldmean "${input_set} ${outputname}
    cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${inputname} ~/test.nc
    cdo -O setmissval,0 ~/test.nc ${outputname1}
    cdo -O fldmean ${outputname1} ${outputname2}
  end
end

rm -f ~/test.nc
