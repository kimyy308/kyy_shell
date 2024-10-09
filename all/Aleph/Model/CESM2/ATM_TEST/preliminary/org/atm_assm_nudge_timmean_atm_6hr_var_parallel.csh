#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set vars = ( PRECT PRECC PRECL PSL U850 UBOT V850 VBOT uIVT vIVT IVT U V PS T Q )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/MEAN_${var}_atm_NUDGE_assm_tmp.csh
set tmp_log =  ~/tmp_log/MEAN_${var}_atm_NUDGE_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (20)
set mbr_set = (1)
set RESOLN = f09_g17
set siy = 2015
set eiy = 2019
set outfreq = 6hr
#set Y_SET = ( \`seq \${siy} +1 \${eiy}\` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set scen = BSSP370smbb
foreach OBS ( \${OBS_SET} ) #OBS loop1
  foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
    foreach mbr ( \$mbr_set ) #mbr loop1
      set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set OBS_CASENAME = f09_g17.assm.projdv7.3_ba-10p1
#      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_NUDGE_ASSM_EXP/archive/\${CASENAME_M}
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_NUDGE_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${CASENAME} 
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_NUDGE_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${CASENAME}/MEAN
      set SAVE_RMSE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_NUDGE_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${CASENAME}/RMSE
      mkdir -p \$SAVE_ROOT
      
      set OBS_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${OBS_CASENAME}
      set OBS_SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${OBS_CASENAME}/MEAN
      set OBS_SAVE_RMSE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${OBS_CASENAME}/RMSE
      mkdir -p \$OBS_SAVE_ROOT

      set input_head = \${ARC_ROOT}/*${var}*.cam.h2.????-??-??-?????.nc
      set input_set=(\`ls \${input_head}*\`)
      set merge_file = \${SAVE_RMSE_ROOT}/merged_${var}_\${CASENAME}.cam.h2.nc
      set ck_mfile = \`ls \${merge_file}\`
      if ( \${ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${input_set} \${merge_file} 
      endif
      
      set OBS_input_head = \${OBS_ROOT}/*${var}*.cam.h2.????-??-??-?????.nc
      set OBS_input_set=(\`ls \${OBS_input_head}*\`)
      set OBS_merge_file = \${OBS_SAVE_RMSE_ROOT}/merged_${var}_\${OBS_CASENAME}.cam.h2.nc
      set OBS_ck_mfile = \`ls \${OBS_merge_file}\`
      if ( \${OBS_ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${OBS_input_set} \${OBS_merge_file} 
      endif
      
      set MEAN_file = \${SAVE_ROOT}/MEAN_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5 -timmean \${merge_file} \${MEAN_file}
     
        
      ### absolute error field mean
      #ArcTic Ocean 0E ~ 360E(0W), 70N ~ 90N
      set ATO_file = \${SAVE_ROOT}/mean_ATO_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,0,360,70,90 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${ATO_file}
      
      #SubPolar North Pacific 120E ~ 240E(120W), 40N ~ 70N
      set SPNP_file = \${SAVE_ROOT}/mean_SPNP_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,120,240,40,70 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${SPNP_file}

      #SubTropical North Pacific 100E ~ 260E(100W), 20N ~ 40N
      set STNP_file = \${SAVE_ROOT}/mean_STNP_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,100,260,20,40 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${STNP_file}

      #Tropical Pacific 120E ~ 280E(100W), -20N ~ 20N
      set TP_file = \${SAVE_ROOT}/mean_TP_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,120,280,-20,20 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${TP_file}

      #SubTropical South Pacific 140E ~ 290E(70W), -40N ~ -20N
      set STSP_file = \${SAVE_ROOT}/mean_STSP_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,140,290,-40,-20 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${STSP_file}

      #SubPolar South Pacific 140E ~ 290E(70W), -60N ~ -40N
      set SPSP_file = \${SAVE_ROOT}/mean_SPSP_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,140,290,-60,-40 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${SPSP_file}

      #ANtarctic Ocean 0E ~ 360E(0W), -80N ~ -60N
      set ANO_file = \${SAVE_ROOT}/mean_ANO_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,0,360,-80,-60 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${ANO_file}

      #SubPolar North Atlantic 260E(100W) ~ 360E(0W), 40N ~ 70N
      set SPNA_file = \${SAVE_ROOT}/mean_SPNA_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,260,360,40,70 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${SPNA_file}

      #SubTropical North Atlantic 260E(100W) ~ 360E(0W), 20N ~ 40N
      set STNA_file = \${SAVE_ROOT}/mean_STNA_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,260,360,20,40 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${STNA_file}

      #Tropical Atlantic 280E(80W) ~ 20E, -20N ~ 20N
      set TA_file = \${SAVE_ROOT}/mean_TA_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,-80,20,-20,20 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${TA_file}
      
      #SubTropical South Atlantic 300E(60W) ~ 20E, -40N ~ -20N
      set STSA_file = \${SAVE_ROOT}/mean_STSA_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,-60,20,-40,-20 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${STSA_file}

      #SubPolar South Atlantic 290E(-70W) ~ 20E, -60N ~ -40N
      set SPSA_file = \${SAVE_ROOT}/mean_SPSA_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,-70,20,-60,-40 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${SPSA_file}

      #Northern Indian Ocean 40E ~ 100E, -10N ~ 30N
      set NIO_file = \${SAVE_ROOT}/mean_NIO_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,40,100,-10,30 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${NIO_file}

      #SubTropical Southern Indian Ocean 20E ~ 120E, -40N ~ -10N
      set STSIO_file = \${SAVE_ROOT}/mean_STSIO_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,20,120,-40,-10 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${STSIO_file}

      #SubPolar Southern Indian Ocean 20E ~ 120E, -60N ~ -40N
      set SPSIO_file = \${SAVE_ROOT}/mean_SPSIO_${var}_\${CASENAME}.cam.h2.nc
      cdo -O -w -z zip_5  -sellonlatbox,20,120,-60,-40 \${merge_file} ${homedir}/test_NUDGE_selbox_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_NUDGE_selbox_${var}.nc \${SPSIO_file}

    end
  end
end
rm -f ${homedir}/test_NUDGE_sqr_bias_${var}.nc ${homedir}/test_NUDGE_msqr_bias_${var}.nc
rm -f ${homedir}/test_NUDGE_selbox_${var}.nc
EOF

csh $tmp_scr > $tmp_log &
end
