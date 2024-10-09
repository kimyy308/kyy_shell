#!/bin/csh

set mem = `cat mem_name`

  set vnames1 = ( ALT AR EFLX_LH_TOT FGR12 FIRA\
		FSA FSDSND FSDSNI FSDS FSDSVD\
		FSDSVI FSH FSM FSNO H2OCAN\
		H2OSFC H2OSNO HR QDRAI_PERCH QDRAI\
		QFLX_SNOW_DRAIN QFLX_SUB_SNOW QINTR QRUNOFF QSNOEVAP\
		QSNOFRZ QVEGE QVEGT SNOBCMSL SNOCAN\
		SNOFSRND SNOFSRNI SNOFSRVD SNOFSRVI SNOTXMASS\
		SNOWICE SNOWLIQ TG TREFMNAV TREFMXAV\
		TV CPHASE )

  foreach vname1 ( $vnames1 )
   rm -f  /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ALL_timeseries/archive/*f09_g17.assm.${mem}/lnd/proc/tseries/day_1/*.$vname1.*.nc
  end

  set vnames2 = ( C13_NBP C14_NBP DWT_SEEDN_TO_DEADSTEM DWT_SEEDN_TO_LEAF EFLX_DYNBAL\
		EFLX_LH_TOT_R ERRH2OSNO ERRSEB ERRSOI ERRSOL\
		ESAI FCOV FFIX_TO_SMINN FIRA_R FPI\
		FROOTC_ALLOC FROOTC_LOSS FROOTC FROOTC FROOTN\
		FSAT FSDSNDLN FSDSND FSDSNI FSDSVDLN\
		FSDSVD FSDSVI FSH_G FSH_R FSH_V\
		FSM FSRNDLN FSRVDLN GROSS_NMIN GR\
		H2OSNO_TOP HEAT_FROM_AC HTOP HTOP LAISHA\
		LAISUN LAND_USE_FLUX LEAFC_ALLOC LEAFC_LOSS LEAFC\
		LEAFN LITFALL LITR1C LITR1C_TO_SOIL1C LITR1N\
		LITR2C LITR2N LITR3C LITR3N LITTERC_LOSS\
		LIVECROOTC LIVECROOTN LIVESTEMC LIVESTEMN MR\
		NDEPLOY NDEP_TO_SMINN NET_NMIN OCDEP PCO2\
		PFT_FIRE_CLOSS PFT_FIRE_NLOSS PLANT_NDEMAND POTENTIAL_IMMOB PSNSHADE_TO_CPOOL\
		PSNSHA PSNSUN PSNSUN_TO_CPOOL QDRIP QFLX_ICE_DYNBAL\
		QFLX_LIQ_DYNBAL QINTR QRUNOFF_RAIN_TO_SNOW_CONVERSION RETRANSN RETRANSN_TO_NPOOL\
		RR SABG SABV SEEDC SEEDN\
		SMINN SMINN_TO_NPOOL SMINN_TO_PLANT SNOBCMCL SNOBCMSL\
		SNODSTMCL SNODSTMSL SNOOCMCL SNOOCMSL SNOW_SINKS\
		SOIL1C SOIL1N SOIL2C SOIL2N SOIL3C\
		SOIL3N SR SUPPLEMENT_TO_SMINN TBUILD TOTLITC\
		TOTLITN TOTPFTC TOTPFTN TSAI TSOI_ICE\
		URBAN_AC URBAN_HEAT WASTEHEAT WOODC_ALLOC WOODC_LOSS\
		WOODC WOOD_HARVESTC WOOD_HARVESTC WOOD_HARVESTN XSMRPOOL_RECOVER\
		XSMRPOOL ZBOT ACTUAL_IMMOB ALTMAX ALT )

  foreach vname2 ( $vnames2 )
   rm -f  /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ALL_timeseries/archive/*f09_g17.assm.${mem}/lnd/proc/tseries/month_1/*.$vname2.*.nc
  end

  set vnames3 = ( AR BCDEP BTRANMN C13_AGNPP C13_AR\
		C13_BGNPP C13_COL_FIRE_CLOSS C13_CPOOL C13_CROPPROD1C_LOSS C13_CROPPROD1C\
		C13_CROPSEEDC_DEFICIT C13_CWDC C13_DEADCROOTC C13_DEADSTEMC C13_DISPVEGC\
		C13_DWT_CONV_CFLUX_DRIBBLED C13_DWT_CONV_CFLUX C13_DWT_CROPPROD1C_GAIN C13_DWT_SLASH_CFLUX C13_DWT_WOODPRODC_GAIN\
		C13_ER C13_FROOTC C13_GPP C13_GRAINC C13_GR\
		C13_HR C13_LEAFC C13_LITR1C C13_LITR2C C13_LITR3C\
		C13_LITTERC_HR C13_LIVECROOTC C13_LIVESTEMC C13_MR C13_NEE\
		C13_NEP C13_NPP C13_PFT_FIRE_CLOSS C13_PSNSHADE_TO_CPOOL C13_PSNSHA\
		C13_PSNSUN C13_PSNSUN_TO_CPOOL C13_RR C13_SEEDC C13_SOIL1C\
		C13_SOIL2C C13_SOIL3C C13_SOILC_HR C13_SR C13_STORVEGC\
		C13_TOTCOLC C13_TOTECOSYSC C13_TOTLITC_1m C13_TOTLITC C13_TOTPFTC\
		C13_TOTSOMC_1m C13_TOTSOMC C13_TOTVEGC C13_TOT_WOODPRODC_LOSS C13_TOT_WOODPRODC\
		C13_XSMRPOOL C14_AGNPP C14_AR C14_BGNPP C14_COL_FIRE_CLOSS\
		C14_CPOOL C14_CROPPROD1C_LOSS C14_CROPPROD1C C14_CROPSEEDC_DEFICIT C14_CWDC\
		C14_DEADCROOTC C14_DEADSTEMC C14_DISPVEGC C14_DWT_CONV_CFLUX_DRIBBLED C14_DWT_CONV_CFLUX\
		C14_DWT_CROPPROD1C_GAIN C14_DWT_SLASH_CFLUX C14_DWT_WOODPRODC_GAIN C14_ER C14_FROOTC\
		C14_GPP C14_GRAINC C14_GR C14_HR C14_LEAFC\
		C14_LITR1C C14_LITR2C C14_LITR3C C14_LITTERC_HR C14_LIVECROOTC\
		C14_LIVESTEMC C14_MR C14_NEE C14_NEP C14_NPP\
		C14_PFT_CTRUNC C14_PFT_FIRE_CLOSS C14_PSNSHADE_TO_CPOOL C14_PSNSHA C14_PSNSUN\
		C14_PSNSUN_TO_CPOOL C14_RR C14_SEEDC C14_SOIL1C C14_SOIL2C\
		C14_SOIL3C C14_SOILC_HR C14_SR C14_STORVEGC C14_TOTCOLC\
		C14_TOTECOSYSC C14_TOTLITC_1m C14_TOTLITC C14_TOTPFTC C14_TOTSOMC_1m\
		C14_TOTSOMC C14_TOTVEGC C14_TOT_WOODPRODC_LOSS C14_TOT_WOODPRODC C14_XSMRPOOL )

  foreach vname3 ( $vnames3 )
     rm -f  /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ALL_timeseries/archive/*f09_g17.assm.${mem}/lnd/proc/tseries/month_1/*.$vname3.*.nc
  end

  set vnames4 = ( CH4PROD CH4_SURF_AERE_SAT CH4_SURF_AERE_UNSAT CH4_SURF_DIFF_SAT CH4_SURF_DIFF_UNSAT\
		CH4_SURF_EBUL_SAT CH4_SURF_EBUL_UNSAT COST_NACTIVE COST_NFIX COST_NRETRANS\
		CPOOL CROPPROD1C_LOSS CROPPROD1C CROPPROD1N_LOSS CROPPROD1N\
		CROPSEEDC_DEFICIT CWDC_LOSS CWDC CWDN DEADCROOTC\
		DEADCROOTN DEADSTEMC DEADSTEMN DENIT DISPVEGC\
		DISPVEGN DSL DSTDEP DWT_CONV_CFLUX_DRIBBLED DWT_CONV_CFLUX_PATCH\
		DWT_CONV_CFLUX DWT_CONV_NFLUX DWT_CROPPROD1C_GAIN DWT_CROPPROD1N_GAIN DWT_SLASH_CFLUX\
		DWT_SLASH_CFLUX DWT_WOODPRODC_GAIN DWT_WOODPRODN_GAIN DWT_WOOD_PRODUCTC_GAIN_PATCH DWT_WOOD_PRODUCTC_GAIN_PATCH\
		EFLXBUILD EFLX_GRND_LAKE EFLX_LH_TOT_ICE EFLX_LH_TOT ELAI\
		ERRH2O ER FCEV FCEV FCH4_DFSAT\
	FCH4 FCH4TOCO2 FCTR FCTR F_DENIT\
	FGEV FH2OSFC FINUNDATED FIRA  FIRE_ICE\
	FIRE_R FLDS_ICE FLDS F_N2O_DENIT F_N2O_NIT\
	F_NIT FREE_RETRANSN_TO_NPOOL FROOTC_TO_LITTER FSA FSDS\
	FSDSVILN FSH_ICE FSH_PRECIP_CONVERSION FSH_RUNOFF_ICE_TO_LIQ FSH\
	FSH_TO_COUPLER FSNO_EFF FSNO_ICE FSNO FSR_ICE\
	FSRND FSRNI FSR FSRVD FSRVI\
	GRAINC GRAINC_TO_FOOD  GRAINC_TO_SEED GRAINN GSSHALN\
	GSSHA GSSUNLN GSSUN H2OCAN HIA_R\
	HIA HIA_U HR HR_vr HUMIDEX_R\
	HUMIDEX HUMIDEX_U ICE_CONTENT1 JMX25T Jmx25Z\
	LEAFC_CHANGE LEAFCN LEAFC_TO_LITTER_FUN LEAFC_TO_LITTER LEAF_MR )

  foreach vname4 ( $vnames4 )
     rm -f  /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ALL_timeseries/archive/*f09_g17.assm.${mem}/lnd/proc/tseries/month_1/*.$vname4.*.nc
  end

  set vnames5 = ( LEAFN_TO_LITTER LFC2 LIQCAN LIQUID_CONTENT1 LITR1N_TO_SOIL1N\
	LITR2C_TO_SOIL1C LITR2N_TO_SOIL1N LITR3C_TO_SOIL2C LITR3N_TO_SOIL2N LITTERC_HR\
	LNC NACTIVE_NH4 NACTIVE_NO3 NACTIVE NAM_NH4\
	NAM_NO3 NAM NECM_NH4 NECM_NO3 NECM\
	NEM NFERTILIZATION NFIX NNONMYC_NH4 NNONMYC_NO3\
	NNONMYC NPASSIVE NPOOL NPP_GROWTH NPP_NACTIVE_NH4\
	NPP_NACTIVE_NO3 NPP_NACTIVE NPP_NAM_NH4 NPP_NAM_NO3 NPP_NAM\
	NPP_NECM_NH4 NPP_NECM_NO3 NPP_NECM NPP_NFIX NPP_NNONMYC_NH4\
	NPP_NNONMYC_NO3 NPP_NNONMYC NPP_NRETRANS NPP_NUPTAKE NPP_NUPTAKE\
	NRETRANS_REG NRETRANS_SEASON NRETRANS_STRESS NRETRANS NUPTAKE_NPP_FRACTION\
	NUPTAKE O_SCALAR PARVEGLN PBOT PCH4\
	PCT_LANDUNIT POT_F_DENIT POT_F_NIT QBOT QCHARGE\
	QDRAI_PERCH QDRAI QDRAI_XS QFLX_DEW_GRND QFLX_DEW_SNOW\
	QFLX_SNOW_DRAIN_ICE QFLX_SNOW_DRAIN QFLX_SUB_SNOW_ICE QFLX_SUB_SNOW QICE_FRZ\
	QICE_MELT QICE QINFL QIRRIG QRUNOFF_ICE\
	QRUNOFF_ICE_TO_COUPLER QRUNOFF_TO_COUPLER QSNOCPLIQ QSNOEVAP QSNOFRZ_ICE\
	QSNOFRZ QSNOMELT_ICE QSNO_TEMPUNLOAD QSNO_WINDUNLOAD QSNWCPICE\
	RAIN_FROM_ATM RAIN_ICE RC13_CANAIR RC13_PSNSHA RC13_PSNSUN\
	RSSHA RSSUN SABG_PEN SLASH_HARVESTC SLASH_HARVESTC\
	SMIN_NH4 SMIN_NO3_LEACHED SMIN_NO3_RUNOFF SMIN_NO3 SMINN_TO_PLANT_FUN\
	SMP SNOCAN SNOFSRND SNOFSRNI SNOFSRVD\
	SNOFSRVI SNOINTABS SNOTXMASS_ICE SNOTXMASS SNOUNLOAD\
	SNOW_DEPTH SNOWDP SNOWDP SNOW_FROM_ATM SNOWICE_ICE\
	SNOW_ICE SNOWICE SNOWLIQ_ICE SNOWLIQ SNOW_SOURCES\
	SOILC_CHANGE SOILC_HR SOILRESIS SOM_C_LEACHED SWBGT_R\
	SWBGT_U TBOT TG_ICE TG TH2OSFC\
	TKE1 TOPO_COL_ICE TOTCOLCH4 TOTECOSYSN TOTLITC_1m\
	TOTLITN_1m TOTSOMC_1m TOTSOMN_1m TOTVEGN TOT_WOODPRODC_LOSS\
	TOT_WOODPRODC TOT_WOODPRODN_LOSS TOT_WOODPRODN TPU25T TREFMNAV\
	TREFMXAV TSA_ICE TSA T_SCALAR TSKIN\
	TSL U10_DUST VCMX25T Vcmx25Z Vcmx25Z\
	VEGWP VOLRMCH VOLR WA WIND\
	W_SCALAR WTGQ ZWT_CH4_UNSAT ZWT_PERCH ZWT )

  foreach vname5 ( $vnames5 )
     rm -f  /mnt/lustre/proj/earth.system.predictability/ATM_TEST/EXP_ALL_timeseries/archive/*f09_g17.assm.${mem}/lnd/proc/tseries/month_1/*.$vname5.*.nc
  end

