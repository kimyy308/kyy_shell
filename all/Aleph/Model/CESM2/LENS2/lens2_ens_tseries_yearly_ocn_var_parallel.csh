#!/bin/csh
####!/bin/csh -fx
# Updated  06-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#20231006
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT)
#20231008
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT )
#20231026
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231101
set vars = ( pH_3D )
set vars = ( diatChl spChl diazChl diatC spC diazC )
#20231106
set vars = ( pH_3D )
set vars = ( ALK CO3 DIC DIC_ALT_CO2 DOC POC_FLUX_IN )
#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20231123
set vars = ( PAR_avg )
#20231124
set vars = ( Jint_100m_Fe tend_zint_100m_Fe  Jint_100m_NH4 tend_zint_100m_NH4 Jint_100m_PO4 tend_zint_100m_PO4 Jint_100m_SiO3 tend_zint_100m_SiO3 diaz_Nfix photoNO3_diat photoNO3_diaz photoNO3_sp photoNH4_diat photoNH4_diaz photoNH4_sp photoFe_diat photoFe_diaz photoFe_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_y_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_tseries_y_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries_yearly/ocn/${var}/ens_smbb
mkdir -p \$SAVE_ROOT_smbb


set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )
#set period_set_hist = ( 196001-196912 )
#set period_set_ssp = ( )

foreach period ( \${period_set_hist} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end


mkdir -p \${SAVE_ROOT_smbb}/smbb_yearly
foreach smbbnum ( \${smbb_set} )
  set mfile = \`ls \${SAVE_ROOT_smbb}/smbb/* | grep \${smbbnum}\`
  echo \${mfile}
  set yfile = \${SAVE_ROOT_smbb}/smbb_yearly/\${smbbnum}_ymean.nc
  cdo -w timselmean,12,0,0 \${mfile} \${yfile}
end



set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_yearly/*ymean.nc\` )
echo \${CASENAME_SET}
foreach rawfile ( \${CASENAME_SET} )
  cdo -w -selvar,${var} \${rawfile} \${rawfile}.selvar
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.selvar\` )

cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmean_\${period}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensstd_\${period}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmax_\${period}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmin_\${period}.nc

end



rm -f \${SAVE_ROOT_smbb}/smbb/*
rm -f \${SAVE_ROOT_smbb}/smbb_yearly/*


#####future

foreach period ( \${period_set_ssp} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BSSP370smbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ocn/proc/tseries/month_1/*.pop.h.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end

mkdir -p \${SAVE_ROOT_smbb}/smbb_yearly
foreach smbbnum ( \${smbb_set} )
  set mfile = \`ls \${SAVE_ROOT_smbb}/smbb/* | grep \${smbbnum}\`
  set yfile = \${SAVE_ROOT_smbb}/smbb_yearly/\${smbbnum}_ymean.nc
  cdo -w timselmean,12,0,0 \${mfile} \${yfile}
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_yearly/*ymean.nc\` )
foreach rawfile ( \${CASENAME_SET} )
  cdo -w -selvar,${var} \${rawfile} \${rawfile}.selvar
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.selvar\` )
echo \${CASENAME_SET}

cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmean_\${period}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensstd_\${period}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmax_\${period}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*
rm -f \${SAVE_ROOT_smbb}/smbb_yearly/*




EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
