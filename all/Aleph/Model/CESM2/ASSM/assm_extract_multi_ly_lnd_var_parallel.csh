#!/bin/csh
####!/bin/csh -fx
# Updated  25-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20231017
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FAREA_BURNED FIRE FPSN NFIRE SOILWATER_10CM SOILICE SOILLIQ SNOW TOTSOILICE TLAI TOTSOILLIQ RAIN Q2M QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC RH2M NEP DSTFLXT ) # 2 ~ 4

#20231120
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FAREA_BURNED FIRE FPSN NFIRE SOILWATER_10CM SOILICE SOILLIQ SNOW TOTSOILICE TLAI TOTSOILLIQ RAIN Q2M QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC RH2M NEP DSTFLXT ) # 1 ~ 3


set ly_s = 1
set ly_e = 3



foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_assm_multi_ly_tmp.csh
set tmp_log =  ~/tmp_log/${var}_assm_multi_ly_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#reversed order
set siy = 2018  #2020-ly_e+1
set eiy = 1960
#set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.assm.en4.2_ba-10p1/lnd/proc/tseries/month_1
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
            set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/lnd/${var}/\${CASENAME}
            mkdir -p \$SAVE_ROOT
            @ fy_start = \${yloop} + ${ly_s} - 1
            @ fy_end = \${yloop} + ${ly_e} - 1
            set FY_SET = ( \`seq \${fy_start} \${fy_end}\` )
            set len_s = ( \`seq 1 +1 "\${#FY_SET}"\` )
            foreach ci ( \${len_s} )
              if ( \${ci} == 1 ) then
                set inputname = \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${FY_SET[\${ci}]}.nc
              else
                set inputname = ( \${inputname} \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${FY_SET[\${ci}]}.nc  )
              endif
            end

            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${yloop}_ly_${ly_s}_${ly_e}.nc
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
