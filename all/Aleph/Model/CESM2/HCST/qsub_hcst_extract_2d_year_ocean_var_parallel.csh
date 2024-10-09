#!/bin/sh
#PBS -N post_ext_hcst_2d
#PBS -q iccp
#PBS -l select=1:ncpus=40:mpiprocs=1:ompthreads=1
#PBS -l walltime=100:00:00
#PBS -j oe

module load cdo

cd /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST

csh hcst_extract_2d_year_ocn_var_parallel.csh
