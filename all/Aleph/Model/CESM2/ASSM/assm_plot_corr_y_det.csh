#!/bin/csh
####!/bin/csh -fx
# Updated  03-Feb-2023 by Yong-Yub Kim, e-mail: kimyy308@pusan.ac.kr


#set vars = (NO3 SiO3 PO4)
#set vars = (NO3 SiO3 PO4)
#set vars = (WVEL diatChl diazChl spChl DIC ALK TEMP SALT)
#set vars = ( BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX )
#set vars = ( UVEL VVEL PD )
#set vars = ( NO3 SiO3 PO4 WVEL diatChl diazChl spChl DIC ALK TEMP SALT BSF HMXL photoC_TOT_zint_100m photoC_TOT_zint SSH NO3_RIV_FLUX NOx_FLUX PO4_RIV_FLUX SiO3_RIV_FLUX UVEL VVEL PD )
#set vars = ( UISOP VISOP WISOP UE_PO4 VN_PO4 WT_PO4  )
set vars = ( TEMP HMXL photoC_TOT_zint_100m diatChl diazChl spChl NO3 PO4 SiO3 Fe UVEL VVEL WVEL )

foreach var ( ${vars} )
#mkdir ~/tmp_script
#mkdir ~/tmp_log
#set tmp_scr =  ~/tmp_script/corr_${var}_assm_tmp.csh
#set tmp_log =  ~/tmp_script/corr_${var}_assm_tmp.log

#cat > $tmp_scr << EOF
#!/bin/csh
set RESOLN = f09_g17
set ARC_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/ocn/${var}
set SAVE_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/archive_yearly/ocn/${var}/corr
set FIG_Y_ROOT = /mnt/lustre/proj/kimyy/Model/CESM2/ESP/ASSM_EXP/fig_yearly/ocn/${var}/corr
mkdir -p $FIG_Y_ROOT
cd $SAVE_Y_ROOT
set file=`ls | grep en4.2_ba-10p1 | grep en4.2_ba-10p2`
cat > fig.jnl << EOF
use "${file}"
shade ${var}[k=1]
frame/file="${FIG_Y_ROOT}/${var}_lev1_en4-10p1_en4-10p2.gif"
EOF
ferret -script fig.jnl

cat > fig.jnl << EOF
use "${file}"
shade ${var}[k=10]
frame/file="${FIG_Y_ROOT}/${var}_lev10_en4-10p1_en4-10p2.gif"
EOF
ferret -script fig.jnl

set file=`ls | grep en4.2_ba-10p1 | grep projdv7.3_ba-10p1`
cat > fig.jnl << EOF
use "${file}"
shade ${var}[k=1]
frame/file="${FIG_Y_ROOT}/${var}_lev1_en4-10p1_projd-10p1.gif"
EOF
ferret -script fig.jnl


end
