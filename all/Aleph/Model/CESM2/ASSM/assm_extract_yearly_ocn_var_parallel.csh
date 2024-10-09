#!/bin/csh
####!/bin/csh -fx
# Updated  25-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20231007
set vars = ( SSH photoC_TOT_zint photoC_TOT_zint_100m IRON_FLUX HMXL HBLT )
set vars = ( PD SALT TEMP UVEL VVEL WVEL NO3 Fe SiO3 PO4 zooC photoC_TOT)

#20231026
#20231101
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231106
set vars = ( ALK ATM_CO2 CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 FG_ALT_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231113
set vars = ( ALK CaCO3_FLUX_100m CO3 DIC DIC_ALT_CO2 DOC DpCO2 DpCO2_ALT_CO2 FG_CO2 pCO2SURF pH_3D PH POC_FLUX_100m POC_FLUX_IN POC_PROD )
#20231123
set vars = ( PAR_avg )
set vars = ( Jint_100m_NO3 tend_zint_100m_NO3 )

#20231214
set vars = ( DIC )

#history was removed (checked at 20231004)


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_assm_yearly_tmp.csh
set tmp_log =  ~/tmp_log/${var}_assm_yearly_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#reversed order
#set siy = 2020
#set eiy = 1960
set siy = 1962
set eiy = 1960
#set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.assm.en4.2_ba-10p1/ocn/proc/tseries/month_1
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach yloop ( \${Y_SET} )
    if (\${yloop} <= 2014) then
      set scen = BHISTsmbb
    else if (\${yloop} >= 2015) then
      set scen = BSSP370smbb
    endif
    foreach OBS ( \${OBS_SET} ) #OBS loop1
      foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
        foreach mbr ( \$mbr_set ) #mbr loop1
            set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
            set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
            set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/ocn/${var}/\${CASENAME} 
            set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/ocn/${var}/\${CASENAME}
            mkdir -p \$SAVE_ROOT
            set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.pop.h.\${yloop}-*.nc
            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.pop.h.\${yloop}.nc
            #ls \$input_head
             cdo -O -w  -mergetime \$inputname ${homedir}/assm_test_yearly_${var}.nc
             cdo -O -w -z zip_5 -timmean ${homedir}/assm_test_yearly_${var}.nc \${outputname}
            echo \${outputname}
        end
      end
    end
end
rm -f ${homedir}/assm_test_yearly_${var}.nc
rm -f ${homedir}/assm_test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
