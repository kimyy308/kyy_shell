#!/bin/csh
# Updated 23-Jan-2022 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

module load cdo
module load ferret
set DROOT='/mnt/lustre/proj/kimyy/Model/CMIP/CMIP6_analysis'

set var='tos'
set mon=2
set monstr='feb'
set cmor='NA_reg'
set files=(`ls ${DROOT}/${var}/${cmor}/${monstr}/`)
cd ${DROOT}/${var}/${cmor}/${monstr}
foreach file ( ${files} )
  set model=`echo ${file} | cut -d '_' -f 4`
  set figdir=${DROOT}/${var}/${cmor}/${monstr}/fig
  mkdir -p ${figdir}
  set file_gif=${figdir}/${var}'_'${cmor}'_'${model}'_'${monstr}'.gif'
  cat > fig.jnl << EOF
  use "${file}"
  plot tos
  frame/file="${file_gif}"
EOF
  ferret -script fig.jnl
end

#ls $DROOT/$scen/$var/$cmor/$model/*/*/*tos*nc

#tos_Omon_TaiESM1_ssp585_r1i1p1f1_gn_210001-210012.nc
