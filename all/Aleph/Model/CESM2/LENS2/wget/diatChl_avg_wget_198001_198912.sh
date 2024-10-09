#!/bin/bash


WGET_VERSION=$(wget --version | grep -oie "wget [0-9][0-9.]*" | head -n 1 | awk '{print $2}')
if [ -z "$WGET_VERSION" ]
then
WGET_VERSION=PARSE_ERROR
fi

WGET_USER_AGENT="wget/$WGET_VERSION/esg/4.3.2-20230405-191025/created/2023-04-17T03:10:08-06:00"


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
# ucar.cgd.cesm2le.ocn.proc.monthly_ave.diatChl
# 578737d2-1a9c-4d96-9cc2-f132482bf3cd
# https://www.earthsystemgrid.org/dataset/ucar.cgd.cesm2le.ocn.proc.monthly_ave.diatChl.html
# https://www.earthsystemgrid.org/dataset/id/578737d2-1a9c-4d96-9cc2-f132482bf3cd.html
#
# Dataset Version
# 1
# 9de5e76c-845c-4691-bebe-eb6d6b79a182
# https://www.earthsystemgrid.org/dataset/ucar.cgd.cesm2le.ocn.proc.monthly_ave.diatChl/version/1.html
# https://www.earthsystemgrid.org/dataset/version/id/9de5e76c-845c-4691-bebe-eb6d6b79a182.html
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
'b.e21.BHISTsmbb.f09_g17.LE2-1011.001.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1011.001.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3074401c3d9457297d589f6dbef44676'
'b.e21.BHISTsmbb.f09_g17.LE2-1031.002.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1031.002.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c4c72cf752d8cbd56192f2e9a5a5aaa2'
'b.e21.BHISTsmbb.f09_g17.LE2-1051.003.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1051.003.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '19f3e54c82900b0366010ccc6469f8ed'
'b.e21.BHISTsmbb.f09_g17.LE2-1071.004.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1071.004.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '1929f43798de6de4651cb99d227ad173'
'b.e21.BHISTsmbb.f09_g17.LE2-1091.005.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1091.005.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '9bb71d3da2bfc772a610d84787aaaf1a'
'b.e21.BHISTsmbb.f09_g17.LE2-1111.006.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1111.006.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'afaa3ddf9643f41311d025a1ce182419'
'b.e21.BHISTsmbb.f09_g17.LE2-1131.007.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1131.007.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '33b12313e9100d5b5bc6a0da308f6158'
'b.e21.BHISTsmbb.f09_g17.LE2-1151.008.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1151.008.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '00e583bada1697222088ad82743b9707'
'b.e21.BHISTsmbb.f09_g17.LE2-1171.009.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1171.009.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '62b0a67c4ff1584e36f4c2c617a7985a'
'b.e21.BHISTsmbb.f09_g17.LE2-1191.010.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1191.010.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '7e522e6d137f4ff369759507984aa242'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.011.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.011.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'cc68ce91252ea2f53418e9ea3c29ce76'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3efaa8602f4545d6e8838e674ef515bf'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.013.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.013.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a8bf70734a1253523a419fcb08abae82'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.014.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.014.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3b377577211ba25dd4a01191b3c9e3cc'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.015.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.015.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '14bc6d95c71c26d59ca14dbe35863dc9'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.016.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.016.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '118b8ca80911f819c1f0ad3ead4796b8'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.017.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.017.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a8e28c5f03ceddfe72c13e2b34188049'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.018.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.018.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'f232bf45b10d2bda97e53c356b332aa5'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.019.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.019.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '320a5519a8b5b2f844c04f25ed7e3f76'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.020.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.020.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '6f29f0c894038ccf5d7c210901e8a671'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.011.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.011.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'fd53ad2c024d47a6491f19eae0c499d2'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.012.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.012.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '11c8d3cfa6d04ca30d2a4f7c9b3d0d79'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.013.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.013.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '3396baa2da68ef763a786ba83bb8b96d'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.014.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.014.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '064455cd182481e35b250a3f152ec0d4'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.015.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.015.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '8db3a6ea3ff3e9b9483b83c5ed852f01'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.016.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.016.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd7da73e69e6485e0ed039726823a7241'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.017.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.017.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '2d7cb8cc8c707f99d6fdc20466238066'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.018.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.018.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd48908013ef1b772c7cf0b98b084afa4'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.019.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.019.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'a77d7aa398533b6381639be28441c7c0'
'b.e21.BHISTsmbb.f09_g17.LE2-1251.020.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1251.020.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '7c21743900dc76c12a65b32fa315b245'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.011.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.011.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '370cf6fbbffcf72801152419e071b02e'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.012.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.012.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '762564dae4073f183996ce53ba7554b5'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.013.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.013.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'ea008a3e4cb891e5e45e1b70eacb73fc'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.014.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.014.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '05bb5b497c656227a5571b2d3ba0fbac'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.015.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.015.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '21c52d8b319e48d150fac2e0692345ba'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.016.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.016.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '9db725ac14f4cd19c97c3c53bcbd3d9a'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.017.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.017.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '320d4b833524d2a173471e6b86d44f29'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.018.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.018.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '906fc7fbe67a570b5b880cf469d8bd8b'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.019.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.019.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '9710cf662da43ec9849ed5dd045a5807'
'b.e21.BHISTsmbb.f09_g17.LE2-1281.020.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1281.020.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '64a69234e338621ef54d861e0d220620'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.011.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.011.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '005a0b186f1ddc5504adec86a92b0e20'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.012.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.012.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '07a4e9afb690303284a4028bcb86962d'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.013.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.013.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '11a6db6508aaa32aecff01ac5c3565fb'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.014.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.014.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'eb1eecc7b29d718acfce81f70027bdeb'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.015.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.015.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '0676cc52f81fe1a58c861f3183ef0ab1'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.016.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.016.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'd09bab91caa29e44c21c9c2edf028adf'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.017.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.017.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5598eeba20c84794068677081e936f00'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.018.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.018.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '1d0e2452de03865503fae12b0268feb2'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.019.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.019.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '2c6cccda496cb9487c36a8352408bd03'
'b.e21.BHISTsmbb.f09_g17.LE2-1301.020.pop.h.diatChl.198001-198912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/diatChl/b.e21.BHISTsmbb.f09_g17.LE2-1301.020.pop.h.diatChl.198001-198912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '5209e09273bf5fbf75ee8a856574f716'
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
