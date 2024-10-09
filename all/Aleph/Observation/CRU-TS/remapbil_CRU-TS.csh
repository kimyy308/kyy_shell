#!/bin/csh
####!/bin/csh -fx
# Updated  07-Feb-2024 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set siy = 2022
#set eiy = 2022
set siy = 2020
set eiy = 1960
set var = sst

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv CRU_TS_ROOT /mnt/lustre/proj/kimyy/Observation/CRU_TS
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/CRU_TS/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  
  cd $CRU_TS_ROOT 
  set sy_set = ( `ls /mnt/lustre/proj/kimyy/Observation/CRU_TS/*.dat.nc | cut -d '.' -f 3` )
  foreach sy ( $sy_set )
    @ ey = $sy + 9
    if (${iyloop} >= ${sy} && ${iyloop} <= ${ey}) then
      set fname = `ls /mnt/lustre/proj/kimyy/Observation/CRU_TS/*.dat.nc | grep ${sy}`
      foreach mon ( ${M_SET} )
        set gridfile = ${CRU_TS_ROOT}/SST_f09_g17.hcst.ens_all_i2020.cam.h0.2020-01.nc
        set input = ${fname} 
        set output = ${SAVE_ROOT}/CRU_TS_reg_cesm2.${iyloop}${mon}.nc 
        cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_CRU_TS.nc
        cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_CRU_TS.nc ${output}
      end
    endif
  end
end


#    cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_GPCC.nc
#    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_GPCC.nc ${output}
