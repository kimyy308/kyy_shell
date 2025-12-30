#!/bin/bash


#siy=1950
#eiy=2023

siy=2022
eiy=2024


years=`seq ${siy} +1 ${eiy}`
months="01 02 03 04 05 06 07 08 09 10 11 12"
#months="11"
var='10m_v_component_of_wind'
varn='v10'
savedir='/mnt/lustre/proj/kimyy/Observation/ERA5/'${varn}'/raw_monthly'
mkdir -p $savedir
tmp_scr='/mnt/lustre/proj/kimyy/Scripts/all/Aleph/Reanalysis/ERA5/tmp_monthly_'${var}'_download.py'

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
        'variable': '${var}',
        'year': [
            '${year}'
        ],
        'month': [
            '${month}'
        ],
        'time': '00:00',
        'data_format': 'netcdf',
        'download_format': 'unarchived',
    },
    '${savedir}/ERA5_${varn}_${year}${month}.nc')


EOF

python $tmp_scr

  done
done

