#!/usr/bin/env bash
set -eu -o pipefail; shopt -s failglob

## Account settings
PROJECT=${PROJECT:-"nn2980k"}
MACHINE=${MACHINE:-"betzy"}

## Experiment settings
## STOP_OPTION : "ndays", "nmonths", "nyears"
COMPSET=${COMPSET:-"NSSP126frc2esm"}
RES=${RES:-"f19_tn14"}
STOP_OPTION=${STOP_OPTION:-"nyears"}
STOP_N=${STOP_N:-"5"}
RUN_CLOCK=${RUN_CLOCK:-"10:00:00"}
ARC_CLOCK=${ARC_CLOCK:-"3:00:00"}

## Model settings
MODEL=${MODEL:-"noresm2.0.9"}
NORESM_TAG=${NORESM_TAG:-"release-${MODEL}"}
LABEL=${LABEL:-"esm-ssp126-AERA_T"}

## pesize options: "S", "M", "L", "X1"  (see cime_config/config_pes.xml)
PECOUNT=${PECOUNT:-"X1"}
timestamp=$(date +"%Y%m%d")

## Decide if you run model in debug mode
## - Debug flags enabled
RUN_DEBUG_MODE="no"

## Decied if we run with the --run-unsupported flag
## This should be used for compsets for which there are no
## science supported experiments available
RUN_UNSUPPORTED="yes"

## Decide whether or not to run manage_externals/checkout_externals
## While this is not perfect, it works if used consistently
## NB: If you check out the target tag from outside the script,
## be sure to run checkout_externals yourself, this script might
## miss it.
RUN_CHECKOUT="yes"

## Source and case directories
REPO=${REPO:-"https://github.com/NorESMhub/NorESM"}
SRCROOT=${SRCROOT:-"/cluster/projects/${PROJECT}/${USER}/NORESM/NorESM-AERA"}
CASEROOT=${CASEROOT:-"/cluster/projects/${PROJECT}/${USER}/NORESM/cases"}
CASENAME=${CASENAME:-"${COMPSET}_${RES}_${MODEL}_${LABEL}_${timestamp}"}
CASEDIR=${CASEDIR:-"${CASEROOT}/${CASENAME}"}
RUNDIR=${RUNDIR:-"${USERWORK}/noresm/${CASENAME}/run/"}

## Component settings
## CAM_TAG: This can be either a tag or a branch
##    tag: "<tag_name>"
##    branch: "develop/<branch_name>"
## CAM_REPO: source for development version, either url to remote
##           repository or local path
CAM_DEVELOP="yes"
if [ "${CAM_DEVELOP}" == "yes" ]; then
    CAM_LABEL=${CAM_LABEL:-"cam_cesm2_1_rel_05-Nor_v1.0.5_TipESM"}
    CAM_TAG=${CAM_TAG:-"develop/${CAM_LABEL}"}
    CAM_REPO=${CAM_REPO:-"https://github.com/TomasTorsvik/CAM-TTfork"}
fi

# Copy this run script to CASEDIR
COPY_THIS_FILE="yes"
this_file="${PWD}/"; this_file+=$(basename "$0")
echo "Running ${this_file}"


##--- Function: Check for execution errors ---
perror() {
    ## Print an error message and exit if a non-zero error code is passed
    if [ $1 -ne 0 ]; then
        echo "ERROR (${1}): ${2}"
        exit $1
    fi
}

##--- Checkout model source code ---
## (make sure that clone exists, otherwise, clone REPO)
if [ ! -d "${SRCROOT}" ]; then
    git clone -o NorESM ${REPO} ${SRCROOT}
    perror $? "running 'git clone -o NorESM ${REPO} ${SRCROOT}'"
    RUN_CHECKOUT="yes"
fi

