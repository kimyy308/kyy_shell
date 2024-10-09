#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT WVEL2 NO3 SiO3 PO4 UVEL VVEL PD UE_PO4 VN_PO4 WT_PO4 Fe diatC diazC spC )
set vars_2d = ( WVEL2 BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH IRON_FLUX HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )

#set vars = ( diatFe diatP diatSi diaz_agg diaz_Nfix diazP dust_FLUX_IN dust_REMIN O2 photoFe_diat photoFe_diaz photoFe_sp photoNO3_diat photoNO3_diaz photoNO3_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake sp_agg spFe spP zooC )
#set vars_2d = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )

#set vars = ( photoC_TOT )
#set vars_2d = ( photoC_TOT_zint_100m )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_atm_NOASSM_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_atm_NOASSM_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set siy = 2015
set eiy = 2019
set outfreq = mon
set Y_SET = ( \`seq \${siy} +1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )

foreach yloop ( \${Y_SET} )
  if (\${yloop} <= 2014) then
    set scen = BHIST
  else if (\${yloop} >= 2015) then
   # set scen = BSSP370
    set scen = BSSP370smbb
  endif

  set scen = BSSP370smbb
  set ENS_ALL = ( 1231.011 )
  foreach ENS ( \${ENS_ALL} )
    set ARC_ROOT = /mnt/lustre/proj/jedwards/archive/
    cd \${ARC_ROOT}
    set CASENAME = LE2-\${ENS}
    set CASENAME_M = ( \`ls  | grep \${ENS} | grep \${scen} | grep -v ext | grep -v .nc | grep -v allfiles \` )
    set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_NOASSM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
    mkdir -p \$SAVE_ROOT
    set FILE_ROOT = \${ARC_ROOT}/\${CASENAME_M}/ocn/proc/tseries/month_1
    echo \${FILE_ROOT}
    set period_SET = ( \`ls \${FILE_ROOT}/*.${var}.*  | cut -d '.' -f 15\` )  
    foreach period ( \${period_SET} )
      set Y_1 = (\`echo \$period | cut -c 1-4\`)
      set Y_2= (\`echo \$period | cut -c 8-11\`)
      if (\$Y_1 <= \${yloop} && \${yloop} <= \$Y_2) then
        set period_f=\${period}
        echo \${period_f}, \${yloop}
        @ tind = \`expr \( \${yloop} - \${Y_1} \) \* 12\`
        #echo \${vind}
        foreach mloop ( \${M_SET} )
          @ tind2 = \$tind + \$mloop
          #echo \$tind2
          set inputname = \${FILE_ROOT}/b.e21.\${scen}.f09_g17.\${CASENAME}.pop.h.${var}.\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${yloop}-\${mloop}.nc
          #ls \$input_head
           cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/test_NOASSM_atm_assm_extract_ocn_${var}.nc
           cdo -O -w -z zip_5 -select,name=${var} ${homedir}/test_NOASSM_atm_assm_extract_ocn_${var}.nc ${homedir}/test2_NOASSM_atm_assm_extract_ocn_${var}.nc
           cdo -O -w -z zip_5 -sellevel,500/15000 ${homedir}/test2_NOASSM_atm_assm_extract_ocn_${var}.nc   \$outputname 
          #echo \${inputname}
          #echo \${outputname}
        end
      endif
    end
  end
end
rm -f ${homedir}/test_NOASSM_atm_assm_extract_ocn_${var}.nc
rm -f ${homedir}/test2_NOASSM_atm_assm_extract_ocn_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end

foreach var ( ${vars_2d} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_atm_NOASSM_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_atm_NOASSM_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set siy = 2015
set eiy = 2019
set outfreq = mon
set Y_SET = ( \`seq \${siy} +1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
  if (\${yloop} <= 2014) then
    set scen = BHIST
  else if (\${yloop} >= 2015) then
   # set scen = BSSP370
    set scen = BSSP370smbb
  endif

#  set scen = BSSP370smbb
  set ENS_ALL = ( 1231.011 )
  foreach ENS ( \${ENS_ALL} )
    set ARC_ROOT = /mnt/lustre/proj/jedwards/archive/
    cd \${ARC_ROOT}
    set CASENAME = LE2-\${ENS}
    set CASENAME_M = ( \`ls  | grep \${ENS} | grep \${scen} | grep -v ext | grep -v .nc | grep -v allfiles \` )
    set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_NOASSM_ASSM_EXP/archive_transfer/ocn/\${outfreq}/${var}/\${CASENAME} 
    mkdir -p \$SAVE_ROOT
    set FILE_ROOT = \${ARC_ROOT}/\${CASENAME_M}/ocn/proc/tseries/month_1
    echo \${FILE_ROOT}
    set period_SET = ( \`ls \${FILE_ROOT}/*.${var}.*  | cut -d '.' -f 15\` ) 
    foreach period ( \${period_SET} )
      set Y_1 = (\`echo \$period | cut -c 1-4\`)
      set Y_2= (\`echo \$period | cut -c 8-11\`)
      if (\$Y_1 <= \${yloop} && \${yloop} <= \$Y_2) then
        set period_f=\${period}
        echo \${period_f}, \${yloop}
        @ tind = \`expr \( \${yloop} - \${Y_1} \) \* 12\`
        #echo \${vind}
        foreach mloop ( \${M_SET} )
          @ tind2 = \$tind + \$mloop
          #echo \$tind2
          set inputname = \${FILE_ROOT}/b.e21.\${scen}.f09_g17.\${CASENAME}.pop.h.${var}.\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${yloop}-\${mloop}.nc
          #ls \$input_head
           cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/test_NOASSM_atm_assm_extract_ocn_${var}.nc
           cdo -O -w -z zip_5 -select,name=${var} ${homedir}/test_NOASSM_atm_assm_extract_ocn_${var}.nc \${outputname}
          #echo \${inputname}
          #echo \${outputname}
        end
      endif
    end
  end
end
rm -f ${homedir}/test_NOASSM_atm_assm_extract_ocn_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
