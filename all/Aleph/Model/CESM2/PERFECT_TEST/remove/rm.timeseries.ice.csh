#!/bin/csh

set mem = `cat mem_name`

  set vnames1 = ( congel_d daidtd_d daidtt_d dvidtd_d dvidtt_d\
		frazil_d fswabs_d fswdn_d fswup_d FYarea_d\
		hs_d meltb_d meltl_d melts_d meltt_d\
		rain_d snoice_d snow_d snowfrac_d strairx_d\
		strairy_d strintx_d strinty_d strocnx_d strocny_d\
		vicen_d vsnon_d	aicen_d	apond_ai_d fswthru_d\
		hi_d	ice_present_d )

  foreach vname1 ( $vnames1 )
   rm -f /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/ice/proc/tseries/day_1/*.$vname1.*.nc
  end

  set vnames2 = ( aicen albsni alidf_ai alidr_ai alvdf_ai\
		alvdr_ai apeff_ai apond_ai ardg congel\
		dagedtd dagedtt daidtd daidtt dvidtd\
		dvidtt evap frazil fresh fsalt\
		fswdn fswthru hi hs ice_present\
		meltb meltl meltt siage sialb\
		sicompstren sidconcdyn sidconcth sidmassdyn sidmassevapsubl\
		sidmassgrowthbot sidmassgrowthwat sidmasslat sidmassmeltbot sidmassmelttop\
		sidmasssi sidmassth sidmasstranx sidmasstrany sidragtop\
		sifb siflcondbot siflcondtop siflfwbot siflfwdrain\
		sifllatstop sifllwdtop sifllwutop siflsaltbot siflsenstop\
		siflsensupbot siflswdbot siflswdtop siflswutop siforcecoriolx\
		siforcecorioly siforceintstrx siforceintstry siforcetiltx siforcetilty\
		sihc siitdconc siitdsnthick siitdthick sipr\
		sirdgthick sisnhc sisnthick sispeed sistreave\
		sistremax sistrxdtop sistrxubot sistrydtop sistryubot\
		sitempbot sitempsnic sitemptop siu siv\
		sndmassmelt sndmasssnf sndmassubl snowfrac uatm\
		vatm divu fhocn flat_ai flat\
		flwdn flwup fsens_ai fsens fswabs\
		fswintn fswsfcn fswthrun fswup FYarea\
		melts rain shear sig1 sig2\
		snoice snow strairx strairy strcorx\
		strcory strength strintx strinty strocnx\
		strocny strtltx	strtlty	Tsfc uvel\
		vicen vsnon vvel )

  foreach vname2 ( $vnames2 )
   rm -f /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/ice/proc/tseries/month_1/*.$vname2.*.nc
  end
