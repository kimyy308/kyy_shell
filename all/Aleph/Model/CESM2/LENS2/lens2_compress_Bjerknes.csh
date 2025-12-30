#!/bin/csh
####!/bin/csh -fx
# Updated  06-Jun-2025 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr

#tar -czvf /proj/kimyy/LE2-1231.013_rest_1990.tar.gz b.e21.BHISTsmbb.f09_g17.LE2-1231.013/rest/1990-01-01-00000

set ens1 = ( 1231 1281 )
set ens2 = ( 011 012 013 014 015 016 017 018 019 020 )
foreach ens1i ( ${ens1} )
  foreach ens2i ( ${ens2} )
    set OUTPUT =  /proj/kimyy/LE2-${ens1i}.${ens2i}_rest_1990.tar.gz 
    set INPUT = /share/CESM/archive/b.e21.BHISTsmbb.f09_g17.LE2-${ens1i}.${ens2i}/rest/1990-01-01-00000
    tar -czvf ${OUTPUT} ${INPUT}
  end 
end

