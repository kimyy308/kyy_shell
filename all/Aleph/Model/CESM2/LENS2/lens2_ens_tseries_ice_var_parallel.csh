#!/bin/csh
####!/bin/csh -fx
# Updated  03-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


set vars = ( aice sithick )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_tseries_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive
#set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ice/${var}/ens_all
set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries/ice/${var}/ens_smbb
#mkdir -p \$SAVE_ROOT
mkdir -p \$SAVE_ROOT_smbb


set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )

foreach period ( \${period_set_hist} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ice/proc/tseries/month_1/*.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb/*${var}*\${period}.nc\` )
echo \${CASENAME_SET}
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_\${period}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_\${period}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_\${period}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*

foreach period ( \${period_set_ssp} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BSSP370smbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/ice/proc/tseries/month_1/*.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb/*${var}*\${period}.nc\` )
echo \${CASENAME_SET}
cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmean_\${period}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensstd_\${period}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmax_\${period}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*




EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
