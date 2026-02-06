#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2026 by Yong-Yub Kim, e-mail: yongyub.kim@uib.no

set homedir = /proj/kimyy/tmp
#set vars = ( TEMP SALT UVEL VVEL PD DIC ALK WVEL diatChl diazChl spChl Fe NO3 NH4 SiO3 PO4 DOP PAR_avg zooC photoC_TOT )
#20231026
#set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231101
#set vars = ( photoC_TOT_zint )
set vars = ( photoC_TOT_zint SSS2 photoC_TOT photoC_diat_zint photoC_diaz_zint photoC_sp_zint spC diatC diazC NO3 PO4 TEMP SALT Fe SiO3)

foreach var ( ${vars} )

mkdir -p ~/tmp_script
mkdir -p ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_hcst_ens_tseries_tmp.csh
set tmp_log =  ~/tmp_log/${var}_hcst_ens_tseries_tmp.log

set siy = 2020
set eiy = 1960

cat > $tmp_scr << EOF
#!/bin/csh
set siy = $siy
set eiy = $eiy
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )

foreach iyloop ( \${IY_SET} )
  set INITY = \${iyloop}
  @ fy_end = \${INITY} + 4

  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive_ensmean/ENSMEAN_i\${INITY}/ocn/month_1
  set ARC_TS_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/\*/\*i\${INITY}/ocn/proc/tseries/month_1

  mkdir -p \$SAVE_ROOT

  # -------------------------------
  # unique tmp dir per run
  # -------------------------------
  set RUNID = \$\$
  set TMPDIR = \$SAVE_ROOT/tmp_sel_${var}_i\${INITY}_\${RUNID}
  mkdir -p \$TMPDIR

  # -------------------------------
  # variable selection per file
  # -------------------------------
  foreach f ( \${ARC_TS_ROOT}/*.${var}.* )
    cdo -s -O -L -w -z zip_5 selname,${var} "\$f" "\$TMPDIR/\`basename \$f\`"
  end

  # -------------------------------
  # ensemble mean
  # -------------------------------
  cdo -s -O -L -w -z zip_5 ensmean \
    \$TMPDIR/*.nc \
    \$SAVE_ROOT/f09_g17.hcst.ENSMEAN_i\${INITY}.pop.h.${var}.\${INITY}01-\${fy_end}12.nc

  # -------------------------------
  # cleanup (this run only)
  # -------------------------------
  rm -f \$TMPDIR/*.nc
  rmdir \$TMPDIR

end
EOF

csh $tmp_scr > $tmp_log &
end
