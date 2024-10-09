#!/bin/csh
####!/bin/csh -fx
# Updated  06-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( PRECT PRECC PRECL PSL U850 UBOT V850 VBOT uIVT vIVT IVT )
#set vars = ( PRECT PRECC PRECL PSL U850 UBOT V850 VBOT uIVT vIVT IVT )
#set vars = ( PRECT )
set vars = ( FSDS FSNS TAUX TAUY )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_atm_ctl_assm_tmp.csh
set tmp_log =  ~/tmp_log/${var}_atm_ctl_assm_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
#set OBS_SET = ("en4.2_ba" "projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set OBS_SET = ("projdv7.3_ba")  #"ens4.2_ba" "projdv7.3_ba" "oras4_ba"
set FACTOR_SET = (20)
set mbr_set = (1)
set RESOLN = f09_g17
set siy = 2015
set eiy = 2019
set outfreq = daily
#set Y_SET = ( \`seq \${siy} +1 \${eiy}\` ) 
#set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set scen = BSSP370smbb
foreach OBS ( \${OBS_SET} ) #OBS loop1
  foreach FACTOR ( \$FACTOR_SET ) #FACTOR loop1
    foreach mbr ( \$mbr_set ) #mbr loop1
      set CASENAME_M = b.e21.\${scen}.\${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set CASENAME = \${RESOLN}.assm.\${OBS}-\${FACTOR}p\${mbr}  #parent casename
      set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive/\${CASENAME_M}
      set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/ATM_ASSM_EXP/archive_transfer/atm/\${outfreq}/${var}/\${CASENAME} 
      mkdir -p \$SAVE_ROOT

      set input_head = \${ARC_ROOT}/atm/hist/\${CASENAME_M}.cam.h1.????-??-??-?????.nc
      set input_set=(\`ls \${input_head}*\`)
      foreach inputname ( \${input_set} )
        set outputnc=(\`echo \${inputname} | cut -d '/' -f 11\`)
        set outputnc_new=(\`echo \${outputnc} | sed "s/\${RESOLN}/${var}_\${outfreq}_\${RESOLN}/g"\`)
        set outputname = \${SAVE_ROOT}/\${outputnc_new}
        echo "cdo -O select,name="${var}" "\$inputname" "\$outputname
        cdo -O -w -z zip_5 select,name=${var} \$inputname \$outputname
      end
    end
  end
end
#rm -f ${homedir}/test_${var}.nc
#rm -f ${homedir}/test2_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
