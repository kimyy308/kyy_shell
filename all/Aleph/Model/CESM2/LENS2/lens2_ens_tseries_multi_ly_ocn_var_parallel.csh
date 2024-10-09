#!/bin/csh
####!/bin/csh -fx
# Updated  23-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#20231017
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT ) # 2 ~ 5
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT ) # 2 ~ 4
#20231018
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT) # 2 ~ 5
#20231103
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT) # 2 ~ 4
#20231123
set vars = ( PAR_avg Jint_100m_NO3 tend_zint_100m_NO3 )

set ly_s = 2
set ly_e = 4
@ ly_l = ${ly_e} - ${ly_s} + 1

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_multi_ly_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_tseries_multi_ly_${var}_lens2_tmp.log

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
  cdo -w -selvar,${var} \${rawfile} \${rawfile}.\${period}.selvar
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.\${period}.selvar\` )

#cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmean_\${period}.nc
#cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensstd_\${period}.nc
#cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmax_\${period}.nc
#cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmin_\${period}.nc

end

rm -f \${SAVE_ROOT_smbb}/smbb/*
rm -f \${SAVE_ROOT_smbb}/smbb_yearly/*.nc


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
  cdo -w -selvar,${var} \${rawfile} \${rawfile}.\${period}.selvar
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.\${period}.selvar\` )
echo \${CASENAME_SET}

#cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmean_\${period}.nc
#cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensstd_\${period}.nc
#cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmax_\${period}.nc
#cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_y_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*
rm -f \${SAVE_ROOT_smbb}/smbb_yearly/*.nc

foreach smbbnum ( \${smbb_set} )
  set smbbnum2 = \`echo \${smbbnum} | cut -d '.' -f 5-6\`
  cdo -mergetime \${SAVE_ROOT_smbb}/smbb_yearly/*\${smbbnum2}*.nc.*.selvar \${SAVE_ROOT_smbb}/smbb_yearly/\${smbbnum2}_ymean.nc.selvar_comb
  cdo runmean,${ly_l} \${SAVE_ROOT_smbb}/smbb_yearly/\${smbbnum2}_ymean.nc.selvar_comb \${SAVE_ROOT_smbb}/smbb_yearly/\${smbbnum}_ymean.nc.selvar_comb_runm
end

cdo -O -w -z zip_5 -ensmean \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.selvar_comb_runm \${SAVE_ROOT_smbb}/${var}_y_ensmean_runm_${ly_l}.nc
cdo -O -w -z zip_5 -ensstd \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.selvar_comb_runm \${SAVE_ROOT_smbb}/${var}_y_ensstd_runm_${ly_l}.nc
cdo -O -w -z zip_5 -ensmax \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.selvar_comb_runm \${SAVE_ROOT_smbb}/${var}_y_ensmax_runm_${ly_l}.nc
cdo -O -w -z zip_5 -ensmin \${SAVE_ROOT_smbb}/smbb_yearly/*.nc.selvar_comb_runm \${SAVE_ROOT_smbb}/${var}_y_ensmin_runm_${ly_l}.nc


rm -f \${SAVE_ROOT_smbb}/smbb_yearly/*

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
