#!/bin/csh

set workdir = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/LENS2 

set vars = ( diatChl )
#set vars = ( diatChl diazChl spChl NO3 SiO3 PO4 Fe PAR_avg ALK diatC diazC DIC PD SALT spC TEMP UVEL VVEL WVEL WVEL2 O2 zooC SSH photoC_TOT_zint photoC_TOT_zint_100m diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 IRON_FLUX HMXL BSF HBLT NO3_RIV_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m zoo_loss_zint_100m sp_P_lim_surf )
#set vars = ( zoo_loss_zint_100m sp_P_lim_surf )

foreach var ( ${vars} )

set tmp_qsub_scr = ${workdir}/tmp_qsub_lens2_ens_period_tseries_ocn_var.csh
cat > ${tmp_qsub_scr} << EOF
#!/bin/sh
#PBS -N post_lens2_${var}
#PBS -q iccp
#PBS -l select=1:ncpus=40:mpiprocs=1:ompthreads=10
#PBS -l walltime=50:00:00
#PBS -j oe

module load cdo

cd /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/LENS2
csh ./lens2_ens_period_tseries_ocn_var_parallel.csh ${var}

EOF

qsub ${tmp_qsub_scr}
sleep 60s

end
