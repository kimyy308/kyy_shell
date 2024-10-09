#!/bin/csh
####!/bin/csh -fx
# Updated  23-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ SNOW_PERSISTENCE RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT )
#20230907
set vars = ( SOILWATER_10CM )
#20230913
set vars = ( FAREA_BURNED NFIRE Q2M RH2M TLAI )
set vars = ( SNOW )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_y_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_tseries_y_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries_yearly/lnd/${var}/ens_smbb
mkdir -p \$SAVE_ROOT_smbb


set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )

foreach period ( \${period_set_hist} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/lnd/proc/tseries/month_1/*.clm2.h0.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
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
  ln -sf \${ARC_ROOT}/\${smbbnum}/lnd/proc/tseries/month_1/*.clm2.h0.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
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
