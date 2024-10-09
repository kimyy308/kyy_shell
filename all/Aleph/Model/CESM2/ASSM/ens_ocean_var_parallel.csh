#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3)
#set vars = (NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( U V PS )
foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_assm_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ocn/${var}
set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/ocn/${var}/ens_all
mkdir -p \$SAVE_ROOT
set CASENAME_SET = ( \`ls \${ARC_ROOT}/*/merged/*.nc\` )

cdo -O -ensmean \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensmean.nc
#cdo -O -ensstd \${CASENAME_SET} \${SAVE_ROOT}/${var}_ensstd.nc
#cdo -O -timmean \${SAVE_ROOT}/${var}_ensstd.nc \${SAVE_ROOT}/${var}_time_mean_spread.nc
#cdo -O -timmean \${SAVE_ROOT}/${var}_ensmean.nc \${SAVE_ROOT}/${var}_time_mean_ensmean.nc
#cdo -O -timstd \${SAVE_ROOT}/${var}_ensmean.nc \${SAVE_ROOT}/${var}_time_std_ensmean.nc
#cdo -O -div \${SAVE_ROOT}/${var}_time_std_ensmean.nc \${SAVE_ROOT}/${var}_time_mean_spread.nc \${SAVE_ROOT}/${var}_SNR.nc

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
