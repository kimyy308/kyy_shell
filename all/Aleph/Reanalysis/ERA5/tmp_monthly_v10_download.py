#!/usr/bin/env python

import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels-monthly-means',
    {
        'product_type': 'monthly_averaged_reanalysis',
        'variable': '10m_v_component_of_wind',
        'year': [
            '2011'
        ],
        'month': [
            '02'
        ],
        'time': '00:00',
        'format': 'netcdf',
    },
    '/mnt/lustre/proj/kimyy/Observation/ERA5/v10/raw_monthly/ERA5_v10_201102.nc')

