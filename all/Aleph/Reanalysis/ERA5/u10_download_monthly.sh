#!/bin/bash


siy=1960
eiy=2023

years=`seq ${siy} +1 ${eiy}`
months="01 02 03 04 05 06 07 08 09 10 11 12"
var='u10'
savedir='/mnt/lustre/proj/kimyy/Observation/ERA5/'${var}'/raw_monthly'
mkdir -p $savedir
tmp_scr='/mnt/lustre/proj/kimyy/Scripts/Reanalysis/ERA5/tmp_monthly_'${var}'_download.py'

for year in $years
do
  for month in $months
  do

cat > $tmp_scr << EOF
#!/usr/bin/env python

import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels-monthly-means',
    {
        'product_type': 'monthly_averaged_reanalysis',
        'variable': '10m_u_component_of_wind',
        'year': [
            '${year}'
        ],
        'month': [
            '${month}'
        ],
        'time': '00:00',
        'format': 'netcdf',
    },
    '${savedir}/ERA5_${var}_${year}${month}.nc')

EOF

python $tmp_scr

  done
done

