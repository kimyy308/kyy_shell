#!/bin/csh
####!/bin/csh -fx
# Updated  04-Oct-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
set vars = ( TS ) 
set vars = ( PSL PRECT SST ) 
set vars = ( AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT  )
#20230825
set vars = ( TS SST PSL PRECT )
#20230915
set vars = ( Q RELHUM ) 
#20231004 
set vars = ( TS ) 
set vars = ( PSL PRECT SST ) #2~5
#20231004 
set vars = ( TS PSL PRECT SST ) #2~4

set ly_s = 2
set ly_e = 4

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_multi_ly_hcst_extract_tmp.csh
set tmp_log =  ~/tmp_log/${var}_multi_ly_hcst_extract_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (10 20)
set mbr_set = (1 2 3 4 5)
set RESOLN = f09_g17
set siy = 2021
set eiy = 1960
#set eiy = 1970
set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/HCST_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.hcst.en4.2_ba-10p1/atm/proc/tseries/month_1
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
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/HCST_EXP/archive_yearly_transfer/atm/${var}/\${CASENAME_M}/\${CASENAME} 
          mkdir -p \$SAVE_ROOT
          @ fy_start = \${INITY} + ${ly_s} - 1
          @ fy_end = \${INITY} + ${ly_e} - 1
          set FY_SET = ( \`seq \${fy_start} \${fy_end}\` )
          set len_s = ( \`seq 1 +1 "\${#FY_SET}"\` ) 
          foreach ci ( \${len_s} )
            if ( \${ci} == 1 ) then
              set inputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.\${FY_SET[\${ci}]}.nc
            else
              set inputname = ( \${inputname} \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.\${FY_SET[\${ci}]}.nc  )
            endif
          end
          set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.ly_${ly_s}_${ly_e}.nc
          cdo -O -w -mergetime \$inputname ${homedir}/hcst_test_yearly_${var}.nc
          cdo -O -w -z zip_5 -timmean ${homedir}/hcst_test_yearly_${var}.nc \$outputname
          echo \${outputname} is completed
        end
      end
    end
#  end
end
rm -f ${homedir}/hcst_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end