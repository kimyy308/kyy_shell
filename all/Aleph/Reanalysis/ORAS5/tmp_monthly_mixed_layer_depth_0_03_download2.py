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
        'variable': 'mixed_layer_depth_0_03',
        'year': [
            '2025'
        ],
        'month': [
            '12'
        ],
    },
    '/mnt/lustre/proj/kimyy/Observation/ORAS5/mixed_layer_depth_0_03_p/raw_monthly/ERA5_mixed_layer_depth_0_03_p_202512.nc')


