#!/bin/csh


set LE2DIR = /proj/earth.system.predictability/LENS2/temporary

set scrDIR = /mnt/lustre/proj/kimyy/Scripts/Model/CESM2/LENS2/wget

set Chls = ( diatChl diazChl spChl )
#set Chls = ( diatChl )
#set periods = ( 199001_199912 200001_200912 201001_201412 201501_202412 )
set periods = ( 196001_196912 197001_197912 198001_198912 )

foreach Chl ( ${Chls} )
  foreach period ( ${periods} )
    #set scr_raw = ${scrDIR}/${Chl}_wget_${period}.sh
    set scr_raw = ${scrDIR}/${Chl}_avg_wget_${period}.sh
    set LE2DIR_Chl = ${LE2DIR}/${Chl}/${period}
    mkdir -p ${LE2DIR_Chl}
    #set scr_new = ${LE2DIR_Chl}/${Chl}_wget_${period}.sh
    set scr_new = ${LE2DIR_Chl}/${Chl}_avg_wget_${period}.sh
    cd ${LE2DIR_Chl}
    cp -f ${scr_raw} ./
    #bash ./${Chl}_wget_${period}.sh
    bash ./${Chl}_avg_wget_${period}.sh
  end
end





