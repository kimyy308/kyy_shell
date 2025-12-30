#!/usr/bin/env python

import cdsapi


c = cdsapi.Client()
c.retrieve(
    'reanalysis-era5-pressure-levels-monthly-means',
    {
        'product_type': 'monthly_averaged_reanalysis',
        'variable': 'geopotential',
        'pressure_level': '850',
        'year': [
            '2023'
        ],
        'month': [
            '12'
        ],
        'time': '00:00',
        'format': 'netcdf',
    },
    '/mnt/lustre/proj/kimyy/Observation/ERA5/geopotential_p850/raw_monthly/ERA5_geopotential_p850_202312.nc')


