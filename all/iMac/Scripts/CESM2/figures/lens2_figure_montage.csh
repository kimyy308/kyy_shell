#!/bin/csh

set ARCROOT = /Volumes/kyy_raid/kimyy/Figure/CESM2/ESP/LENS2/archive_yearly_analysis
set comp = ocn
set vars = ( `ls ${ARCROOT}/${comp}/` )
#set obs = ( en4.2_ba projdv7.3_ba )
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
    rm -f ${fname}
    convert SNR_${var}.tif ENS_spread_${var}.tif -append ${figdir}/a.tif
    convert ENS_mean_${var}.tif ENS_variability_${var}.tif -append ${figdir}/b.tif
    convert ${figdir}/a.tif ${figdir}/b.tif +append ${fname}
    rm -f ${figdir}/a.tif
    rm -f ${figdir}/b.tif
  else
    echo ${var} " = 3d"
    set figdir = ${vardir}/montage
    mkdir -p ${figdir}
    foreach lev ( ${levs} )
      # allens
      set fname = ${figdir}/montage_ens_${var}_lev${lev}.tif
      rm -f ${fname}
      convert SNR_${var}_lev${lev}.tif ENS_spread_${var}_lev${lev}.tif -append ${figdir}/a.tif
      convert ENS_mean_${var}_lev${lev}.tif ENS_variability_${var}_lev${lev}.tif -append ${figdir}/b.tif
      convert ${figdir}/a.tif ${figdir}/b.tif +append ${fname}
      rm -f ${figdir}/a.tif
      rm -f ${figdir}/b.tif
    end 
  endif
  
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
    rm -f ${fname}
    convert corr_mean_${var}.tif corr_min_${var}.tif -append ${figdir}/a.tif
    convert corr_max_${var}.tif corr_std_${var}.tif -append ${figdir}/b.tif
    convert ${figdir}/a.tif ${figdir}/b.tif +append ${fname}
    rm -f ${figdir}/a.tif
    rm -f ${figdir}/b.tif
  else
    echo ${var} " = 3d"
    set figdir = ${vardir}/montage
    mkdir -p ${figdir}
    foreach lev ( ${levs} )
      # allcorr
      set fname = ${figdir}/montage_corr_${var}_lev${lev}.tif
      rm -f ${fname}
      convert corr_mean_${var}_lev${lev}.tif corr_min_${var}_lev${lev}.tif -append ${figdir}/a.tif
      convert corr_max_${var}_lev${lev}.tif corr_std_${var}_lev${lev}.tif -append ${figdir}/b.tif
      convert ${figdir}/a.tif ${figdir}/b.tif +append ${fname}
      rm -f ${figdir}/a.tif
      rm -f ${figdir}/b.tif
    end 
  endif
end
