#!/bin/bash


siy=1958
#siy=1974
eiy=2024

years=`seq ${siy} +1 ${eiy}`
months="01 02 03 04 05 06 07 08 09 10 11 12"
#var='mixed_layer_depth_0_01'
var='mixed_layer_depth_0_03'
#var='depth_of_20_c_isotherm'
savedir='/mnt/lustre/proj/kimyy/Observation/ORAS5/'${var}_p${plevel}'/raw_monthly'
mkdir -p $savedir
tmp_scr='/mnt/lustre/proj/kimyy/Scripts/all/Aleph/Reanalysis/ORAS5/tmp_monthly_'${var}'_download2.py'

for year in $years
do
  for month in $months
  do
  mv ${savedir}/ERA5_${var}_p_${year}${month}.nc ${savedir}/ORAS5_${var}_p_${year}${month}.zip
  unzip ${savedir}/ORAS5_${var}_p_${year}${month}.zip -d ${savedir}
  fname=`ls ${savedir} | grep ${year}${month} | grep .nc | grep highres`
  mv -f ${savedir}/$fname ${savedir}/ORAS5_${var}_${year}${month}.nc

  done
done

