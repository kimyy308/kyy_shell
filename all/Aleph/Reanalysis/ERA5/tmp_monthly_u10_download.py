#!/usr/bin/env python

import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels-monthly-means',
    {
        'product_type': 'monthly_averaged_reanalysis',
        'variable': '10m_u_component_of_wind',
        'year': [
            '2023'
        ],
        'month': [
            '12'
        ],
        'time': '00:00',
        'format': 'netcdf',
    },
    '/mnt/lustre/proj/kimyy/Observation/ERA5/u10/raw_monthly/ERA5_u10_202312.nc')

