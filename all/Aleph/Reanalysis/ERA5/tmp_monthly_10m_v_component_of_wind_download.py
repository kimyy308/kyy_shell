#!/usr/bin/env python

import cdsapi


c = cdsapi.Client()
c.retrieve(
    'reanalysis-era5-single-levels-monthly-means',
    {
        'variable': '10m_v_component_of_wind',
        'year': [
            '2024'
        ],
        'month': [
            '12'
        ],
        'time': '00:00',
        'data_format': 'netcdf',
        'download_format': 'unarchived',
    },
    '/mnt/lustre/proj/kimyy/Observation/ERA5/v10/raw_monthly/ERA5_v10_202412.nc')


