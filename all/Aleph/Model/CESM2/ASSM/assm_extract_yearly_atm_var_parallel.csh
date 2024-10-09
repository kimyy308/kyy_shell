#!/bin/csh
####!/bin/csh -fx
# Updated  25-Aug-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp

#set vars = ( PRECT PSL TS AODDUST )
#set vars = ( SST )
#set vars = ( PRECT PSL TS AODDUST SST )
set vars = ( PS U10 )
#set vars = ( CLOUD OMEGA Q RELHUM U V dry_deposition_NOy_as_N dry_deposition_NHx_as_N dst_a1SF dst_a1_SRF dst_a2SF dst_a2DDF dst_a2SFWET dst_a2_SRF dst_a3SF dst_a3_SRF FSNS FSDS SFdst_a1 SFdst_a2 SFdst_a3 TAUX TAUY U10 wet_deposition_NHx_as_N wet_deposition_NOy_as_N )
#set vars = ( CLOUD AODDUST FSNS FSDS PRECT PSL TS U10 SST )
set vars = ( AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT  )
set vars = ( PRECT PSL TS SST )
#20230830
set vars = ( TS SST PSL PRECT AEROD_v FSDS FSNS SFdst_a1 SFdst_a2 SFdst_a3 U10 SFCO2 CLDTOT  )

#history was removed (checked at 20231004), so it was copyed from ens script

#20231008
set vars = ( Q RELHUM CLOUD OMEGA U V AEROD_v FSDS FSNS U10 TAUX TAUY Z3 CLDTOT LHFLX SHFLX ) 
set vars = ( Z3 LHFLX SHFLX ) 

#20231026
set vars = ( TREFHT )


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
set siy = 2020
set eiy = 1960
#set scens = (BHISTsmbb BSSP370smbb)
#set refdir = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP_timeseries/archive/b.e21.BHISTsmbb.f09_g17.assm.en4.2_ba-10p1/atm/proc/tseries/month_1
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
            set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_transfer/atm/${var}/\${CASENAME} 
            set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ASSM_EXP/archive_yearly_transfer/atm/${var}/\${CASENAME}
            mkdir -p \$SAVE_ROOT
            set inputname = \${ARC_ROOT}/${var}_\${CASENAME}.cam.h0.\${yloop}-*.nc
            set outputname = \${SAVE_ROOT}/${var}_\${CASENAME}.cam.h0.\${yloop}.nc
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
