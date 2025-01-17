#!/bin/bash


WGET_VERSION=$(wget --version | grep -oie "wget [0-9][0-9.]*" | head -n 1 | awk '{print $2}')
if [ -z "$WGET_VERSION" ]
then
WGET_VERSION=PARSE_ERROR
fi

WGET_USER_AGENT="wget/$WGET_VERSION/esg/4.3.2-20230405-191025/created/2023-04-17T03:12:03-06:00"


##############################################################################
#
# Climate Data Gateway download script
#
#
# Generated by: NCAR Climate Data Gateway
#
# Template version: 0.4.7-wget-checksum
#
#
# Your download selection includes data that might be secured using API Token based
# authentication. Therefore, this script can have your api-token. If you
# re-generate your API Token after you download this script, the download will
# fail. If that happens, you can either re-download this script or you can replace
# the old API Token with the new one by going to the Account Home:
#
# https://www.earthsystemgrid.org/account/user/account-home.html
#
# and clicking on "API Token" link under "Personal Account". You will be asked
# to log into the application before you can view your API Token.
#
#
# Dataset
# ucar.cgd.cesm2le.ocn.proc.monthly_ave.diazChl
# f415ad4a-1cd6-43e3-b01b-a130bde00a0a
# https://www.earthsystemgrid.org/dataset/ucar.cgd.cesm2le.ocn.proc.monthly_ave.diazChl.html
# https://www.earthsystemgrid.org/dataset/id/f415ad4a-1cd6-43e3-b01b-a130bde00a0a.html
#
# Dataset Version
# 1
# 67461dda-1169-4937-9217-410f6abb073f
# https://www.earthsystemgrid.org/dataset/ucar.cgd.cesm2le.ocn.proc.monthly_ave.diazChl/version/1.html
# https://www.earthsystemgrid.org/dataset/version/id/67461dda-1169-4937-9217-410f6abb073f.html
#
##############################################################################

CACHE_FILE=.md5_results
MAX_RETRY=3


usage() {
    echo "Usage: $(basename $0) [flags]"
    echo "Flags is one of:"
    sed -n '/^while getopts/,/^done/  s/^\([^)]*\)[^#]*#\(.*$\)/\1 \2/p' $0
}
#defaults
debug=0
clean_work=1
verbose=1

#parse flags

while getopts ':pdvqko:' OPT; do

    case $OPT in

        p) clean_work=0;;       #	: preserve data that failed checksum
        o) output="$OPTARG";;   #<file>	: Write output for DML in the given file
        d) debug=1;;            #	: display debug information
        v) verbose=1;;          #       : be more verbose
        q) quiet=1;;            #	: be less verbose
        k) cert=1;;            #	: add --no-check-certificate
        \?) echo "Unknown option '$OPTARG'" >&2 && usage && exit 1;;
        \:) echo "Missing parameter for flag '$OPTARG'" >&2 && usage && exit 1;;
    esac
done
shift $(($OPTIND - 1))

if [[ "$output" ]]; then
    #check and prepare the file
    if [[ -f "$output" ]]; then
        read -p "Overwrite existing file $output? (y/N) " answ
        case $answ in y|Y|yes|Yes);; *) echo "Aborting then..."; exit 0;; esac
    fi
    : > "$output" || { echo "Can't write file $output"; break; }
fi

    ((debug)) && echo "debug=$debug, cert=$cert, verbose=$verbose, quiet=$quiet, clean_work=$clean_work"

##############################################################################


check_chksum() {
    local file="$1"
    local chk_type=$2
    local chk_value=$3
    local local_chksum

    case $chk_type in
        md5) local_chksum=$(md5sum "$file" | cut -f1 -d" ");;
        *) echo "Can't verify checksum." && return 0;;
    esac

    #verify
    ((debug)) && echo "local:$local_chksum vs remote:$chk_value"
    diff -q <(echo $local_chksum) <(echo $chk_value) >/dev/null
}

