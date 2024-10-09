#!/bin/csh
####!/bin/csh -fx
# Updated  04-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr
# Updated  03-Mar-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr added MEAN 


#set exps = ( ATM_ASSM_EXP ATM_NUDGE_ASSM_EXP ATM_NUDGE2_ASSM_EXP )
#set mem = f09_g17.assm.projdv7.3_ba-20p1
#set exps = ( ATM_ASSM_EXP )
#set mem = f09_g17.assm.projdv7.3_ba-10p1
set exps = ( ATM_NOASSM_ASSM_EXP )
set mem = LE2-1231.011

foreach exp ( ${exps} )
  #atm
  set comp = atm  
  set freqs = ( 6hr daily mon )
  foreach freq ( ${freqs} )
    set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/${exp}/archive_transfer/${comp}/${freq}
    set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ATM_TEST/preliminary/${exp}/archive_analysis/${comp}/${freq}
    
    set vars = ( `ls ${ARC_ROOT}` )
    foreach var ( ${vars} )
      set adir_RMSE = ${ARC_ROOT}/${var}/${mem}/RMSE
      set sdir_RMSE = ${SAVE_ROOT}/${var}/${mem}/RMSE
      mkdir -p $sdir_RMSE
      rm -rf ${sdir_RMSE}/* 
      ln -sf ${adir_RMSE}/mean_bias* ${sdir_RMSE}/
      ln -sf ${adir_RMSE}/RMSE_* ${sdir_RMSE}/
      set adir_MEAN = ${ARC_ROOT}/${var}/${mem}/MEAN
      set sdir_MEAN = ${SAVE_ROOT}/${var}/${mem}/MEAN
      mkdir -p $sdir_MEAN
      rm -rf ${sdir_MEAN}/* 
      ln -sf ${adir_MEAN}/mean_* ${sdir_MEAN}/
      ln -sf ${adir_MEAN}/MEAN_* ${sdir_MEAN}/
    end
  end
  #ocn
  set comp = ocn 
  set freqs = ( mon )
  foreach freq ( ${freqs} )
    set ARC_ROOT = /mnt/lustre/proj/earth.system.predictability/ATM_TEST/preliminary/${exp}/archive_transfer/${comp}/${freq}
    set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ATM_TEST/preliminary/${exp}/archive_analysis/${comp}/${freq}
    #set SAVE_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ATM_ASSM_EXP/${exp}/archive_analysis/${comp}/${freq}
    
    set vars = ( `ls ${ARC_ROOT}` )
    foreach var ( ${vars} )
      set adir_RMSE = ${ARC_ROOT}/${var}/${mem}/RMSE
      set sdir_RMSE = ${SAVE_ROOT}/${var}/${mem}/RMSE
      mkdir -p $sdir_RMSE
      rm -rf ${sdir_RMSE}/* 
      ln -sf ${adir_RMSE}/mean_bias* ${sdir_RMSE}/
      ln -sf ${adir_RMSE}/RMSE_* ${sdir_RMSE}/
      set adir_MEAN = ${ARC_ROOT}/${var}/${mem}/MEAN
      set sdir_MEAN = ${SAVE_ROOT}/${var}/${mem}/MEAN
      mkdir -p $sdir_MEAN
      rm -rf ${sdir_MEAN}/* 
      ln -sf ${adir_MEAN}/mean_* ${sdir_MEAN}/
      ln -sf ${adir_MEAN}/MEAN_* ${sdir_MEAN}/
    end
  end
end
