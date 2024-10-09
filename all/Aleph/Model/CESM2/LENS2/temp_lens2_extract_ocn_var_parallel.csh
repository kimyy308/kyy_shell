#!/bin/csh
####!/bin/csh -fx
# Updated  01-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

set homedir = /proj/kimyy/tmp
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH )
#set vars = ( NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX)
#set vars = ( IRON_FLUX )
#set vars = ( HBLT HMXL_DR TBLT TMXL XBLT XMXL TMXL_DR XMXL_DR )
#set vars = ( diatC_zint_100m_2 )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 )
#set vars = ( diatC_zint_100m_2 diazC_zint_100m_2 spC_zint_100m_2 HMXL HBLT photoC_TOT_zint_100m IRON_FLUX )
#set vars = ( photoC_TOT_zint_100m )
#set vars = ( HMXL HBLT photoC_TOT_zint_100m IRON_FLUX )
set vars = ( diatChl diazChl spChl )

foreach var ( ${vars} )

mkdir ~/tmp_script
mkdir ~/tmp_log
set tmp_scr =  ~/tmp_script/${var}_lens2_tmp.csh
set tmp_log =  ~/tmp_log/${var}_lens2_tmp.log

cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
#set siy = 2020
#set eiy = 1998
#set siy = 2025
#set eiy = 2021
#set siy = 1997
#set eiy = 1990
set siy = 1989
set eiy = 1960
#echo \${Y_SET}
set Y_SET = ( \`seq \${siy} -1 \${eiy}\` ) 
set M_SET = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
foreach yloop ( \${Y_SET} )
  if (\${yloop} <= 2014) then
    set scen = BHISTsmbb
  else if (\${yloop} >= 2015) then
    set scen = BSSP370smbb
  endif
  set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/temporary/
  cd \${ARC_ROOT}
  set FILE_ROOT = \${ARC_ROOT}/${var}
  set period_SET = ( \`ls \${FILE_ROOT}/ \` )
  foreach period ( \${period_SET} )
    set Y_1 = (\`echo \$period | cut -c 1-4\`)
    set Y_2= (\`echo \$period | cut -c 8-11\`)
    if (\$Y_1 <= \${yloop} && \${yloop} <= \$Y_2) then
      set period_f=\${period}
      echo \${period_f}, \${yloop}
      @ tind = \`expr \( \${yloop} - \${Y_1} \) \* 12\`
      foreach mloop ( \${M_SET} )
        @ tind2 = \$tind + \$mloop
        cd \${FILE_ROOT}/\${period}
        set ENS_ALL = ( \`ls -d *nc  | cut -d '.' -f 5-6\` )
        foreach ENS ( \${ENS_ALL} )
          set CASENAME_M = \${ENS}     
          set SAVE_ROOT = /mnt/lustre/proj/earth.system.predictability/LENS2/archive_transfer/ocn/${var}/\${CASENAME_M}
          mkdir -p \$SAVE_ROOT
          set inputname = ( \`ls *.nc | grep \${ENS} \` )
          set outputname = \${SAVE_ROOT}/${var}_\${CASENAME_M}.pop.h.\${yloop}-\${mloop}.nc
          cdo -O -w -seltimestep,\$tind2 \$inputname ${homedir}/lens2_test_${var}.nc
          cdo -O -w -z zip_5 -select,name=${var} ${homedir}/lens2_test_${var}.nc \$outputname
        end
      end
    endif
  end
end
rm -f ${homedir}/lens2_test_${var}.nc

EOF

csh $tmp_scr > $tmp_log &
end
