#!/bin/csh
####!/bin/csh -fx
# Updated  13-Sep-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#set vars = ( AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT  )
#20230913
set vars = ( TS PSL SST PRECT RELHUM Q )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_tseries_season_${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/ens_tseries_season_${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set seasons = ( JFM AMJ JAS OND )
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/jedwards/archive


set period_set_hist = ( 196001-196912 197001-197912 198001-198912 199001-199912 200001-200912 201001-201412 )
set period_set_ssp = ( 201501-202412 202501-203412 )
#set period_set_hist = ( 196001-196912 )
#set period_set_ssp = ( 201501-202412 )
foreach season ( \${seasons} )

set SAVE_ROOT_smbb = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries_seasonal/atm/${var}/ens_smbb/\${season}
mkdir -p \$SAVE_ROOT_smbb

switch( \${season} )
  case "JFM":
    set M_SET = ( 01 02 03 )
    set M_RANGE = 3 # mean range
    breaksw
  case "AMJ":
    set M_SET = ( 04 05 06 )
    set M_RANGE = 3 # mean range
    breaksw
  case "JAS":
    set M_SET = ( 07 08 09 )
    set M_RANGE = 3 # mean range
    breaksw
  case "OND":
    set M_SET = ( 10 11 12 )
    set M_RANGE = 3 # mean range
    breaksw
endsw
@ SM = \${M_SET[1]} - 1 #skip momnth (start month -1 )
@ M_INTERVAL = 12 - \${M_RANGE} #skip interval between averaged months


foreach period ( \${period_set_hist} )


cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BHISTsmbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/atm/proc/tseries/month_1/*.cam.h0.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end


mkdir -p \${SAVE_ROOT_smbb}/smbb_seasonal
foreach smbbnum ( \${smbb_set} )
  set mfile = \`ls \${SAVE_ROOT_smbb}/smbb/* | grep \${smbbnum}\`
  echo \${mfile}
  set yfile = \${SAVE_ROOT_smbb}/smbb_seasonal/\${smbbnum}_smean.nc
  cdo -w timselmean,\${M_RANGE},\${SM},\${M_INTERVAL} \${mfile} \${yfile}
end



set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_seasonal/*smean.nc\` )
echo \${CASENAME_SET}
foreach rawfile ( \${CASENAME_SET} )
  cdo -w -selvar,${var} \${rawfile} \${rawfile}.selvar
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_seasonal/*.nc.selvar\` )

cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensmean_\${period}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensstd_\${period}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensmax_\${period}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*
rm -f \${SAVE_ROOT_smbb}/smbb_seasonal/*


#####future

foreach period ( \${period_set_ssp} )

cd \${ARC_ROOT}
mkdir -p \${SAVE_ROOT_smbb}/smbb
set smbb_set = ( \`ls /proj/jedwards/archive/ | grep BSSP370smbb | grep -v smbbext\` )
rm -f \${SAVE_ROOT_smbb}/smbb/*
foreach smbbnum ( \${smbb_set} )
  ln -sf \${ARC_ROOT}/\${smbbnum}/atm/proc/tseries/month_1/*.cam.h0.${var}.\${period}.nc \${SAVE_ROOT_smbb}/smbb/
end

mkdir -p \${SAVE_ROOT_smbb}/smbb_seasonal
foreach smbbnum ( \${smbb_set} )
  set mfile = \`ls \${SAVE_ROOT_smbb}/smbb/* | grep \${smbbnum}\`
  set yfile = \${SAVE_ROOT_smbb}/smbb_seasonal/\${smbbnum}_smean.nc
  cdo -w timselmean,\${M_RANGE},\${SM},\${M_INTERVAL} \${mfile} \${yfile}
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_seasonal/*smean.nc\` )
foreach rawfile ( \${CASENAME_SET} )
  cdo -w -selvar,${var} \${rawfile} \${rawfile}.selvar
end

set CASENAME_SET = ( \`ls \${SAVE_ROOT_smbb}/smbb_seasonal/*.nc.selvar\` )
echo \${CASENAME_SET}

cdo -O -w -z zip_5 -ensmean \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensmean_\${period}.nc
cdo -O -w -z zip_5 -ensstd \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensstd_\${period}.nc
cdo -O -w -z zip_5 -ensmax \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensmax_\${period}.nc
cdo -O -w -z zip_5 -ensmin \${CASENAME_SET} \${SAVE_ROOT_smbb}/${var}_\${season}_ensmin_\${period}.nc

end
rm -f \${SAVE_ROOT_smbb}/smbb/*
rm -f \${SAVE_ROOT_smbb}/smbb_seasonal/*

end


EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
