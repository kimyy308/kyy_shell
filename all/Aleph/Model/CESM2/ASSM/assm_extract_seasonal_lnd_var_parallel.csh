#!/bin/csh
####!/bin/csh -fx
# Updated  30-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20230825
#set vars = ( TWS RAIN )
#20230830
#set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT ) #SNOW_PERSISTENCE -> removed
#20230913
set vars = ( TWS RAIN SNOW NPP GPP TOTVEGC COL_FIRE_CLOSS FIRE FAREA_BURNED NFIRE SOILWATER_10CM Q2M RH2M )
#!!!!!!!!SNOW, TLAI,RH2M Q2M TLAI  should be calculated again
#20230914
set vars = ( SNOW TLAI RH2M Q2M )
set vars = ( TLAI )
#20231012
set vars = ( GPP NPP TOTVEGC TWS COL_FIRE_CLOSS COL_FIRE_NLOSS FIRE FPSN SOILICE SOILLIQ TOTSOILICE TOTSOILLIQ RAIN QSOIL QSOIL_ICE QRUNOFF QOVER QRGWL QH2OSFC NEP DSTFLXT SOILWATER_10CM FAREA_BURNED NFIRE Q2M RH2M TLAI SNOW )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_assm_season_tmp.csh
set tmp_log =  ~/tmp_log/${var}_assm_season_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set seasons = ( JFM1 AMJ1 JAS1 OND1 )
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#reversed order
set siy = 2020
set eiy = 1960
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach yloop ( \${Y_SET} )
  foreach season ( \${seasons} )
    switch( \${season} )
      case "JFM1":
        set FY = \${yloop}
        set M_SET = ( 01 02 03 )
        breaksw
      case "AMJ1":
        set FY = \${yloop}
        set M_SET = ( 04 05 06 )
        breaksw
      case "JAS1":
        set FY = \${yloop}
        set M_SET = ( 07 08 09 )
        breaksw
      case "OND1":
        set FY = \${yloop}
        set M_SET = ( 10 11 12 )
        breaksw
    endsw

    if (\${FY} <= 2014) then
      set scen = BHISTsmbb
    else if (\${FY} >= 2015) then
      set scen = BSSP370smbb
    endif

    foreach OBS ( \${OBS_SET} ) #OBS loop1
      foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
        foreach mbr ( \$mbr_set ) #mbr loop1
            set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
            set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
            set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/lnd/${var}/\${CASENAME} 
            set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_seasonal_transfer/lnd/${var}/\${CASENAME}/\${season}/
            mkdir -p \$SAVE_ROOT
            set len_s = ( \`seq 1 +1 "\${#M_SET}"\` ) 
            foreach ci ( \${len_s} )
              if ( \${ci} == 1 ) then
                set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.clm2.h0.\${FY}-\${M_SET[\${ci}]}.nc
              else
                set inputname = ( \${inputname} \${ARC_ROOT}/${var}_\${CASENAME}.clm2.h0.\${FY}-\${M_SET[\${ci}]}.nc  )
              endif
            end
            
            #set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.clm2.h0.\${FY}-*.nc
            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.clm2.h0.\${FY}_\${season}.nc
            #ls \$input_head
             cdo -O -w -z zip_5 -ensmean \${inputname} \${outputname}
            echo \${outputname}
        end
      end
    end
  end
end

EOF

csh $tmp_scr > $tmp_log &
end
