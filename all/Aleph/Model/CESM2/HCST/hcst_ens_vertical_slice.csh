#!/bin/csh
####!/bin/csh -fx
# Updated  04-Jul-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( PD SALT UVEL VVEL NO3 Fe PO4 SiO3 ) 
set vars = ( TEMP )
foreach rawvar ( ${vars} )

#vertical depth (m)
#set vert_lev = 55
set vert_lev = 145
set var = ${rawvar}${vert_lev}

set siy = 2020
set eiy = 1960
set RESOLN = f09_g17


set IY_SET = ( `seq ${siy} -1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )

foreach iyloop ( ${IY_SET} )  # iy loop1, inverse direction
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${rawvar}/ens_all/ens_all_i${iyloop}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/ens_all/ens_all_i${iyloop}
  set INITY = ${iyloop}

  mkdir -p ${SAVE_ROOT}
  @ fy_end = ${iyloop} + 4
  set FY_SET = ( `seq ${iyloop} ${fy_end}` )
  foreach fy ( ${FY_SET} )
    foreach mon ( ${M_SET} )
      set INPUT = ${ARC_ROOT}/${rawvar}_f09_g17.hcst.ensmean_all_i${iyloop}.pop.h.${fy}-${mon}.nc
      set OUTPUT1 = /proj/kimyy/tmp/${var}.nc
      set OUTPUT2 = ${SAVE_ROOT}/${var}_f09_g17.hcst.ensmean_all_i${iyloop}.pop.h.${fy}-${mon}.nc

      cdo -O -L -w -z zip_5 -sellevel,${vert_lev}00/${vert_lev}00 ${INPUT} ${OUTPUT2}
#      cdo -O -L -w -z zip_5 -sellevel,${vert_lev}00/${vert_lev}00 ${INPUT} ${OUTPUT1}
#      cdo chname,${rawvar},${var} ${OUTPUT1} ${OUTPUT2}

    end
  end
end

echo ${var}"_postprocessing complete"


end
