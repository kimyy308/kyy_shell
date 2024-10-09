#!/bin/csh
####!/bin/csh -fx
# Updated  30-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20230830
set vars = ( HMXL HBLT SSH IRON_FLUX photoC_TOT_zint_100m photoC_TOT_zint ATM_CO2 CaCO3_FLUX_100m DpCO2 pCO2SURF )
#20231006
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT)
#20231007
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT )
#20231101
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231113
set vars = ( ALK CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 pCO2SURF PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231116
set vars = ( DOC )
#20231123
#set vars = ( PAR_avg )
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )
#20231211
set vars = ( Jint_100m_Fe tend_zint_100m_Fe  Jint_100m_NH4 tend_zint_100m_NH4 Jint_100m_PO4 tend_zint_100m_PO4 Jint_100m_SiO3 tend_zint_100m_SiO3 diaz_Nfix photoNO3_diat photoNO3_diaz photoNO3_sp photoNH4_diat photoNH4_diaz photoNH4_sp photoFe_diat photoFe_diaz photoFe_sp PO4_diat_uptake PO4_diaz_uptake PO4_sp_uptake )
#20231218
set vars = ( DIC )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_y_hcst_extract_tmp.csh
set tmp_log =  ~/tmp_log/${var}_y_hcst_extract_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#set siy = 2021
#set eiy = 1960
set siy = 1960
set eiy = 1962
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.hcst.en4.2_ba-10p1/ocn/proc/tseries/month_1
#echo \${IY_SET}
set IY_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach iyloop ( \${IY_SET} )
 set INITY = \${iyloop}
    foreach OBS ( \${OBS_SET} ) #OBS loop1
      foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
        foreach mbr ( \$mbr_set ) #mbr loop1
          set CASENAME_M = \${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}  #parent casename 
          set CASENAME = \${RESOLN}.hcst.\${OBS}-\${FACTOR}p\${mbr}_i\${INITY}
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/ocn/${var}/\${CASENAME_M}/\${CASENAME} 
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/ocn/${var}/\${CASENAME_M}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT
          @ fy_end = \${INITY} + 4
          set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
          foreach fy ( \${FY_SET} )
            ###if ( \${period_SET} == "" ) then
            set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}-*.nc
            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${fy}.nc
            cdo -O -w -mergetime \$inputname ${homedir}/hcst_test_yearly_${var}.nc
            cdo -O -w -z zip_5 -timmean ${homedir}/hcst_test_yearly_${var}.nc \$outputname
            echo \${outputname} is completed
          end 
        end
      end
    end
#  end
end
rm -f ${homedir}/hcst_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