download() {

    if [[ "$cert" ]]; then
      wget="wget --no-check-certificate -c --user-agent=$WGET_USER_AGENT"
    else
      wget="wget -c --user-agent=$WGET_USER_AGENT"
    fi

    ((quiet)) && wget="$wget -q" || { ((!verbose)) && wget="$wget -nv"; }

    ((debug)) && echo "wget command: $wget"

    while read line
    do
        # read csv here document into proper variables
        eval $(awk -F "' '" '{$0=substr($0,2,length($0)-2); $3=tolower($3); print "file=\""$1"\";url=\""$2"\";chksum_type=\""$3"\";chksum=\""$4"\""}' <(echo $line) )

        #Process the file
        echo -n "$file ..."

        #are we just writing a file?
        if [ "$output" ]; then
            echo "$file - $url" >> $output
            echo ""
            continue
        fi

        retry_counter=0

        while : ; do
                #if we have the file, check if it's already processed.
                [ -f "$file" ] && cached="$(grep $file $CACHE_FILE)" || unset cached

                #check it wasn't modified
                if [[ -n "$cached" && "$(stat -c %Y $file)" == $(echo "$cached" | cut -d ' ' -f2) ]]; then
                    echo "Already downloaded and verified"
                    break
                fi

                # (if we had the file size, we could check before trying to complete)
                echo "Downloading"
                $wget -O "$file" $url || { failed=1; break; }

                #check if file is there
                if [[ -f "$file" ]]; then
                        ((debug)) && echo file found
                        if ! check_chksum "$file" $chksum_type $chksum; then
                                echo "  $chksum_type failed!"
                                if ((clean_work)); then
                                        rm "$file"

                                        #try again up to n times
                                        echo -n "  Re-downloading..."

                                        if [ $retry_counter -eq $MAX_RETRY]
                                        then
                                            echo "  Re-tried file $file $MAX_RETRY times...."
                                            break
                                        fi
                                        retry_counter=`expr $retry_counter + 1`

                                        continue
                                else
                                        echo "  don't use -p or remove manually."
                                fi
                        else
                                echo "  $chksum_type ok. done!"
                                echo "$file" $(stat -c %Y "$file") $chksum >> $CACHE_FILE
                        fi
                fi
                #done!
                break
        done

        if ((failed)); then
            echo "download failed"

            unset failed
        fi

    done <<EOF--dataset.file.url.chksum_type.chksum
'b.e21.BHISTsmbb.f09_g17.LE2-1011.001.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1011.001.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '07d604c8ef8078827e2dfb8f905c3381'
'b.e21.BHISTsmbb.f09_g17.LE2-1031.002.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1031.002.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6310c785670681ff21a96841139e1a3f'
'b.e21.BHISTsmbb.f09_g17.LE2-1051.003.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1051.003.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3834d20f0c280145b380b5f8bbaedb90'
'b.e21.BHISTsmbb.f09_g17.LE2-1071.004.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1071.004.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5ac09ee34cfd2aa456871f0d8216b14c'
'b.e21.BHISTsmbb.f09_g17.LE2-1091.005.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1091.005.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6bdf1a10d6c66f6ee50a82b23ee03f22'
'b.e21.BHISTsmbb.f09_g17.LE2-1111.006.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1111.006.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '8372c708ebe90cedd4fce89558e83c02'
'b.e21.BHISTsmbb.f09_g17.LE2-1131.007.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1131.007.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '2e5fab973d2225289f356ed15f89b537'
'b.e21.BHISTsmbb.f09_g17.LE2-1151.008.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1151.008.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'ca1310eb5a2c2fc1e2e8d514ccbee635'
'b.e21.BHISTsmbb.f09_g17.LE2-1171.009.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1171.009.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c7e351777a1f1682ca73dbe75ec077ef'
'b.e21.BHISTsmbb.f09_g17.LE2-1191.010.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1191.010.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd9dc6ee0ce0694e8352bcae54f3ba14c'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.011.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.011.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '83286b5f99ff97b718f04da8db6b3d0b'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c5f833dd8069ff519f2edbcfe9d98f78'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.013.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.013.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '1c5126f9709612adfe9814a16737d7cc'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.014.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.014.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '03cafff6eb52060dd56ca4e4b1e00496'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.015.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.015.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'b15805c1ef9129f2c2a36e2bb1fe228c'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.016.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.016.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '2210948bea07f55befdc38eb18eb8200'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.017.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.017.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd6bd1ffd8ccad11b25e393527ef70b4d'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.018.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.018.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'bde0f1a78b77288f0b983a694b9ac072'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.019.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.019.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '7d236986f19d2c9cb99c09c5e13db4ec'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.020.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.020.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'ca2f9452d7198b32d221b4cb0cd37c88'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.011.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.011.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'fa6a8bc95f74095ded4c32cfbda72225'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.012.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.012.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '4219a4622e98c88d9dc3c0c1a65e1fe8'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.013.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.013.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'ea75f1783c5d7e919fde504b08089c2b'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.014.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.014.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '0a77681044a462a3140fe8f3fd347ea2'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.015.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.015.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '95c62dbed4eaabf06320b488866d7234'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.016.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.016.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '81dd10f6a31b135ce0baf65f09d160ce'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.017.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.017.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5ae67d81b6b94d778e457a0cecdae7b7'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.018.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.018.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '2f874631e80f62189fa2de0f1ea991aa'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.019.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.019.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '04af7a76d816a24e2b4a46802b330314'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.020.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.020.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '794bc1e04b1f49395cc7e4ec2d45a878'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.011.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.011.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a5dcf65fe8e13b7a8020e7fd3150a037'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.012.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.012.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a6b8c9a1a5c4a5ecf18db81fa34baec2'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.013.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.013.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '02a30261f71a23d6272f2c0d22b3387e'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.014.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.014.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a6a1b0252f8718ed234670b06047c56d'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.015.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.015.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'be7b21f7daadde81a9688612e2ae3eff'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.016.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.016.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '28ee47bfbafcd9b28209ef343d277be5'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.017.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.017.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'cdf4ca0697c6dcad6d5b3e3fe4bb0606'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.018.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.018.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '4d7d4b5a237acefdfeaad079a6a173d8'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.019.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.019.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '064a94c2a752a15d0c2ad0cf37615914'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.020.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.020.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c36b36a9b4fcae3853a37d51b52ad2e2'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.011.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.011.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '283f852595ff2f528704735171e9a7f0'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.012.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.012.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '651c972f5a0934ad4f903fc8a3d55a75'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.013.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.013.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '4a60b1661b738b3a07dbeead90108793'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.014.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.014.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'b89f7a3d40e92cfd21e8902dc271dc4f'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.015.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.015.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '7647b77ba20ed8f66a2762e310355a94'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.016.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.016.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '4f01ffd6b1a83446ab25f1f8fb97159d'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.017.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.017.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '249ead8f613a5cf7601646e0a55f9d45'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.018.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.018.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3d6f68d7b2d7b02dcb199043e795dfb6'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.019.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.019.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'bb25d13ba75a3ef50ca7bdf65e1c965b'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.020.pop.h.diazChl.197001-197912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.020.pop.h.diazChl.197001-197912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c16e36db1bdb275766f7031484387aa5'
EOF--dataset.file.url.chksum_type.chksum

}


#
# MAIN
#
echo "Running $(basename $0) version: $version"

#do we have old results? Create the file if not
[ ! -f $CACHE_FILE ] && echo "#filename mtime checksum" > $CACHE_FILE

download

#remove duplicates (if any)
{ rm $CACHE_FILE && tac | awk '!x[$1]++' | tac > $CACHE_FILE; } < $CACHE_FILE
