#!/bin/csh
####!/bin/csh -fx
# Updated  13-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 diatC diazC spC )
#set vars = ( diatC diazC spC )
#set vars = ( UVEL VVEL SSH )
#set vars = ( photoC_TOT_zint_100m )
#set vars = ( diatChl spChl diazChl )
#set vars = ( SSH )
#set vars = ( NO3  )
#set vars = ( diatChl diazChl spChl NO3 PO4 SiO3 Fe PAR_avg ALK diatC diazC DIC PD spC TEMP UVEL VVEL WVEL WVEL2 ) 
#set vars = ( SALT O2 zooC ) #zooC later? 
###2D
#set vars = ( BSF HBLT diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf  diat_loss_zint_100m diat_N_lim_Cweight_avg_100m diat_N_lim_surf diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m  graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m  )
#set vars = ( graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )
#set vars = ( sp_N_lim_surf sp_P_lim_Cweight_avg_100m )
#set vars = ( SSH BSF )
#set vars = ( photoC_TOT_zint_100m )
#set vars = ( sp_P_lim_Cweight_avg_100m )
#set vars = ( diat_light_lim_Cweight_avg_100m )
#set vars = ( diatC Fe spC NO3 PO4 SiO3 TEMP UVEL VVEL WVEL PAR_avg BSF )
#set vars = ( diazC )
#set vars = ( IRON_FLUX )
#set vars = ( NH4 DOP diat_Qp sp_Qp diaz_Qp ) 
#set vars = ( HBLT diat_agg_zint_100m diat_Fe_lim_Cweight_avg_100m diat_Fe_lim_surf diat_light_lim_Cweight_avg_100m diat_light_lim_surf  diat_loss_zint_100m diat_N_lim_surf diat_N_lim_Cweight_avg_100m diat_P_lim_Cweight_avg_100m diat_P_lim_surf diat_SiO3_lim_Cweight_avg_100m diat_SiO3_lim_surf diaz_agg_zint_100m diaz_Fe_lim_Cweight_avg_100m diaz_Fe_lim_surf diaz_light_lim_Cweight_avg_100m diaz_light_lim_surf diaz_loss_zint_100m diaz_P_lim_Cweight_avg_100m diaz_P_lim_surf dustToSed graze_diat_zint_100m  graze_diat_zoo_zint_100m graze_diaz_zint_100m graze_diaz_zoo_zint_100m graze_sp_zint_100m graze_sp_zoo_zint_100m LWUP_F O2_ZMIN_DEPTH photoC_diat_zint_100m photoC_diaz_zint_100m photoC_NO3_TOT_zint_100m photoC_sp_zint_100m sp_agg_zint_100m sp_Fe_lim_Cweight_avg_100m sp_Fe_lim_surf sp_light_lim_Cweight_avg_100m sp_light_lim_surf sp_loss_zint_100m sp_N_lim_Cweight_avg_100m sp_N_lim_surf sp_P_lim_Cweight_avg_100m sp_P_lim_surf zoo_loss_zint_100m )
set vars = ( TEMP )
set vars = ( PD )
set vars = ( zooC )
#20230910
set vars = ( TEMP SALT UVEL VVEL PD DIC ALK WVEL diatChl diazChl spChl Fe NO3 NH4 SiO3 PO4 DOP PAR_avg zooC photoC_TOT )

#20231122
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20240520
set vars = ( Jint_100m_Fe tend_zint_100m_Fe Jint_100m_PO4 tend_zint_100m_PO4 )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/ens_${var}_hcst_tmp.csh
set tmp_log =  ~/tmp_log/ens_${var}_hcst_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set siy = 2021
set eiy = 1960
set RESOLN = f09_g17
set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}
set CASENAME_SET = ( \`ls \${ARC_ROOT} | grep \${RESOLN}.hcst.\` )
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` )
#foreach CASENAME_M ( \${CASENAME_SET} )
  foreach iyloop ( \${IY_SET} )
    set INITY = \${iyloop}
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*.nc\` )
    set SAVE_ROOT = \${ARC_ROOT}/ens_all
    mkdir -p \$SAVE_ROOT
#    cdo -L -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_ensmean_i\${INITY}.nc
    #en4
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*en4.2_ba*.nc\` )
#    cdo -L -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_en4.2_ba_ensmean_i\${INITY}.nc
    #projdv7.3_ba
    set FILE_SET = (\`ls \${ARC_ROOT}/*/*i\${INITY}/merged/*projdv7.3_ba*.nc\` )
#    cdo -L -O -w -z zip_5 -ensmean \${FILE_SET} \${SAVE_ROOT}/${var}_projdv7.3_ba_ensmean_i\${INITY}.nc
  end
#end



set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )  # iy loop1, inverse direction
  set INITY = \${iyloop}
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}
  set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/ens_all/ens_all_i\${iyloop}

  mkdir -p \${SAVE_ROOT}
  @ fy_end = \${iyloop} + 4
  set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
  foreach fy ( \${FY_SET} )
    foreach mon ( \${M_SET} )
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*\${fy}-\${mon}.nc\`)
      #set outputname=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_all_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_all_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_all_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_all_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
#      set outputname2=\${SAVE_ROOT}/../${var}_\${RESOLN}.hcst.ens_all_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
#      rm -f \${outputnamemean}
#      rm -f \${outputnamemax}
#      rm -f \${outputnamemin}
#      rm -f \${outputnamestd}
      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
##      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
##      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
##      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for en4 
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*en4.2_ba*\${fy}-\${mon}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_en4.2_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_en4.2_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_en4.2_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_en4.2_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
#      rm -f \${outputnamemean}
#      rm -f \${outputnamemax}
#      rm -f \${outputnamemin}
#      rm -f \${outputnamestd}
##      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
##      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
##      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
##      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}
      
      ## for projdv7.3_ba
      set input_set = (\`ls \${ARC_ROOT}/\${RESOLN}*/*_i\${iyloop}/*projdv7.3_ba*\${fy}-\${mon}.nc\`)
      set outputnamemean=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmean_projdv7.3_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamestd=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensstd_projdv7.3_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemax=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmax_projdv7.3_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      set outputnamemin=\${SAVE_ROOT}/${var}_\${RESOLN}.hcst.ensmin_projdv7.3_ba_i\${iyloop}.pop.h.\${fy}-\${mon}.nc
      echo "cdo -L -O ensmean "\${input_set} \${outputnamemean}
#      rm -f \${outputnamemean}
#      rm -f \${outputnamemax}
#      rm -f \${outputnamemin}
#      rm -f \${outputnamestd}
##      cdo -L -O -w -z zip_5 ensmean \${input_set} \${outputnamemean}
##      cdo -L -O -w -z zip_5 ensmax \${input_set} \${outputnamemax}
##      cdo -L -O -w -z zip_5 ensmin \${input_set} \${outputnamemin}
##      cdo -L -O -w -z zip_5 ensstd \${input_set} \${outputnamestd}

#      echo \$outputname
#      mv \$outputname2 \$outputname
    end
  end
end

echo "postprocessing complete"

EOF

#csh -xv $tmp_scr &
csh  $tmp_scr > $tmp_log &
end
