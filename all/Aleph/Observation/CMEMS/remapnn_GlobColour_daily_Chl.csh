#!/bin/csh
####!/bin/csh -fx
# Updated  30-Jun-2025 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set siy = 2002
set eiy = 1998
#set siy = 2017
#set eiy = 2017

set IY_SET = ( `seq ${siy} -1 ${eiy}` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set days = ( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 )

foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
  set INITY = ${iyloop}
  setenv CMEMS_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GlobColour/CHL/daily
  setenv SAVE_ROOT /mnt/lustre/proj/kimyy/Observation/CMEMS/GlobColour/monthly_reg_pop/CHL/daily
  mkdir -p $SAVE_ROOT
  foreach mon ( ${M_SET} )
    foreach day ( $days )
      if ( ( "$mon" == "02" && "$day" > 29 ) || ( "$mon" =~ "04" || "$mon" =~ "06" || "$mon" =~ "09" || "$mon" =~ "11" ) && "$day" > 30 ) continue

      set gridfile = /mnt/lustre/proj/kimyy/Observation/CMEMS/ocn_grid.nc
      set input = ${CMEMS_ROOT}/${INITY}/GLob_Chl_${INITY}-${mon}-${day}.nc
      mkdir -p ${SAVE_ROOT}/${INITY}
      set output = ${SAVE_ROOT}/${INITY}/CMEMS_reg_cesm2.${iyloop}${mon}${day}.nc 
      cdo -O remapnn,${gridfile} ${input} ${output}
#      cdo -O remapbil,r360x180 ${input} ${output}
      echo ${output}
    end
  end
end


