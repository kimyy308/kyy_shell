#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT WVEL2 NO3 SiO3 PO4 UVEL VVEL PD UE_PO4 VN_PO4 WT_PO4 Fe diatC diazC spC )
#set vars_2d = ( WVEL2 BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH IRON_FLUX HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )

#set vars = ( diatFe diatP diatSi diaz_agg diaz_Nfix diazP dust_FLUX_IN dust_REMIN O2 photoFe_diat photoFe_diaz photoFe_sp photoNO3_diat photoNO3_diaz photoNO3_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake sp_agg spFe spP zooC )
#set vars_2d = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )

set vars = ( diat_agg diazFe photoC_NO3_TOT photoC_TOT )
set vars_2d = ( POC_FLUX_100m )

set FAC = 20

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_atm_ctl_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_atm_ctl_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
#set FACTOR_SET = (20) #EXP-OCN
#set FACTOR_SET = (10) #EXP-CTL
set FACTOR_SET = ( ${FAC} ) #EXP-CTL
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
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive/\${CASENAME_M}
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
      mkdir -p \$SAVE_ROOT

      set input_head = \${ARC_ROOT}/ocn/hist/\${CASENAME_M}.pop.h.????-??.nc
      set input_set=(\`ls \${input_head}*\`)
      foreach inputname ( \${input_set} )
        set outputnc=(\`echo \${inputname} | cut -d '/' -f 11\`)
        set outputnc_new=(\`echo \${outputnc} | sed "s/\${RESOLN}/${var}_\${outfreq}_\${RESOLN}/g"\`)
        set outputname = \${SAVE_ROOT}/\${outputnc_new}
        echo "cdo -O select,name="${var}" "\$inputname" "\$outputname
        cdo -O -w -z zip_5 select,name=${var} \$inputname ${homedir}/test_ctl_atm_assm_extract_ocn_${var}.nc
        cdo -O -w -z zip_5 -sellevel,500/15000 ${homedir}/test_ctl_atm_assm_extract_ocn_${var}.nc  \$outputname 
      end
    end
  end
end
rm -f ${homedir}/test_ctl_atm_assm_extract_ocn_${var}.nc
#rm -f ${homedir}/test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end

foreach var ( ${vars_2d} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_atm_ctl_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_atm_ctl_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
#set FACTOR_SET = (20) #EXP-OCN
#set FACTOR_SET = (10) #EXP-CTL
set FACTOR_SET = ( ${FAC} ) #EXP-CTL
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
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive/\${CASENAME_M}
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
      mkdir -p \$SAVE_ROOT

      set input_head = \${ARC_ROOT}/ocn/hist/\${CASENAME_M}.pop.h.????-??.nc
      set input_set=(\`ls \${input_head}*\`)
      foreach inputname ( \${input_set} )
        set outputnc=(\`echo \${inputname} | cut -d '/' -f 11\`)
        set outputnc_new=(\`echo \${outputnc} | sed "s/\${RESOLN}/${var}_\${outfreq}_\${RESOLN}/g"\`)
        set outputname = \${SAVE_ROOT}/\${outputnc_new}
        echo "cdo -O select,name="${var}" "\$inputname" "\$outputname
        cdo -O -w -z zip_5 select,name=${var} \$inputname \$outputname 
      end
    end
  end
end
#rm -f ${homedir}/test_ctl_atm_assm_extract_ocn_${var}.nc
#rm -f ${homedir}/test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
