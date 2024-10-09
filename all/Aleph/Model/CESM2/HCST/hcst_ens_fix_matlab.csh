#!/bin/csh

set var = $1
set iy = $2
set fy = $3
set fm = $4
set comp = $5

if ( ${comp} == ocn ) then
  set modn = 'pop.h'
else if ( ${comp} == atm ) then
  set modn = 'cam.h0'
endif

set arcroot = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/${comp}/${var}
set dir_tg = ${arcroot}/ens_all/ens_all_i${iy}

# all ens
cdo -O -L -z zip_5 -ensmean ${arcroot}/*/f09_*i${iy}/*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmean_all_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensmax ${arcroot}/*/f09_*i${iy}/*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmax_all_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensmin ${arcroot}/*/f09_*i${iy}/*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmin_all_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensstd ${arcroot}/*/f09_*i${iy}/*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensstd_all_i${iy}.${modn}.${fy}-${fm}.nc

#en4.2_ba
cdo -O -L -z zip_5 -ensmean ${arcroot}/*/f09_*i${iy}/*en4.2_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmean_en4.2_ba_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensmax ${arcroot}/*/f09_*i${iy}/*en4.2_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmax_en4.2_ba_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensmin ${arcroot}/*/f09_*i${iy}/*en4.2_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmin_en4.2_ba_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensstd ${arcroot}/*/f09_*i${iy}/*en4.2_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensstd_en4.2_ba_i${iy}.${modn}.${fy}-${fm}.nc

#projdv7.3_ba
cdo -O -L -z zip_5 -ensmean ${arcroot}/*/f09_*i${iy}/*projdv7.3_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmean_projdv7.3_ba_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensmax ${arcroot}/*/f09_*i${iy}/*projdv7.3_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmax_projdv7.3_ba_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensmin ${arcroot}/*/f09_*i${iy}/*projdv7.3_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensmin_projdv7.3_ba_i${iy}.${modn}.${fy}-${fm}.nc
cdo -O -L -z zip_5 -ensstd ${arcroot}/*/f09_*i${iy}/*projdv7.3_ba*${fy}-${fm}* ${dir_tg}/${var}_f09_g17.hcst.ensstd_projdv7.3_ba_i${iy}.${modn}.${fy}-${fm}.nc