cd ${SRCROOT}
## Run code checkout unless explicitly de-selected
if [ "${RUN_CHECKOUT}" != "no" ]; then
    ## Ensure correct source is checked out
    if [ "$( git describe )" != "${NORESM_TAG}" ]; then
        git checkout ${NORESM_TAG}
        perror $? "running 'git checkout ${NORESM_TAG}'"
    fi

    ./manage_externals/checkout_externals
    perror $? "running './manage_externals/checkout_externals'"

    ##--- Checkout CAM development version ---
    if [ "${CAM_DEVELOP}" == "yes" ]; then
        cd ${SRCROOT}/components/cam
        ## Remove old "develop" repo if present
        if git config remote.develop.url > /dev/null; then
            git remote rm develop
        fi
        git remote add develop ${CAM_REPO}
        git fetch --all
        git fetch --tags --all
        git checkout --detach ${CAM_TAG}
    fi
fi

cd ${SRCROOT}
##--- Create your case
if [ ! -d "${CASEDIR}" ]; then
    ## Only run create_newcase if the case does not exist
    echo "=== Creating new case ==="
    cn_args=" --case ${CASEDIR} --compset ${COMPSET} --res ${RES} --mach ${MACHINE} --project ${PROJECT} --pecount ${PECOUNT}"
    if [ "${RUN_UNSUPPORTED}" == "yes" ]; then
        cn_args="${cn_args} --run-unsupported"
    fi
    ./cime/scripts/create_newcase ${cn_args}
    perror $? "running './cime/scripts/create_newcase ${cn_args}'"
fi


## Move to your case directory
cd ${CASEDIR}
perror $? "trying 'cd ${CASEDIR}'"
if [ "${COPY_THIS_FILE}" == "yes" ]; then
    cp ${this_file} ${CASEDIR}
    perror $? "running 'cp ${this_file} ${CASEDIR}'"
fi


## Any PE changes must go here


## Set up the case as configured so far
if [ ! -f "CaseStatus" ]; then
    ## Setup the case if it looks like it has not been setup
    echo "=== Setup for new case ==="
    ./case.setup
    perror $? "trying './case.setup'"
fi

## Copy noresm setup files
NORESM_SETUP_DIR="/nird/datalake/NS2980K/projects/TipESM/noresm_setup/"
cp -r ${NORESM_SETUP_DIR}/SourceMods ./
cp ${NORESM_SETUP_DIR}/user_namelist/* ./

## Copy N1850esm restart files to run directory
RESTDIR=${RESTDIR:-"/cluster/projects/${PROJECT}/NorESM_restart/AERA"}
RESTCASE=${RESTCASE:-"NHIST_f19_tn14_20191104esm"}
RESTDATE=${RESTDATE:-"2015-01-01"}
STARTDATE=${STARTDATE:-"2015-01-01"}
cp ${RESTDIR}/${RESTCASE}/${RESTDATE}-00000/* ${RUNDIR}

# restart settings
./xmlchange RUN_TYPE=hybrid
./xmlchange CONTINUE_RUN=false
./xmlchange RUN_REFCASE=${RESTCASE}
./xmlchange RUN_REFDATE=${RESTDATE}
./xmlchange RUN_STARTDATE=${STARTDATE}

## Changes that affect the build go here
./xmlchange JOB_WALLCLOCK_TIME=${RUN_CLOCK}  --subgroup case.run
perror $? "trying './xmlchange JOB_WALLCLOCK_TIME=${RUN_CLOCK} --subgroup case.run'"
./xmlchange JOB_WALLCLOCK_TIME=${ARC_CLOCK}  --subgroup case.st_archive
perror $? "trying './xmlchange JOB_WALLCLOCK_TIME=${ARC_CLOCK} --subgroup case.st_archive'"
./xmlchange STOP_OPTION=${STOP_OPTION},STOP_N=${STOP_N}
perror $? "trying './xmlchange STOP_OPTION=${STOP_OPTION},STOP_N=${STOP_N}'"

./xmlchange CAM_NML_USE_CASE="ssp126esm_cam6_noresm_frc2_AERA_T"

echo "=== Build the case ==="
#./preview_namelists
./case.build
perror $? "trying './case.build'"


## Last chance to modify run-time settings
## Changes to user_nl_* files goes here
# cat <<EOF >> user_nl_blom
# blom_unit = cgs
# EOF
# perror $? "adding variables to user_nl_blom"


#echo "=== Submit the case ==="
./case.submit
perror $? "trying './case.submit'"
