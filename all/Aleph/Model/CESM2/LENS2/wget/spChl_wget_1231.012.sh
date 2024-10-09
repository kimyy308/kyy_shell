#!/bin/bash


WGET_VERSION=$(wget --version | grep -oie "wget [0-9][0-9.]*" | head -n 1 | awk '{print $2}')
if [ -z "$WGET_VERSION" ]
then
WGET_VERSION=PARSE_ERROR
fi

WGET_USER_AGENT="wget/$WGET_VERSION/esg/4.3.2-20230405-191025/created/2023-04-09T20:00:14-06:00"


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
# ucar.cgd.cesm2le.ocn.proc.monthly_ave.spChl
# acc57864-9900-4fb7-a0a0-564dcdd927f4
# https://www.earthsystemgrid.org/dataset/ucar.cgd.cesm2le.ocn.proc.monthly_ave.spChl.html
# https://www.earthsystemgrid.org/dataset/id/acc57864-9900-4fb7-a0a0-564dcdd927f4.html
#
# Dataset Version
# 2
# c8d7e215-c5e7-4286-8390-617d81c3cc60
# https://www.earthsystemgrid.org/dataset/ucar.cgd.cesm2le.ocn.proc.monthly_ave.spChl/version/2.html
# https://www.earthsystemgrid.org/dataset/version/id/c8d7e215-c5e7-4286-8390-617d81c3cc60.html
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
'b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.spChl.199001-199912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/spChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.spChl.199001-199912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '7f9af1f59c8965f7acdc4d63a0121b16'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.spChl.200001-200912.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/spChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.spChl.200001-200912.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'c2fb6cff745231c93bd53207b7fe9e54'
'b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.spChl.201001-201412.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/spChl/b.e21.BHISTsmbb.f09_g17.LE2-1231.012.pop.h.spChl.201001-201412.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' 'f28379e6e90ed0de95f4cd51a4104b47'
'b.e21.BSSP370smbb.f09_g17.LE2-1231.012.pop.h.spChl.201501-202412.nc' 'https://tds.ucar.edu/thredds/fileServer/datazone/campaign/cgd/cesm/CESM2-LE/ocn/proc/tseries/month_1/spChl/b.e21.BSSP370smbb.f09_g17.LE2-1231.012.pop.h.spChl.201501-202412.nc?api-token=rGm6qassoHPSNY2Do3g3b5FBW0wVopaw3nbMvpW0' 'md5' '13e559897a8442ed1b894719ddd735bd'
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
