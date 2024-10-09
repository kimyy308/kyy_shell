#!/bin/csh
####!/bin/csh -fx
# Updated  06-Jun-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

set exp_abb_ref1 = REF1
set FLUX_casename_ref1 = EXP_FLUX_${exp_abb_ref1}

set exp_abb = xWDS
set FLUX_casename = EXP_FLUX_${exp_abb}

set vars = (UVEL VVEL WVEL photoC_TOT diatChl diazChl spChl TEMP SALT WVEL2 NO3 SiO3 PO4 Fe PAR_avg NH4 DOP SSH IRON_FLUX HBLT diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_surf diaz_light_lim_Cweight_avg_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf photoC_diat_zint_100m photoC_diaz_zint_100m photoC_sp_zint_100m photoC_TOT_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf TAUX TAUY ATM_COARSE_DUST_FLUX_CPL ATM_FINE_DUST_FLUX_CPL SHF_QSW QSW_BIN_01 QSW_BIN_06 )
#set vars = ( TEMP )
#set vars = (UVEL VVEL WVEL photoC_TOT diatChl diazChl spChl TEMP WVEL2 NO3 SiO3 PO4 Fe PAR_avg NH4 DOP )
#set vars_2d = ( SSH IRON_FLUX HBLT diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_surf diaz_light_lim_Cweight_avg_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf photoC_diat_zint_100m photoC_diaz_zint_100m photoC_sp_zint_100m photoC_TOT_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf TAUX TAUY ATM_COARSE_DUST_FLUX_CPL ATM_FINE_DUST_FLUX_CPL SHF_QSW QSW_BIN_01 QSW_BIN_06 )


set exp_abb_f_ref1 = ref1
if ( ${exp_abb} == REF1 ) then
  set exp_abb_f = ref1
else
  set exp_abb_f = ${exp_abb}
endif

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_${FLUX_casename}_corr_rmse.csh
set tmp_log =  ~/tmp_log/${var}_${FLUX_casename}_rmse_corr.log

#set sy = 1998
#set ey = 2007

#### caution
#### fixed term -> 1998 ~ 2007


cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set outfreq = mon
#set scens = ( BHISTsmbb BSSP370smbb )
set scens = ( BHISTsmbb )
foreach scen ( \${scens} ) 
  set CASENAME_M_ref1 = b.e21.\${scen}.\${RESOLN}.atm_flux.${exp_abb_f_ref1}  #parent casename
  set CASENAME_ref1 = ${FLUX_casename_ref1}  #parent casename
  set ARC_ROOT_ref1 = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb_ref1}/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME_ref1}/merged 
  set CASENAME_M = b.e21.\${scen}.\${RESOLN}.atm_flux.${exp_abb_f}  #parent casename
  set CASENAME = ${FLUX_casename}  #parent casename
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb}/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME}/merged 
  set SAVE_ROOT = \${ARC_ROOT}
  #raw  
  cdo -O -w -sqrt -timmean -sqr -sub \${ARC_ROOT}/merged_${var}_\${outfreq}.nc \${ARC_ROOT_ref1}/merged_${var}_\${outfreq}.nc \${SAVE_ROOT}/RMSE_${var}_\${outfreq}.nc
  cdo -O -w -timcor \${ARC_ROOT}/merged_${var}_\${outfreq}.nc \${ARC_ROOT_ref1}/merged_${var}_\${outfreq}.nc \${SAVE_ROOT}/corr_${var}_\${outfreq}.nc
  #clim_ano
  cdo -O -w -sqrt -timmean -sqr -sub \${ARC_ROOT}/clim_ano_remap_${var}_\${outfreq}.nc \${ARC_ROOT_ref1}/clim_ano_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/clim_ano_RMSE_${var}_\${outfreq}.nc
  cdo -O -w -timcor \${ARC_ROOT}/clim_ano_remap_${var}_\${outfreq}.nc \${ARC_ROOT_ref1}/clim_ano_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/clim_ano_corr_${var}_\${outfreq}.nc
  #yearly
  cdo -O -w -sqrt -timmean -sqr -sub \${ARC_ROOT}/yearly_merged_remap_${var}_\${outfreq}.nc \${ARC_ROOT_ref1}/yearly_merged_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/yearly_RMSE_${var}_\${outfreq}.nc
  cdo -O -w -timcor \${ARC_ROOT}/yearly_merged_remap_${var}_\${outfreq}.nc \${ARC_ROOT_ref1}/yearly_merged_remap_${var}_\${outfreq}.nc \${SAVE_ROOT}/yearly_corr_${var}_\${outfreq}.nc
end
echo "postprocessing complete"

EOF

csh $tmp_scr > $tmp_log &
end

