#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH )
#set vars = ( NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX)
#set vars = ( IRON_FLUX )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( diatC_zint_100m_2 )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 HMXL HBLT photoC_TOT_zint_100m IRON_FLUX )
#set vars = ( photoC_TOT_zint_100m )
#set vars = ( HMXL HBLT photoC_TOT_zint_100m IRON_FLUX )
#set vars = ( photoC_TOT_zint photoC_TOT_zint_100m HMXL )
#set vars = ( SSH )
#set vars = ( NO3 SiO3 PO4 Fe )
#set vars = ( SiO3 PO4 Fe )
set vars = ( diatC diazC spC )
#set vars = ( NO3 )
#set vars = ( WVEL )
#set vars = ( BSF )
#set vars = ( IRON_FLUX HBLT HMXL )
#set vars = ( PAR_avg )
#set vars = ( TEMP UVEL VVEL WVEL )
set vars = ( diat_light_lim_Cweight_avg_100m )
#set vars = ( diat_Qp sp_Qp diaz_Qp ) 
#set vars = ( NH4 DOP ) 
set vars = ( photoC_TOT ) 
set vars = ( zooC ) 
set vars = ( PD ) 


#set vars = ( diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf diat_loss_zint_100m )
#set vars = ( diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf  )
#set vars = ( diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf )
#set vars = ( dustToSed graze_diat_zint_100m graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m  )
#set vars = ( graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m )
#set vars = ( photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf )
#set vars = ( sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )

#20231126
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set siy = 2025
set eiy = 1960
#set siy = 2018
#set eiy = 2018
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
  if (\${yloop} <= 2014) then
    set scen = BHIST
  else if (\${yloop} >= 2015) then
    set scen = BSSP370
  endif
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_tseries
  cd \${ARC_ROOT}
  #set ENS_ALL = ( \`ls -d *HIST*/  | grep -v ext | rev | cut -c 2-9 | rev\` )
  #set ENS_ALL = ( \`ls -d *HISTsmbb*/  | grep -v ext | rev | cut -c 2-9 | rev\` )
  #set ENS_ALL = ( 1231.012 )
  #foreach ENS ( \${ENS_ALL} )
    cd \${ARC_ROOT}
    set ENS = ens_smbb
    #set CASENAME_M = LE2-\${ENS}     
    #set CASENAME = ( \`ls  | grep \${ENS} | grep \${scen} | grep -v ext | grep -v .nc | grep -v allfiles \` )
    set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}/\${ENS}
    mkdir -p \$SAVE_ROOT
    set FILE_ROOT = \${ARC_ROOT}/ocn/${var}/\${ENS}
    echo \${FILE_ROOT}
    set period_SET = ( \`ls \${FILE_ROOT}/${var}*ensmean*  | cut -d '.' -f 3 | rev | cut -c 1-13 | rev\` )
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
          ### ensmean
          #echo \$tind2i
          set inputname = \${FILE_ROOT}/${var}_ensmean_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_ensmean_\${yloop}-\${mloop}.nc
          #ls \$input_head
           cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
           cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          #echo \${inputname}
          #echo \${outputname}
          
          ### ensmax
          set inputname = \${FILE_ROOT}/${var}_ensmax_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_ensmax_\${yloop}-\${mloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          ### ensmin
          set inputname = \${FILE_ROOT}/${var}_ensmin_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_ensmin_\${yloop}-\${mloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
          ### ensstd
          set inputname = \${FILE_ROOT}/${var}_ensstd_\${period_f}.nc
          set outputname = \${SAVE_ROOT}/${var}_ensstd_\${yloop}-\${mloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
        end
      endif
    end
  #end 
end
rm -f ${homedir}/lens2_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
