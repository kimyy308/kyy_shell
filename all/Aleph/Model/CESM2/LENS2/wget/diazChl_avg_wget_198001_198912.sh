#!/bin/bash


WGET_VERSION=$(wget --version | grep -oie "wget [0-9][0-9.]*" | head -n 1 | awk '{print $2}')
if [ -z "$WGET_VERSION" ]
then
WGET_VERSION=PARSE_ERROR
fi

WGET_USER_AGENT="wget/$WGET_VERSION/esg/4.3.2-20230405-191025/created/2023-04-17T03:11:47-06:00"


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
'b.e21.BHISTsmbb.f09_g17.LE2-1011.001.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1011.001.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '51fbf3d7e498781e975cf907bcb6b479'
'b.e21.BHISTsmbb.f09_g17.LE2-1031.002.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1031.002.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'b34e0fc98fdcc73e2a22b21876362b98'
'b.e21.BHISTsmbb.f09_g17.LE2-1051.003.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1051.003.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5f8eb10d8f40bc74e38fb20ea02bb38a'
'b.e21.BHISTsmbb.f09_g17.LE2-1071.004.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1071.004.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '63347bb629f077a7e37d5ca30ac4fa6f'
'b.e21.BHISTsmbb.f09_g17.LE2-1091.005.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1091.005.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5430601bd74983dcfbcb908ab8b3ea80'
'b.e21.BHISTsmbb.f09_g17.LE2-1111.006.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1111.006.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a8428bb35dff4c131f815f01ed4b8e30'
'b.e21.BHISTsmbb.f09_g17.LE2-1131.007.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1131.007.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd584d158605828e9022056c6f488b030'
'b.e21.BHISTsmbb.f09_g17.LE2-1151.008.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1151.008.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'fa9f69d666e8a89d282d57c9f29abada'
'b.e21.BHISTsmbb.f09_g17.LE2-1171.009.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1171.009.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '54daf1d5e99cb203d6e5dbb2420e5665'
'b.e21.BHISTsmbb.f09_g17.LE2-1191.010.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1191.010.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '87c53641391a1f853de9a4bcea5af25b'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.011.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.011.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '42a2881aef52bf5aa772ed59affda7c0'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6c3308398a8369d890add6a1ab8da6b1'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.013.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.013.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'b9e6cf0f515ca6c8d1f4a4b92585cea6'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.014.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.014.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '0f9a9427ff9f2f8a81e3f65bf43dcc65'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.015.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.015.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd5a32838cb362835a2227821b17b6b46'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.016.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.016.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '798bdc0ccae5ca2c0f5e1ef9b2fd093b'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.017.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.017.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'de6a7c7350f86d36c455eb93079e2275'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.018.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.018.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6b819c1f4407cc6b2a59ac8f2251b981'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.019.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.019.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '4a3453624dd43bfa6307e01712928043'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.020.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.020.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c236a205e50e9ff5ac721cce4da0a5a3'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.011.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.011.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6d5e9e09ec127f16feb208f404a240ad'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.012.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.012.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '640a71ed6cb05ccfb2a6d72f2a8d9969'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.013.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.013.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'bc63a91c746f28b29ea0e4ef1a956af4'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.014.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.014.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'e238a07119c252c39de1e2e5aa4028a1'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.015.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.015.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '61f9e0ece624916b09e89dc500d77677'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.016.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.016.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6d977b347e7c61e75a4ab5ff4f97d351'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.017.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.017.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '98f78b4bbf9fd5fedf42355f7dac4b42'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.018.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.018.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '7627bea34f17fe6fde3e8aff713c5231'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.019.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.019.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '76ba32623f1b62d30117b5e7bf955c48'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.020.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.020.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '25e5ccc8af9f8dfda6301c1f64cf2ed0'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.011.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.011.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'dba3932d66e14bd330860ff5804c64fa'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.012.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.012.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '186158345700ea5af90d941f5cd68042'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.013.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.013.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '09cf9dc88b8309bcf298abb54a4d2e5e'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.014.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.014.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'fbc5fecb64ffb4275145d7a23074d0b4'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.015.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.015.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '49b0091653dff53bc74151118183a205'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.016.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.016.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '0b68a6908705341930e23675c9fcf2e2'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.017.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.017.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3b742536a0cafeeb883b7e1cc8faad5b'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.018.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.018.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '443e31d9d4268ba02629319a4ee88f5a'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.019.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.019.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '2bebb9d144131370719e28796a45b551'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.020.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.020.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'da801fccbca8468bb4ba578b5a6e7d28'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.011.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.011.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '597412804f596ae8cd72d17a31492c9d'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.012.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.012.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '8ff291c50c8573fb69f8b232c6f133df'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.013.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.013.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '9e941560981dd39fa0df7c561fd2fb62'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.014.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.014.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '02cdbbce5e2d7d6cffb8ea701fcfb1e6'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.015.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.015.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '62e2c5844c3bfdedf26bee22b838b2f0'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.016.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.016.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '04815406f127ea2728b9045d6637dcab'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.017.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.017.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5e551fa21c0a5e95235585e915f88718'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.018.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.018.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'ba5c37e3318b3b6c12f6b13b4b1fb75f'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.019.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.019.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c90c3c447a329696e9bc372c61ee545e'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.020.pop.h.diazChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diazChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.020.pop.h.diazChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '64bb8daf45302d2166c11cdb848b1641'
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