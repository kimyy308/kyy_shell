#!/usr/bin/env python

import cdsapi


c = cdsapi.Client()
c.retrieve(
    'reanalysis-era5-pressure-levels-monthly-means',
    {
        'product_type': 'monthly_averaged_reanalysis',
        'variable': 'geopotential',
        'pressure_level': '500',
        'year': [
            '2023'
        ],
        'month': [
            '12'
        ],
        'time': '00:00',
        'format': 'netcdf',
    },
    '/mnt/lustre/proj/kimyy/Observation/ERA5/geopotential_p500/raw_monthly/ERA5_geopotential_p500_202312.nc')


