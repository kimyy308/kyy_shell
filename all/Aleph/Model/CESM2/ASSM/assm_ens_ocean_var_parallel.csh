#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 diatC diazC spC )
#set vars = ( diatC diazC spC )
#set vars = ( UVEL VVEL SSH )
#set vars = ( photoC_TOT_zint_100m )
set vars = ( diatChl spChl diazChl NO3 PO4 SiO3 Fe PAR_avg diatC diazC PD SALT spC TEMP UVEL VVEL WVEL WVEL2 O2 )
#set vars = ( SSH diatChl spChl diazChl photoC_TOT_zint UVEL VVEL )
#set vars = ( photoC_TOT_zint_100m NO3 PO4 SiO3 Fe )
#set vars = ( SSH photo_TOT_zint diatChl diazChl spChl UVEL VVEL )
#set vars = ( photoC_TOT_zint )
#set vars = ( diatFe diatP diatSi diaz_agg diaz_Nfix diazP dust_FLUX_IN dust_REMIN O2 photoFe_diat photoFe_diaz photoFe_sp photoNO3_diat photoNO3_diaz photoNO3_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake sp_agg spFe spP zooC )
#set vars = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )
#set vars = ( diaz_loss_zint_100m )
#set vars = ( IRON_FLUX HMXL HBLT diatC_zint_100m_2 diazC_zint_100m_2 BSF )
#set vars = ( spC_zint_100m_2 )
#set vars = ( PAR_avg diatC diazC PD SALT spC TEMP WVEL WVEL2 O2 )
#set vars = ( SALT TEMP WVEL )
set vars = ( diat_Qp sp_Qp diaz_Qp ) 
set vars = ( zooC ) 
#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20240221
set vars = ( FG_CO2 DIC DIC_ALT_CO2 )
#20240307
set vars = ( TEMP SALT )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2020
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}
set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}/ens_all

set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` )

set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )
  foreach mon ( \${M_SET} )
    set INITY = \${iyloop}
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*\${iyloop}-\${mon}*.nc\` )
    set SAVE_ROOT = \${ARC_ROOT}/ens_all
    mkdir -p \$SAVE_ROOT
    cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_\${INITY}-\${mon}.nc
#    cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_ensmax_\${INITY}-\${mon}.nc
#    cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_ensmin_\${INITY}-\${mon}.nc
#    cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_ensstd_\${INITY}-\${mon}.nc
    ###en4
      set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*en4.2_ba*\${iyloop}-\${mon}*.nc\` )
#    cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_i\${INITY}.nc
#    cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmax_i\${INITY}.nc
#    cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmin_i\${INITY}.nc
#    cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensstd_i\${INITY}.nc
    ###projdv7.3_ba
      set FILE_SET = (\`ls \${ARC_ROOT}/*/*\${RESOLN}*projdv7.3_ba*\${iyloop}-\${mon}*.nc\` )
#    cdo -O -L -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_i\${INITY}.nc
#    cdo -O -L -z zip_5 -ensmax \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmax_i\${INITY}.nc
#    cdo -O -L -z zip_5 -ensmin \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmin_i\${INITY}.nc
#    cdo -O -L -z zip_5 -ensstd \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensstd_i\${INITY}.nc
  end
end

echo "postprocessing complete"
EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
