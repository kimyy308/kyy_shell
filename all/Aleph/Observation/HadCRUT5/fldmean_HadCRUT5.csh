#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST

set siy = 1969
set eiy = 1960
set var = SST
#set siy = 1990
#set eiy = 1950
#set var = SST

set region = GLO
set xs = -180
set xe = 180
set ys = -90
set yn = 90
#set region = NINO34
#set xs = -170
#set xe = -120
#set ys = -5
#set yn = 5
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


set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv HadCRUT5_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/monthly_reg_cam
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/monthly_reg_cam/${region}
 
 # set outputnc_new=(`echo ${outputnc} | sed "s/${RESOLN}/${var}_${RESOLN}/g"`)
 
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
    set inputname=${HadCRUT5_ROOT}/HadCRUT5_reg_cesm2.${iyloop}${mon}.nc
    set outputname1=${SAVE_ROOT}/${region}_HadCRUT5_reg_cesm2.${iyloop}${mon}.nc
    set outputname2=${SAVE_ROOT}/M_${region}_HadCRUT5_reg_cesm2.${iyloop}${mon}.nc
#    echo "cdo -O fldmean "${input_set} ${outputname}
    cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${inputname} /proj/kimyy/tmp/test_HadCRUT5.nc
    #cdo -O setmissval,0 ~/test_HadCRUT5.nc ${outputname1}
    cdo -O fldmean /proj/kimyy/tmp/test_HadCRUT5.nc ${outputname2}
  end
end


