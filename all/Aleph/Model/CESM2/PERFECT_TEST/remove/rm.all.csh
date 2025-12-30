#!/bin/csh

set mem = LE2-1231.011-20p1

rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/atm/proc/tseries/hour_?
rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/lnd/proc/tseries/hour_3
rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/lnd/proc/tseries/day_365
rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/ocn/proc/tseries/year_1
rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/glc
rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/rof/proc/tseries/day_1
rm -rf /mnt/lustre/proj/earth.system.predictability/PERFECT_TEST_timeseries/ASSM_EXP/archive/*f09_g17.assm*.${mem}/rof/proc/tseries/month_1/*rtm*

echo $mem > mem_name

csh rm.timeseries.atm.csh
csh rm.timeseries.atm.day_1.csh
csh rm.timeseries.ice.csh
csh rm.timeseries.lnd.csh
csh rm.timeseries.ocn.csh
csh rm.timeseries.rof.csh

