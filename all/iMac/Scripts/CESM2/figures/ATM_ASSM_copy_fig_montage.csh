#!/bin/csh

set TMPROOT_montage = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ATM_ASSM_EXP/tmp_montage_piece
mkdir -p ${TMPROOT_montage}

set comp = ocn
set freq = mon
set levs = ( 01 05 10 15 )

#set comp = atm
#set freq = mon   # mon daily 6hr
#set levs = ( 32 )


set exps = ( ATM_ASSM_EXP ATM_NUDGE_ASSM_EXP ATM_NUDGE2_ASSM_EXP )
foreach exp ( ${exps} )
  set ARCROOT = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ATM_ASSM_EXP/${exp}/archive_analysis
  set vars = ( `ls ${ARCROOT}/${comp}/${freq}` )
  set obs = ( f09_g17.assm.projdv7.3_ba-20p1 )
  #echo $vars
  foreach var ( ${vars} )
    set RMSEdir = ${ARCROOT}/${comp}/${freq}/${var}/${obs}/RMSE
    cd $RMSEdir
    set BIASdir = ${ARCROOT}/${comp}/${freq}/${var}/${obs}/BIAS
    set MEANdir = ${ARCROOT}/${comp}/${freq}/${var}/${obs}/MEAN
    set dim3 = `ls * | grep lev`
    if ( ${#dim3} == 0 ) then
      echo ${var} " = 2d, copy"
      set figdir = ${TMPROOT_montage}/${comp}/${var}
      mkdir -p ${figdir}
      
      cd $MEANdir
      set MEAN_fname = MEAN_${var}_${obs}.tif
      cp -f ${MEAN_fname} ${figdir}/${exp}_${MEAN_fname}

      cd $RMSEdir
      set RMSE_fname = RMSE_${var}_${obs}.tif
      cp -f ${RMSE_fname} ${figdir}/${exp}_${RMSE_fname}

      cd $BIASdir
      set BIAS_fname = BIAS_${var}_${obs}.tif
      cp -f ${BIAS_fname} ${figdir}/${exp}_${BIAS_fname}
     
    else
      echo ${var} " = 3d, copy"
      set figdir = ${TMPROOT_montage}/${comp}/${var}
      mkdir -p ${figdir}
      foreach lev ( ${levs} )
        cd $MEANdir
        set MEAN_fname = MEAN_${var}_${obs}_lev${lev}.tif
        cp -f ${MEAN_fname} ${figdir}/${exp}_${MEAN_fname}

        cd $RMSEdir
        set RMSE_fname = RMSE_${var}_${obs}_lev${lev}.tif
        cp -f ${RMSE_fname} ${figdir}/${exp}_${RMSE_fname}
        
        cd $BIASdir
        set BIAS_fname = BIAS_${var}_${obs}_lev${lev}.tif
        cp -f ${BIAS_fname} ${figdir}/${exp}_${BIAS_fname}
      end 
    endif
  end
end 


set ARCROOT = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ATM_ASSM_EXP/${exp}/archive_analysis
set FIGROOT_montage = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ATM_ASSM_EXP/tmp_montage
set vars = ( `ls ${ARCROOT}/${comp}/${freq}` )
set obs = ( f09_g17.assm.projdv7.3_ba-20p1 )
#echo $vars
foreach var ( ${vars} )
  set figdir = ${TMPROOT_montage}/${comp}/${var}
  set figdir_out = ${FIGROOT_montage}/${comp}
  mkdir -p $figdir_out
  cd $figdir
  set dim3 = `ls * | grep lev`
  if ( ${#dim3} == 0 ) then
    echo ${var} " = 2d, montage"
    set afigs= ( `ls * | grep ATM_ASSM_EXP` )
    convert ${afigs} -append a.tif
    set bfigs= ( `ls * | grep ATM_NUDGE2_ASSM_EXP` )
    convert ${bfigs} -append b.tif
    set cfigs= ( `ls * | grep ATM_NUDGE_ASSM_EXP` )
    convert ${cfigs} -append c.tif
    convert a.tif b.tif c.tif +append ${figdir_out}/montage_${var}_${obs}.tif
    rm -f a.tif b.tif c.tif 
  else
    echo ${var} " = 3d, montage"
    foreach lev ( ${levs} )
      set afigs= ( `ls *lev${lev}* | grep ATM_ASSM_EXP` )
      convert ${afigs} -append a.tif
      set bfigs= ( `ls *lev${lev}* | grep ATM_NUDGE2_ASSM_EXP` )
      convert ${bfigs} -append b.tif
      set cfigs= ( `ls *lev${lev}* | grep ATM_NUDGE_ASSM_EXP` )
      convert ${cfigs} -append c.tif
      convert a.tif b.tif c.tif +append ${figdir_out}/montage_${var}_${obs}_lev${lev}.tif 
      rm -f a.tif b.tif c.tif 
    end
  endif

end
