#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = (WVEL WVEL2 diatChl diazChl spChl DIC ALK TEMP SALT WVEL2 NO3 SiO3 PO4 UVEL VVEL PD UE_PO4 VN_PO4 WT_PO4 Fe diatC diazC spC )
#set vars = ( WVEL )
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT WVEL2 NO3 SiO3 PO4 UVEL VVEL PD UE_PO4 VN_PO4 WT_PO4 Fe diatC diazC spC WVEL2 BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH IRON_FLUX HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
#set vars = ( diatFe diatP diatSi diaz_agg diaz_Nfix diazP dust_FLUX_IN dust_REMIN O2 photoFe_diat photoFe_diaz photoFe_sp photoNO3_diat photoNO3_diaz photoNO3_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake sp_agg spFe spP zooC diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT photoC_NO3_TOT_zint_100m photoC_sp_zint_100m photoC_TOT sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )
set vars = ( diat_agg diazFe photoC_NO3_TOT photoC_TOT POC_FLUX_100m )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/BIAS_fig_${var}_atm_NUDGE_assm_tmp.csh
set tmp_log =  ~/tmp_log/BIAS_fig_${var}_atm_NUDGE_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (20)
set mbr_set = (1)
set RESOLN = f09_g17
set siy = 2015
set eiy = 2019
set outfreq = mon
#set Y_SET = ( \`seq \${siy} +1 \${eiy}\` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set scen = BSSP370smbb
foreach OBS ( \${OBS_SET} ) #OBS loop1
  foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
    foreach mbr ( \$mbr_set ) #mbr loop1
      set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set OBS_CASENAME = f09_g17.assm.projdv7.3_ba-10p1
#      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_NUDGE_ASSM_EXP/archive/\${CASENAME_M}
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_NUDGE_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_NUDGE_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME}/RMSE
      mkdir -p \$SAVE_ROOT
      
      set OBS_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${OBS_CASENAME}
      set OBS_SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${OBS_CASENAME}/RMSE
      mkdir -p \$OBS_SAVE_ROOT

      set input_head = \${ARC_ROOT}/*${var}*.pop.h.????-??.nc
      set input_set=(\`ls \${input_head}*\`)
      set merge_file = \${SAVE_ROOT}/merged_${var}_\${CASENAME}.pop.h.nc
      set ck_mfile = \`ls \${merge_file}\`
      if ( \${ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${input_set} \${merge_file} 
      endif
      
      set OBS_input_head = \${OBS_ROOT}/*${var}*.pop.h.????-??.nc
      set OBS_input_set=(\`ls \${OBS_input_head}*\`)
      set OBS_merge_file = \${OBS_SAVE_ROOT}/merged_${var}_\${OBS_CASENAME}.pop.h.nc
      set OBS_ck_mfile = \`ls \${OBS_merge_file}\`
      if ( \${OBS_ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${OBS_input_set} \${OBS_merge_file} 
      endif
      
      set bias_file = \${SAVE_ROOT}/bias_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5 -sub \${merge_file} \${OBS_merge_file} \${bias_file}      
      set mbias_file = \${SAVE_ROOT}/mean_bias_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5 -timmean \${bias_file} \${mbias_file}
      
      
      cdo -O -w -z zip_5 -sqr \${bias_file} ${homedir}/test_sqr_bias_${var}.nc
      cdo -O -w -z zip_5 -timmean  ${homedir}/test_sqr_bias_${var}.nc ${homedir}/test_msqr_bias_${var}.nc
      set RMSE_file = \${SAVE_ROOT}/BIAS_fig_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5 -sqrt ${homedir}/test_msqr_bias_${var}.nc \${RMSE_file}

    end
  end
end
rm -f ${homedir}/test_sqr_bias_${var}.nc ${homedir}/test_msqr_bias_${var}.nc
rm -f ${homedir}/test_selbox_bias_${var}.nc
EOF

csh $tmp_scr > $tmp_log &
end
