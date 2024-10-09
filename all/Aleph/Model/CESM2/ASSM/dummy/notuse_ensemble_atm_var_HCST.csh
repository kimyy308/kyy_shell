#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

----------not yet 

set TOOLROOT = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/ASSM
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
#set FACTOR_SET = (10 20)
#set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2020
set eiy = 1991
set var = SST
set scens = (BHISTsmbb BSSP370smbb)
set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.assm.en4.2_ba-10p1/atm/proc/tseries/month_1
set Y_SET = ( `ls ${refdir}/*.${var}.* | cut -d '.' -f 19` )
#echo ${Y_SET}
#set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach scen ( ${scens} )
  foreach yloop ( ${Y_SET} )
    setenv ARC_ROOT /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/*.${scen}.*/atm/proc/tseries/month_1
    setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP_timeseries/archive/ens_all/atm/proc/tseries/month_1/${var}
    
    mkdir -p $SAVE_ROOT
    set input_set = (`ls ${ARC_ROOT}/*.${var}.${yloop}.nc`)
    set outputname=${SAVE_ROOT}/${var}_${RESOLN}.assm.ens_all_${yloop}.nc
    echo "cdo -O ensmean "${input_set} ${outputname}
#    cdo -O ensmean ${input_set} ${outputname}
    sleep 1s
  end
end


