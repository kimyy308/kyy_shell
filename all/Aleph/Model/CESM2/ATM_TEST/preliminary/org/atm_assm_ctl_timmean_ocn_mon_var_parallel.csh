#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = (WVEL WVEL2 diatChl diazChl spChl DIC ALK TEMP SALT WVEL2 NO3 SiO3 PO4 UVEL VVEL PD UE_PO4 VN_PO4 WT_PO4 Fe diatC diazC spC )
#set vars = ( WVEL )
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT WVEL2 NO3 SiO3 PO4 UVEL VVEL PD UE_PO4 VN_PO4 WT_PO4 Fe diatC diazC spC WVEL2 BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH IRON_FLUX HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
set vars = ( diatFe diatP diatSi diaz_agg diaz_Nfix diazP dust_FLUX_IN dust_REMIN O2 photoFe_diat photoFe_diaz photoFe_sp photoNO3_diat photoNO3_diaz photoNO3_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake sp_agg spFe spP zooC diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m diat_agg diazFe photoC_NO3_TOT photoC_TOT POC_FLUX_100m )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/MEAN_${var}_atm_ctl_assm_tmp.csh
set tmp_log =  ~/tmp_log/MEAN_${var}_atm_ctl_assm_tmp.log

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
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME}/MEAN
      set SAVE_RMSE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME}/RMSE
      mkdir -p \$SAVE_ROOT
      
      set OBS_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${OBS_CASENAME}
      set OBS_SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${OBS_CASENAME}/MEAN
      set OBS_SAVE_RMSE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${OBS_CASENAME}/RMSE
      mkdir -p \$OBS_SAVE_ROOT

      set input_head = \${ARC_ROOT}/*${var}*.pop.h.????-??.nc
      set input_set=(\`ls \${input_head}*\`)
      set merge_file = \${SAVE_RMSE_ROOT}/merged_${var}_\${CASENAME}.pop.h.nc
      set ck_mfile = \`ls \${merge_file}\`
      if ( \${ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${input_set} \${merge_file} 
      endif
      
      set OBS_input_head = \${OBS_ROOT}/*${var}*.pop.h.????-??.nc
      set OBS_input_set=(\`ls \${OBS_input_head}*\`)
      set OBS_merge_file = \${OBS_SAVE_RMSE_ROOT}/merged_${var}_\${OBS_CASENAME}.pop.h.nc
      set OBS_ck_mfile = \`ls \${OBS_merge_file}\`
      if ( \${OBS_ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${OBS_input_set} \${OBS_merge_file} 
      endif
      
      set MEAN_file = \${SAVE_ROOT}/MEAN_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5 -timmean \${merge_file} \${MEAN_file}
     
        
      ### absolute error field mean
      #ArcTic Ocean 0E ~ 360E(0W), 70N ~ 90N
      set ATO_file = \${SAVE_ROOT}/mean_ATO_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,0,360,70,90 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${ATO_file}
      
      #SubPolar North Pacific 120E ~ 240E(120W), 40N ~ 70N
      set SPNP_file = \${SAVE_ROOT}/mean_SPNP_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,120,240,40,70 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${SPNP_file}

      #SubTropical North Pacific 100E ~ 260E(100W), 20N ~ 40N
      set STNP_file = \${SAVE_ROOT}/mean_STNP_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,100,260,20,40 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${STNP_file}

      #Tropical Pacific 120E ~ 280E(100W), -20N ~ 20N
      set TP_file = \${SAVE_ROOT}/mean_TP_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,120,280,-20,20 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${TP_file}

      #SubTropical South Pacific 140E ~ 290E(70W), -40N ~ -20N
      set STSP_file = \${SAVE_ROOT}/mean_STSP_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,140,290,-40,-20 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${STSP_file}

      #SubPolar South Pacific 140E ~ 290E(70W), -60N ~ -40N
      set SPSP_file = \${SAVE_ROOT}/mean_SPSP_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,140,290,-60,-40 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${SPSP_file}

      #ANtarctic Ocean 0E ~ 360E(0W), -80N ~ -60N
      set ANO_file = \${SAVE_ROOT}/mean_ANO_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,0,360,-80,-60 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${ANO_file}

      #SubPolar North Atlantic 260E(100W) ~ 360E(0W), 40N ~ 70N
      set SPNA_file = \${SAVE_ROOT}/mean_SPNA_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,260,360,40,70 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${SPNA_file}

      #SubTropical North Atlantic 260E(100W) ~ 360E(0W), 20N ~ 40N
      set STNA_file = \${SAVE_ROOT}/mean_STNA_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,260,360,20,40 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${STNA_file}

      #Tropical Atlantic 280E(80W) ~ 20E, -20N ~ 20N
      set TA_file = \${SAVE_ROOT}/mean_TA_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,-80,20,-20,20 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${TA_file}
      
      #SubTropical South Atlantic 300E(60W) ~ 20E, -40N ~ -20N
      set STSA_file = \${SAVE_ROOT}/mean_STSA_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,-60,20,-40,-20 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${STSA_file}

      #SubPolar South Atlantic 290E(-70W) ~ 20E, -60N ~ -40N
      set SPSA_file = \${SAVE_ROOT}/mean_SPSA_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,-70,20,-60,-40 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${SPSA_file}

      #Northern Indian Ocean 40E ~ 100E, -10N ~ 30N
      set NIO_file = \${SAVE_ROOT}/mean_NIO_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,40,100,-10,30 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${NIO_file}

      #SubTropical Southern Indian Ocean 20E ~ 120E, -40N ~ -10N
      set STSIO_file = \${SAVE_ROOT}/mean_STSIO_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,20,120,-40,-10 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${STSIO_file}

      #SubPolar Southern Indian Ocean 20E ~ 120E, -60N ~ -40N
      set SPSIO_file = \${SAVE_ROOT}/mean_SPSIO_${var}_\${CASENAME}.pop.h.nc
      cdo -O -w -z zip_5  -sellonlatbox,20,120,-60,-40 \${merge_file} ${homedir}/test_ctl_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_${var}.nc \${SPSIO_file}

    end
  end
end
rm -f ${homedir}/test_ctl_sqr_bias_${var}.nc ${homedir}/test_ctl_msqr_bias_${var}.nc
rm -f ${homedir}/test_ctl_selbox_${var}.nc
EOF

csh $tmp_scr > $tmp_log &
end
