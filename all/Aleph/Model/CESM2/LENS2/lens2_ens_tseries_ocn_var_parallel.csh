#!/bin/csh
####!/bin/csh -fx
# Updated  12-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( diatChl diazChl spChl )
#set vars = ( SSH )
#set vars = ( SSH BSF )
#set vars = ( NO3 SiO3 PO4 Fe )
#set vars = ( UVEL VVEL TEMP )
#set vars = ( PD SALT TEMP WVEL2 )
#set vars = ( WVEL )
#set vars = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m )
#set vars = ( diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf  )
#set vars = ( diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf )
#set vars = ( dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m  )
#set vars = ( graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m )
#set vars = ( photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf )
#set vars = ( sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )

#set vars = ( NH4 DOP sp_Qp diat_Qp diaz_Qp )
#set vars = ( NH4 DOP )
#set vars = ( photoC_TOT )
#set vars = ( PD )
set vars = ( zooC )
#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20231211
set vars = ( Jint_100m_Fe tend_zint_100m_Fe  Jint_100m_NH4 tend_zint_100m_NH4 Jint_100m_PO4 tend_zint_100m_PO4 Jint_100m_SiO3 tend_zint_100m_SiO3 diaz_Nfix photoNO3_diat photoNO3_diaz photoNO3_sp photoNH4_diat photoNH4_diaz photoNH4_sp photoFe_diat photoFe_diaz photoFe_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake )
#20240219
set vars = ( DIC_ALT_CO2 DpCO2_ALT_CO2 ) 
#20240219
set vars = ( DIC_ALT_CO2 ) 
set vars = ( FG_CO2 )
#20240305
set vars = ( SALT )
#20240320
set vars = ( DIC )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_tseries_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive
#set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ocn/${var}/ens_all
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ocn/${var}/ens_smbb
#mkdir -p \$SAVE_ROOT
mkdir -p \$SAVE_ROOT_smbb


set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
#set period_set_hist = ( 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )

foreach period ( \${period_set_hist} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb/*${var}*\${period}.nc\` )
echo \${CASENAME_SET}
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_\${period}.nc
#cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_\${period}.nc
#cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_\${period}.nc
#cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*

foreach period ( \${period_set_ssp} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BSSP370smbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb/*${var}*\${period}.nc\` )
echo \${CASENAME_SET}
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_\${period}.nc
#cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_\${period}.nc
#cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_\${period}.nc
#cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*




EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
