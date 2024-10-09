#!/bin/csh

set ARCROOT = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ASSM_EXP/archive_yearly_analysis
set TMPROOT_ENS = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ASSM_EXP/archive_yearly_analysis/tmp_ens_ocn
mkdir -p ${TMPROOT_ENS}
set comp = ocn
set vars = ( `ls ${ARCROOT}/${comp}/` )
set obs = ( en4.2_ba projdv7.3_ba )
set levs = ( 01 05 10 15 )
#echo $vars
foreach var ( ${vars} )
  # ens set
  set vardir = ${ARCROOT}/${comp}/${var}/ens_set
  cd $vardir
  set dim3 = `ls * | grep lev`
  if ( ${#dim3} == 0 ) then
    echo ${var} " = 2d"
    set figdir = ${vardir}/montage
    mkdir -p ${figdir}
    # allens
    set fname = ${figdir}/montage_ens_${var}.tif
    cp -f ${fname} ${TMPROOT_ENS}/
    # obs ens 
    foreach obsn ( ${obs} )
      set fname = ${figdir}/montage_${obsn}_ens_${var}.tif
      cp -f ${fname} ${TMPROOT_ENS}/
    end 
  else
    echo ${var} " = 3d"
    set figdir = ${vardir}/montage
    mkdir -p ${figdir}
    foreach lev ( ${levs} )
      # allens
      set fname = ${figdir}/montage_ens_${var}_lev${lev}.tif
      cp -f ${fname} ${TMPROOT_ENS}/
      # obs ens 
      foreach obsn ( ${obs} )
        set fname = ${figdir}/montage_${obsn}_ens_${var}_lev${lev}.tif
        cp -f ${fname} ${TMPROOT_ENS}/
      end 
    end 
  endif
  
set TMPROOT_CORR = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/ASSM_EXP/archive_yearly_analysis/tmp_corr_ocn
mkdir -p ${TMPROOT_CORR}
  # corr set
  set vardir = ${ARCROOT}/${comp}/${var}/corr_set
  cd $vardir
  set dim3 = `ls * | grep lev`
  if ( ${#dim3} == 0 ) then
    echo ${var} " = 2d"
    set figdir = ${vardir}/montage
    mkdir -p ${figdir}
    # allcorr
    set fname = ${figdir}/montage_corr_${var}.tif
    cp -f ${fname} ${TMPROOT_CORR}/
    # obs corr 
    foreach obsn ( ${obs} )
      set fname = ${figdir}/montage_${obsn}_corr_${var}.tif
      cp -f ${fname} ${TMPROOT_CORR}/
    end 
  else
    echo ${var} " = 3d"
    set figdir = ${vardir}/montage
    mkdir -p ${figdir}
    foreach lev ( ${levs} )
      # allcorr
      set fname = ${figdir}/montage_corr_${var}_lev${lev}.tif
      cp -f ${fname} ${TMPROOT_CORR}/
      # obs corr 
      foreach obsn ( ${obs} )
        set fname = ${figdir}/montage_${obsn}_corr_${var}_lev${lev}.tif
        cp -f ${fname} ${TMPROOT_CORR}/
      end 
    end 
  endif
end
