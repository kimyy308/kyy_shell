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

#mkdir ~/tmp_script
#mkdir ~/tmp_log
set tmp_scr_corr =  ~/tmp_script/${var}_${FLUX_casename}_fig_corr.jnl
set tmp_scr_rmse =  ~/tmp_script/${var}_${FLUX_casename}_fig_rmse.jnl
set tmp_scr_c_corr =  ~/tmp_script/${var}_${FLUX_casename}_fig_corr_c.jnl
set tmp_scr_c_corr2 =  ~/tmp_script/${var}_${FLUX_casename}_fig_corr_c2.jnl
set tmp_scr_c_rmse =  ~/tmp_script/${var}_${FLUX_casename}_fig_rmse.jnl
set tmp_scr_y_corr =  ~/tmp_script/${var}_${FLUX_casename}_fig_y_corr.jnl
set tmp_scr_y_corr2 =  ~/tmp_script/${var}_${FLUX_casename}_fig_y_corr2.jnl
set tmp_scr_y_rmse =  ~/tmp_script/${var}_${FLUX_casename}_fig_y_rmse.jnl
#set tmp_log =  ~/tmp_log/${var}_${FLUX_casename}_fig_corr.log

#set sy = 1998
#set ey = 2007

#### caution
#### fixed term -> 1998 ~ 2007

  set RESOLN = f09_g17
  set scen = BHISTsmbb
  set CASENAME_M = b.e21.${scen}.${RESOLN}.atm_flux.${exp_abb_f}  #parent casename
  set CASENAME = ${FLUX_casename}  #parent casename
   set outfreq = mon
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb}/archive_transfer/ocn/${outfreq}/${var}/${CASENAME}/merged 
  set SAVE_FIGROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_FLUX_${exp_abb}/figure/ocn/${outfreq}/${var}/${CASENAME}/merged 
  mkdir -p ${SAVE_FIGROOT}
  rm -rf ${SAVE_FIGROOT}/*
#   ${ARC_ROOT}/corr_${var}_${outfreq}.nc

#   ${ARC_ROOT}/yearly_RMSE_${var}_${outfreq}.nc
#   ${ARC_ROOT}/yearly_corr_${var}_${outfreq}.nc

cat > $tmp_scr_y_rmse << EOF
  use ${ARC_ROOT}/yearly_RMSE_${var}_${outfreq}.nc
  shade ${var}[k=1]
  frame/file="${SAVE_FIGROOT}/${CASENAME}_y_RMSE_${var}_shade.gif"
  exit
EOF
ferret -gif -script $tmp_scr_y_rmse &
sleep 1s

cat > $tmp_scr_y_corr << EOF
  use ${ARC_ROOT}/yearly_corr_${var}_${outfreq}.nc
  shade/lev=(-1,1,0.2)/palette=blue_red_centered ${var}[k=1]
  frame/file="${SAVE_FIGROOT}/${CASENAME}_y_corr_${var}_shade.gif"
  exit
EOF
ferret -gif -script $tmp_scr_y_corr &
sleep 1s

#cat > $tmp_scr_y_corr2 << EOF
#  use ${ARC_ROOT}/yearly_corr_${var}_${outfreq}.nc
#  shade/lev=(-inf)(0.5,1,0.05)(inf) ${var}[k=1]
#  frame/file="${SAVE_FIGROOT}/${CASENAME}_y_corr_${var}_shade2.gif"
#  exit
#EOF
#ferret -gif -script $tmp_scr_y_corr2 &
#sleep 1s

cat > $tmp_scr_c_rmse << EOF
  use ${ARC_ROOT}/clim_ano_RMSE_${var}_${outfreq}.nc
  shade ${var}[k=1]
  frame/file="${SAVE_FIGROOT}/${CASENAME}_c_RMSE_${var}_shade.gif"
  exit
EOF
ferret -gif -script $tmp_scr_c_rmse &
sleep 1s

cat > $tmp_scr_c_corr << EOF
  use ${ARC_ROOT}/clim_ano_corr_${var}_${outfreq}.nc
  shade/lev=(-1,1,0.2)/palette=blue_red_centered ${var}[k=1]
  frame/file="${SAVE_FIGROOT}/${CASENAME}_c_corr_${var}_shade.gif"
  exit
EOF
ferret -gif -script $tmp_scr_c_corr &
sleep 1s

#cat > $tmp_scr_c_corr2 << EOF
#  use ${ARC_ROOT}/clim_ano_corr_${var}_${outfreq}.nc
#  shade/lev=(-inf)(0.5,1,0.05)(inf) ${var}[k=1]
#  frame/file="${SAVE_FIGROOT}/${CASENAME}_c_corr_${var}_shade2.gif"
#  exit
#EOF
#ferret -gif -script $tmp_scr_c_corr2 &
#sleep 1s

end

