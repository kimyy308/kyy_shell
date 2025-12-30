#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jan-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set siy = 2021
#set eiy = 1982
set siy = 1994
set eiy = 1994
#aot1
set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv AVHRR_ROOT /mnt/lustre/proj/kimyy/Observation/AVHRR/AOT/www.ncei.noaa.gov/data/avhrr-aerosol-optical-thickness/access/monthly
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/AVHRR/AOT/monthly_reg_cam
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    set gridfile = /proj/earth.system.predictability/HCST_EXP/archive_transfer/atm/grid.nc
    if ( ${INITY} > 2019 ) then
      set input = ${AVHRR_ROOT}/AOT_AVHRR_v04r00-preliminary_monthly-avg_${INITY}${mon}_c2022????.nc
    else
      set input = ${AVHRR_ROOT}/AOT_AVHRR_v04r00_monthly-avg_${INITY}${mon}_c2022????.nc
    endif
    set output = ${SAVE_ROOT}/AVHRR_reg_cesm2.${iyloop}${mon}.nc 
    #cdo -O -L -selmon,${mon} -selyear,${iyloop} ${input} /proj/kimyy/tmp/test_AVHRR.nc
    cdo -O -L -selvar,aot1 ${input} /proj/kimyy/tmp/test_AVHRR.nc
    cdo -O remapbil,${gridfile} /proj/kimyy/tmp/test_AVHRR.nc ${output}
  end
end
rm -f /proj/kimyy/tmp/test_AVHRR.nc

