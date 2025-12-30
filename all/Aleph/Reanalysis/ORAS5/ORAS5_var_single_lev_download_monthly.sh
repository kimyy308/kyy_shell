#!/bin/bash


siy=1958
#siy=1974
eiy=2025

years=`seq ${siy} +1 ${eiy}`
months="01 02 03 04 05 06 07 08 09 10 11 12"
var='mixed_layer_depth_0_01'
#var='mixed_layer_depth_0_03'
#var='depth_of_20_c_isotherm'
savedir='/mnt/lustre/proj/kimyy/Observation/ORAS5/'${var}_p${plevel}'/raw_monthly'
mkdir -p $savedir
tmp_scr='/mnt/lustre/proj/kimyy/Scripts/all/Aleph/Reanalysis/ORAS5/tmp_monthly_'${var}'_download2.py'

for year in $years
do
  for month in $months
  do

cat > $tmp_scr << EOF
#!/usr/bin/env python

import cdsapi


c = cdsapi.Client()
c.retrieve(
    'reanalysis-oras5',
    {
        'product_type': [
            'consolidated',
            'operational'
        ],
        'vertical_resolution': 'single_level',
        'variable': '${var}',
        'year': [
            '${year}'
        ],
        'month': [
            '${month}'
        ],
    },
    '${savedir}/ORAS5_${var}_p${plevel}_${year}${month}.zip')


EOF

python $tmp_scr

  done
done

