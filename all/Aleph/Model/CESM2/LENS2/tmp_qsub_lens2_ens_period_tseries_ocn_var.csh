#!/bin/sh

module load cdo

cd /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/LENS2
csh ./lens2_ens_period_tseries_ocn_var_parallel.csh zooC

