#!/bin/csh
####!/bin/csh -fx
# Updated  07-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3 SiO3 PO4)
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = (NO3)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
set vars = ( CLOUD OMEGA Q RELHUM U V AODDUST dry_deposition_NOy_as_N dry_deposition_NHx_as_N dst_a1SF dst_a1_SRF dst_a2SF dst_a2DDF dst_a2SFWET dst_a2_SRF dst_a3SF dst_a3_SRF FSNS FSDS PRECT PSL SFdst_a1 SFdst_a2 SFdst_a3 TAUX TAUY TS U10 wet_deposition_NHx_as_N wet_deposition_NOy_as_N )
foreach var ( ${vars} )

mkdir ~/tmp_script
set tmp_scr =  ~/tmp_script/yearly_det_${var}_assm_tmp.csh

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive/atm/${var}
set ARC_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/atm/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.assm.\` ) 
foreach CASENAME ( \${CASENAME_SET} )
  set SAVE_ROOT = \${ARC_ROOT}/\${CASENAME}/merged
  set SAVE_Y_ROOT = \${ARC_Y_ROOT}/\${CASENAME}/merged
  mkdir -p \$SAVE_ROOT
  mkdir -p \$SAVE_Y_ROOT
#  cdo -O -yearmean \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
  cdo -O -timselmean,12,0,0 \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
#  ncap2 -O -s 'where(time==715581) {time=715566;}' \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
  cdo -O -detrend \${SAVE_Y_ROOT}/${var}_yearly_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc \${SAVE_Y_ROOT}/${var}_yearly_det_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
  #echo "cdo -O -mergetime "\${FILE_SET} \${SAVE_ROOT}/${var}_\${RESOLN}.assm.\${CASENAME}.cam.h0.nc
  #sleep 3s
end 

EOF

csh $tmp_scr &
end
