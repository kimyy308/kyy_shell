#!/bin/csh
####!/bin/csh -fx
# Updated  07-Jul-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set var = RAIN
set comp = lnd


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


set siy = 2025
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/${comp}/${var}/ens_smbb
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/${comp}/${var}/ens_smbb/${region}

mkdir -p ${SAVE_ROOT}

set IY_SET = ( `seq ${siy} -1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )
  foreach mon ( ${M_SET} )
    set INITY = ${iyloop}
    mkdir -p $SAVE_ROOT

    set inputname = ${ARC_ROOT}/${var}_ensmean_${INITY}-${mon}.nc
#    set inputname=${ARC_ROOT}/${var}_ensmean_all_i${iyloop}.cam.h0.${fy}-${mon}.nc
    set outputname1=${SAVE_ROOT}/${region}_${var}_ensmean_${iyloop}-${mon}.nc
    set outputname2=${SAVE_ROOT}/M_${region}_${var}_ensmean_${iyloop}-${mon}.nc
#     echo "cdo -O fldmean "${input_set} ${outputname}
    if ( ${var} == TS & ${INITY} < 2022 ) then
      setenv HadCRUT5_ROOT /mnt/lustre/proj/kimyy/Observation/HadCRUT5/monthly_reg_cam
      set HadCRUT5name=${HadCRUT5_ROOT}/HadCRUT5_reg_cesm2.${INITY}${mon}.nc
      cdo -O -expr,'tas_mean=tas_mean/tas_mean' ${HadCRUT5name} ${homedir}/TS_mask.nc
      cdo -O -L -merge -selname,tas_mean ${homedir}/TS_mask.nc -selname,TS ${inputname} ${homedir}/TS_merge.nc
      cdo -O -expr,'TS=tas_mean*TS' ${homedir}/TS_merge.nc ${homedir}/TS_masked.nc
      cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${homedir}/TS_merge.nc ~/test_lens2.nc
      cdo -O setmissval,0 ~/test_lens2.nc ${outputname1}
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
      cdo -O -sellonlatbox,${xs},${xe},${ys},${yn} ${inputname} ~/test_lens2.nc
      cdo -O setmissval,0 ~/test_lens2.nc ${outputname1}
      cdo -O fldmean ${outputname1} ${outputname2}
    endif


  end
end
echo ${var}"_postprocessing complete"

