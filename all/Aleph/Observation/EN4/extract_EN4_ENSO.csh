#!/bin/csh
####!/bin/csh -fx
# Updated  16-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST

set siy = 2021
set eiy = 1950
set var = SST


#set region = NINO34
#set xs = -170
#set xe = -120
#set ys = -5
#set ye = 5
#set region = NINO3
#set xs = -150
#set xe = -90
#set ys = -5
#set ye = 5
set region = TROP
set xs = 120
set xe = 200
set ys = -5
set ye = 5


set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv EN4_ROOT /mnt/lustre/proj/earth.system.predictability/OBS_DATA/ORIG/EN4.2.2
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/EN4/${region}
 
 # set outputnc_new=(`echo ${outputnc} | sed "s/${RESOLN}/${var}_${RESOLN}/g"`)
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    #set input_set = (`ls ${ARC_ROOT}/*/*_i${iyloop}/*${fy}-${mon}.nc`)
    set inputname=${EN4_ROOT}/EN.4.2.2.f.analysis.g10.${iyloop}${mon}.nc
    set tmpname=/proj/kimyy/tmp/EN4_tmp.nc
    set outputname1=${SAVE_ROOT}/${region}_EN4.2.2.${iyloop}${mon}.nc
    set outputname2=${SAVE_ROOT}/${region}_EN4.2.2.fldmean.${iyloop}${mon}.nc
    cdo -O -w -z zip_5 select,name=temperature ${inputname} ${tmpname}
    cdo -O -w -z zip_5 -sellonlatbox,${xs},${xe},${ys},${ye} ${tmpname} ${outputname1}
#    cdo -O -w -z zip_5 select,name=temperature -sellonlatbox,${xs},${xe},${ys},${ye} ${inputname} ${outputname1}
#    cdo -O setmissval,0 ~/test_ersst.nc ${outputname1}
    cdo -O fldmean ${outputname1} ${outputname2}
  end
end
rm -rf ${tmpname}

