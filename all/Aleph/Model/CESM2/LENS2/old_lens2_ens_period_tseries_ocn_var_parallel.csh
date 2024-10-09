#!/bin/csh
####!/bin/csh -fx
# Updated  12-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr
# Updated  27-Apr-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr get arguments


#set vars = ( diatChl diazChl spChl )
#set vars = ( SSH )
#set vars = ( SSH )
#set vars = ( NO3 SiO3 PO4 Fe BSF )
#set vars = ( PAR_avg diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 IRON_FLUX )
#set vars = ( diatC diazC HBLT spC UVEL VVEL )
#set vars = ( PD SALT TEMP WVEL WVEL2 O2 )
#set vars = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m )
#set vars = ( diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf  )
#set vars = ( diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf )
#set vars = ( dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m  )
#set vars = ( graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m )
#set vars = ( photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf )
#set vars = ( sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )
#set vars = ( zoo_loss_zint_100m )


#set vars = ( $1 )


#set vars = ( diatChl )
#set vars = ( diatChl diazChl spChl NO3 SiO3 PO4 Fe PAR_avg ALK diatC diazC DIC PD SALT spC TEMP UVEL VVEL WVEL WVEL2 O2 zooC )
#set vars = ( NO3 SiO3 PO4 Fe )
#set vars = ( UVEL VVEL WVEL )
#set vars = ( PD SALT TEMP WVEL2 )
#set vars = ( PAR_avg )
#set vars = ( WVEL )
set vars = ( UVEL )





set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )

foreach var ( ${vars} )
foreach period ( ${period_set_hist} )


mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_${var}_lens2_tmp_${period}.csh
set tmp_log =  ~/tmp_log/ens_tseries_${var}_lens2_tmp_${period}.log

cat > $tmp_scr << EOF
#!/bin/csh
module load cdo
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive
#set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ocn/${var}/ens_all
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ocn/${var}/ens_smbb
#mkdir -p \$SAVE_ROOT
mkdir -p \$SAVE_ROOT_smbb

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb_${period}
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.${var}.${period}.nc \${SAVE_ROOT_smbb}/smbb_${period}/
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_${period}/*${var}*${period}.nc\` )
#echo \${CASENAME_SET}
#aprun -n 1 -N 1 -d 10 cdo -P 10 -O -L -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_${period}.nc  
#aprun -n 1 -N 1 -d 10 cdo -P 10 -O -L -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_${period}.nc 
#aprun -n 1 -N 1 -d 10 cdo -P 10 -O -L -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_${period}.nc 
#aprun -n 1 -N 1 -d 10 cdo -P 10 -O -L -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_${period}.nc 
cdo -O -L -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_${period}.nc  
cdo -O -L -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_${period}.nc 
cdo -O -L -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_${period}.nc 
cdo -O -L -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_${period}.nc 

#rm -f \${SAVE_ROOT_smbb}/smbb_${period}/*

echo "postprocessing complete"
EOF

#csh -xv $tmp_scr &
csh $tmp_scr > $tmp_log &
end


foreach period ( ${period_set_ssp} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_${var}_lens2_tmp_${period}.csh
set tmp_log =  ~/tmp_log/ens_tseries_${var}_lens2_tmp_${period}.log

cat > $tmp_scr << EOF
#!/bin/csh
module load cdo
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ocn/${var}/ens_smbb
mkdir -p \$SAVE_ROOT_smbb

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb_${period}
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BSSP370smbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb_${period}/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.${var}.${period}.nc \${SAVE_ROOT_smbb}/smbb_${period}/
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_${period}/*${var}*${period}.nc\` )
#echo \${CASENAME_SET}
#aprun cdo -O -L -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_${period}.nc 
#aprun cdo -O -L -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_${period}.nc 
#aprun cdo -O -L -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_${period}.nc 
#aprun cdo -O -L -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_${period}.nc 
cdo -O -L -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_${period}.nc 
cdo -O -L -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_${period}.nc 
cdo -O -L -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_${period}.nc 
cdo -O -L -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_${period}.nc 

#rm -f \${SAVE_ROOT_smbb}/smbb_${period}/*

echo "postprocessing complete"
EOF
csh  $tmp_scr > $tmp_log &
end

end


#foreach var ( ${vars} )
#foreach period ( ${period_set_hist} )
#set tmp_scr =  ~/tmp_script/ens_tseries_${var}_lens2_tmp_${period}.csh
#set tmp_log =  ~/tmp_log/ens_tseries_${var}_lens2_tmp_${period}.log
#  set stat = pre
#  while ( ${stat} != postprocessing )
#    sleep 10s
#    set stat = ( `grep post $tmp_log | cut -d ' ' -f 1` )
#  end
#end
#end

#foreach var ( ${vars} )
#foreach period ( ${period_set_ssp} )
#set tmp_scr =  ~/tmp_script/ens_tseries_${var}_lens2_tmp_${period}.csh
#set tmp_log =  ~/tmp_log/ens_tseries_${var}_lens2_tmp_${period}.log
#  set stat = pre
#  while ( ${stat} != postprocessing )
#    sleep 10s
#    set stat = ( `grep post $tmp_log | cut -d ' ' -f 1` )
#  end
#end
#end
