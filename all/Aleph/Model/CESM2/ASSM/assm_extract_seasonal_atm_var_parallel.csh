#!/bin/csh
####!/bin/csh -fx
# Updated  30-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr
# Updated  07-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#20230911
set vars = ( TS SST PRECT PSL AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT  )
#20230914
set vars = ( Q RELHUM )
#20240207
set vars = ( TS )


foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_assm_season_tmp.csh
set tmp_log =  ~/tmp_log/${var}_assm_season_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set seasons = ( JFM1 AMJ1 JAS1 OND1 )
#set seasons = ( MAM1 )
set seasons = ( MAM1 JJA1 SON1 DJF1 MAM2 JJA2 SON2 )
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
#reversed order
set siy = 2020
set eiy = 1960
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
foreach yloop ( \${Y_SET} )
  @ yloop2 = \${yloop} + 1
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
      case "MAM1":
        set FY = ( \${yloop} \${yloop} \${yloop} )
        set M_SET = ( 03 04 05 )
        breaksw
      case "JJA1":
        set FY = ( \${yloop} \${yloop} \${yloop} )
        set M_SET = ( 06 07 08 )
        breaksw
      case "SON1":
        set FY = ( \${yloop} \${yloop} \${yloop} )
        set M_SET = ( 09 10 11 )
        breaksw
      case "DJF1":
        set FY = ( \${yloop} \${yloop2} \${yloop2} )
        set M_SET = ( 12 01 02 )
        breaksw
      case "MAM2":
        set FY = ( \${yloop2} \${yloop2} \${yloop2} )
        set M_SET = ( 03 04 05 )
        breaksw
      case "JJA2":
        set FY = ( \${yloop2} \${yloop2} \${yloop2} )
        set M_SET = ( 06 07 08 )
        breaksw
      case "SON2":
        set FY = ( \${yloop2} \${yloop2} \${yloop2} )
        set M_SET = ( 09 10 11 )
        breaksw
    endsw
    

    foreach OBS ( \${OBS_SET} ) #OBS loop1
      foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
        foreach mbr ( \$mbr_set ) #mbr loop1
            set len_s = ( \`seq 1 +1 "\${#M_SET}"\` ) 
            foreach ci ( \${len_s} )
              if (\${FY[\${ci}]} <= 2014) then
                set scen = BHISTsmbb
              else if (\${FY[\${ci}]} >= 2015) then
                set scen = BSSP370smbb
              endif
              set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
              set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
              set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/atm/${var}/\${CASENAME} 
              set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_seasonal_transfer/atm/${var}/\${CASENAME}/\${season}/
              mkdir -p \$SAVE_ROOT
              if ( \${ci} == 1 ) then
                set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.cam.h0.\${FY[\${ci}]}-\${M_SET[\${ci}]}.nc
              else
                set inputname = ( \${inputname} \${ARC_ROOT}/${var}_\${CASENAME}.cam.h0.\${FY[\${ci}]}-\${M_SET[\${ci}]}.nc  )
              endif
            end
            
            #set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.cam.h0.\${FY[\${ci}]}-*.nc
            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.\${FY[\${ci}]}_\${season}.nc
            #ls \$input_head
             cdo -O -w -z zip_5 -ensmean \${inputname} \${outputname}
            echo \${outputname}
        end
      end
    end
  end
end
rm -f ${homedir}/assm_test_yearly_${var}.nc
rm -f ${homedir}/assm_test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
