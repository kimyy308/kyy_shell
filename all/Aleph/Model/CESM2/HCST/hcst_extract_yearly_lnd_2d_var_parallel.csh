#!/bin/csh
####!/bin/csh -fx
# Updated  23-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set vars = ( TWS GPP NPP TOTVEGC COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ SNOW_PERSISTENCE RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT )
#20230825
set vars = ( RAIN TWS )
#20230907
set vars = ( SOILWATER_10CM )
#20230907
set vars = ( Q2M RH2M SNOW TLAI FAREA_BURNED NFIRE )



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
set siy = 2020
set eiy = 1960
#set eiy = 1970
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.hcst.en4.2_ba-10p1/lnd/proc/tseries/month_1
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
          set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_transfer/lnd/${var}/\${CASENAME_M}/\${CASENAME} 
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/lnd/${var}/\${CASENAME_M}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT
          @ fy_end = \${INITY} + 4
          set FY_SET = ( \`seq \${iyloop} \${fy_end}\` )
          foreach fy ( \${FY_SET} )
            ###if ( \${period_SET} == "" ) then
            set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.clm2.h0.\${fy}-*.nc
            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${fy}.nc
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
