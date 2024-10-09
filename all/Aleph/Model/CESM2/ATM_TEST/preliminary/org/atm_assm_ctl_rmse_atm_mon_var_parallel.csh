#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( AODDUST dst_a2SF dst_a2_SRF SFdst_a2 SST CLOUD RELHUM  )
set vars = ( U10  )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/RMSE_${var}_atm_ctl_assm_tmp.csh
set tmp_log =  ~/tmp_log/RMSE_${var}_atm_ctl_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (20)
set mbr_set = (1)
set RESOLN = f09_g17
set siy = 2015
set eiy = 2019
set outfreq = mon
#set Y_SET = ( \`seq \${siy} +1 \${eiy}\` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set scen = BSSP370smbb
foreach OBS ( \${OBS_SET} ) #OBS loop1
  foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
    foreach mbr ( \$mbr_set ) #mbr loop1
      set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set OBS_CASENAME = f09_g17.assm.projdv7.3_ba-10p1
#      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive/\${CASENAME_M}
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${CASENAME} 
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${CASENAME}/RMSE
      mkdir -p \$SAVE_ROOT
      
      set OBS_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${OBS_CASENAME}
      set OBS_SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${OBS_CASENAME}/RMSE
      mkdir -p \$OBS_SAVE_ROOT

      set input_head = \${ARC_ROOT}/*${var}*.cam.h0.????-??.nc
      set input_set=(\`ls \${input_head}*\`)
      set merge_file = \${SAVE_ROOT}/merged_${var}_\${CASENAME}.cam.h0.nc
      set ck_mfile = \`ls \${merge_file}\`
      if ( \${ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${input_set} \${merge_file} 
      endif
      
      set OBS_input_head = \${OBS_ROOT}/*${var}*.cam.h0.????-??.nc
      set OBS_input_set=(\`ls \${OBS_input_head}*\`)
      set OBS_merge_file = \${OBS_SAVE_ROOT}/merged_${var}_\${OBS_CASENAME}.cam.h0.nc
      set OBS_ck_mfile = \`ls \${OBS_merge_file}\`
      if ( \${OBS_ck_mfile} == "" ) then
        cdo -O -w -z zip_5 -mergetime \${OBS_input_set} \${OBS_merge_file} 
      endif
      
      set bias_file = \${SAVE_ROOT}/bias_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -sub \${merge_file} \${OBS_merge_file} \${bias_file}      
      set mbias_file = \${SAVE_ROOT}/mean_bias_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -timmean \${bias_file} \${mbias_file}
      
      
      cdo -O -w -z zip_5 -sqr \${bias_file} ${homedir}/test_ctl_sqr_bias_${var}.nc
      cdo -O -w -z zip_5 -timmean  ${homedir}/test_ctl_sqr_bias_${var}.nc ${homedir}/test_ctl_msqr_bias_${var}.nc
      set RMSE_file = \${SAVE_ROOT}/RMSE_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -sqrt ${homedir}/test_ctl_msqr_bias_${var}.nc \${RMSE_file}
     
        
      ### absolute error field mean
      #ArcTic Ocean 0E ~ 360E(0W), 70N ~ 90N
      set ATO_bias_file = \${SAVE_ROOT}/mean_bias_ATO_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,0,360,70,90 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${ATO_bias_file}
      
      #SubPolar North Pacific 120E ~ 240E(120W), 40N ~ 70N
      set SPNP_bias_file = \${SAVE_ROOT}/mean_bias_SPNP_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,120,240,40,70 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${SPNP_bias_file}

      #SubTropical North Pacific 100E ~ 260E(100W), 20N ~ 40N
      set STNP_bias_file = \${SAVE_ROOT}/mean_bias_STNP_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,100,260,20,40 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${STNP_bias_file}

      #Tropical Pacific 120E ~ 280E(100W), -20N ~ 20N
      set TP_bias_file = \${SAVE_ROOT}/mean_bias_TP_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,120,280,-20,20 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${TP_bias_file}

      #SubTropical South Pacific 140E ~ 290E(70W), -40N ~ -20N
      set STSP_bias_file = \${SAVE_ROOT}/mean_bias_STSP_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,140,290,-40,-20 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${STSP_bias_file}

      #SubPolar South Pacific 140E ~ 290E(70W), -60N ~ -40N
      set SPSP_bias_file = \${SAVE_ROOT}/mean_bias_SPSP_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,140,290,-60,-40 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${SPSP_bias_file}

      #ANtarctic Ocean 0E ~ 360E(0W), -80N ~ -60N
      set ANO_bias_file = \${SAVE_ROOT}/mean_bias_ANO_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,0,360,-80,-60 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${ANO_bias_file}

      #SubPolar North Atlantic 260E(100W) ~ 360E(0W), 40N ~ 70N
      set SPNA_bias_file = \${SAVE_ROOT}/mean_bias_SPNA_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,260,360,40,70 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${SPNA_bias_file}

      #SubTropical North Atlantic 260E(100W) ~ 360E(0W), 20N ~ 40N
      set STNA_bias_file = \${SAVE_ROOT}/mean_bias_STNA_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,260,360,20,40 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${STNA_bias_file}

      #Tropical Atlantic 280E(80W) ~ 20E, -20N ~ 20N
      set TA_bias_file = \${SAVE_ROOT}/mean_bias_TA_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,-80,20,-20,20 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${TA_bias_file}
      
      #SubTropical South Atlantic 300E(60W) ~ 20E, -40N ~ -20N
      set STSA_bias_file = \${SAVE_ROOT}/mean_bias_STSA_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,-60,20,-40,-20 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${STSA_bias_file}

      #SubPolar South Atlantic 290E(-70W) ~ 20E, -60N ~ -40N
      set SPSA_bias_file = \${SAVE_ROOT}/mean_bias_SPSA_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,-70,20,-60,-40 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${SPSA_bias_file}

      #Northern Indian Ocean 40E ~ 100E, -10N ~ 30N
      set NIO_bias_file = \${SAVE_ROOT}/mean_bias_NIO_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,40,100,-10,30 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${NIO_bias_file}

      #SubTropical Southern Indian Ocean 20E ~ 120E, -40N ~ -10N
      set STSIO_bias_file = \${SAVE_ROOT}/mean_bias_STSIO_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,20,120,-40,-10 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${STSIO_bias_file}

      #SubPolar Southern Indian Ocean 20E ~ 120E, -60N ~ -40N
      set SPSIO_bias_file = \${SAVE_ROOT}/mean_bias_SPSIO_${var}_\${CASENAME}.cam.h0.nc
      cdo -O -w -z zip_5 -abs -sellonlatbox,20,120,-60,-40 \${bias_file} ${homedir}/test_ctl_selbox_bias_${var}.nc
      cdo -O -w -z zip_5 -fldmean ${homedir}/test_ctl_selbox_bias_${var}.nc \${SPSIO_bias_file}

    end
  end
end
rm -f ${homedir}/test_ctl_sqr_bias_${var}.nc ${homedir}/test_ctl_msqr_bias_${var}.nc
rm -f ${homedir}/test_ctl_selbox_bias_${var}.nc
EOF

csh $tmp_scr > $tmp_log &
end
