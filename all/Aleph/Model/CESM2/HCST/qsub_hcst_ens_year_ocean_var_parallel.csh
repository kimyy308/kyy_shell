#!/bin/sh
#PBS -N post_ens_hcst
#PBS -q iccp
#PBS -l select=1:ncpus=40:mpiprocs=1:ompthreads=1
#PBS -l walltime=1000:00:00
#PBS -j oe

module load cdo

cd /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/HCST

csh hcst_ens_year_ocean_var_parallel.csh
