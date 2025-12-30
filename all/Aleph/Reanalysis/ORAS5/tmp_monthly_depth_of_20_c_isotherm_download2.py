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
        'variable': 'depth_of_20_c_isotherm',
        'year': [
            '2025'
        ],
        'month': [
            '12'
        ],
    },
    '/mnt/lustre/proj/kimyy/Observation/ORAS5/depth_of_20_c_isotherm_p/raw_monthly/ERA5_depth_of_20_c_isotherm_p_202512.nc')


