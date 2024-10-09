#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set vars = ( NO3 PO4 SiO3 Fe PD SALT TEMP )
#set vars = ( PD TEMP )
#set vars = ( UVEL VVEL NO3 )
#set vars = (  VVEL NO3 )
set vars = ( UVEL VVEL )

foreach rawvar ( ${vars} )

# vertical depth (m)
set vert_lev = 145

set var = ${rawvar}${vert_lev}


set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${rawvar}/ens_all
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}/ens_all

set IY_SET = ( `seq ${siy} -1 ${eiy}` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( ${IY_SET} )
  foreach mon ( ${M_SET} )
    set INITY = ${iyloop}
    mkdir -p $SAVE_ROOT
    set INPUT = ${ARC_ROOT}/${rawvar}_ensmean_${INITY}-${mon}.nc
    set OUTPUT = ${SAVE_ROOT}/${var}_ensmean_${INITY}-${mon}.nc
    
    cdo -O -L -w -z zip_5 -sellevel,${vert_lev}00/${vert_lev}00 ${INPUT} ${OUTPUT} 

echo ${var}"_postprocessing complete"

  end
end

end
