#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST

set RESOLN = f09_g17
#set siy = 2021
#set eiy = 1960
set siy = 2021
set eiy = 1960
set var = RAIN

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
#  setenv ARC_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/lnd/${var}/ens_all/ens_all_i${iyloop}
#  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/HCST_EXP/archive/lnd/${var}/ens_all/ens_all_i${iyloop}/${region}
  setenv ARC_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/lnd/${var}/ens_all/ens_all_i${iyloop}
  setenv SAVE_ROOT /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/lnd/${var}/ens_all/ens_all_i${iyloop}/${region}
 
 # set outputnc_new=(`echo ${outputnc} | sed "s/${RESOLN}/${var}_${RESOLN}/g"`)
 
  mkdir -p $SAVE_ROOT
  @ fy_end = ${iyloop} + 4
  set FY_SET = ( `seq ${iyloop} ${fy_end}` )
  foreach fy ( ${FY_SET} )
    foreach mon ( ${M_SET} )
      #set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
      set inputname=${ARC_ROOT}/${var}_${RESOLN}.hcst.ensmean_all_i${iyloop}.clm2.h0.${fy}-${mon}.nc
      set outputname1=${SAVE_ROOT}/${region}_${var}_${RESOLN}.hcst.ensmean_all_i${iyloop}.clm2.h0.${fy}-${mon}.nc
      set outputname2=${SAVE_ROOT}/M_${region}_${var}_${RESOLN}.hcst.ensmean_all_i${iyloop}.clm2.h0.${fy}-${mon}.nc
#      echo "cdo -O fldmean "${input_set} ${outputname}
      if ( ${var} == TS & ${fy} < 2022 ) then
        setenv HadCRUT5_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/monthly_reg_cam
        set HadCRUT5name=${HadCRUT5_ROOT}/HadCRUT5_reg_cesm2.${fy}${mon}.nc
        cdo -O -expr,'tas_mean=tas_mean/tas_mean' ${HadCRUT5name} ${homedir}/TS_mask.nc
        cdo -O -L -merge -selname,tas_mean ${homedir}/TS_mask.nc -selname,TS ${inputname} ${homedir}/TS_merge.nc
        cdo -O -expr,'TS=tas_mean*TS' ${homedir}/TS_merge.nc ${homedir}/TS_masked.nc
        cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${homedir}/TS_merge.nc ~/test_hcst.nc
        cdo -O setmissval,0 ~/test_hcst.nc ${outputname1}
        cdo -O fldmean ${outputname1} ${outputname2}
      elseif ( ${var} == RAIN & ${INITY} < 2020 ) then
        setenv GPCC_ROOT /mnt/lustre/proj/kimyy/Observation/GPCC/monthly_reg_cam
        set GPCCname=${GPCC_ROOT}/GPCC_reg_cesm2.v5.${INITY}${mon}.nc
        cdo -O -expr,'precip=precip/precip' ${GPCCname} ${homedir}/RAIN_mask.nc
        cdo -O -L -merge -selname,precip ${homedir}/RAIN_mask.nc -selname,RAIN ${inputname} ${homedir}/RAIN_merge.nc
        cdo -O -expr,'RAIN=precip*RAIN' ${homedir}/RAIN_merge.nc ${homedir}/RAIN_masked.nc
        cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${homedir}/RAIN_merge.nc ~/test_assm.nc
        cdo -O setmissval,0 ~/test_assm.nc ${outputname1}
        cdo -O fldmean ${outputname1} ${outputname2}
      else
        cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${inputname} ~/test_hcst.nc
        cdo -O setmissval,0 ~/test_hcst.nc ${outputname1}
        cdo -O fldmean ${outputname1} ${outputname2}
      endif
    end
  end
end

rm -f ${homedir}/TS_merge.nc
rm -f ${homedir}/TS_mask.nc
rm -f ${homedir}/TS_masked.nc
