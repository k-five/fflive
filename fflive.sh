#!/bin/bash
###
# Author : Shakiba Moshiri
###

################################################################################
# an associative array for storing color and a function for colorizing
################################################################################
declare -A _colors_;
_colors_[ 'red' ]='\x1b[1;31m';
_colors_[ 'green' ]='\x1b[1;32m';
_colors_[ 'yellow' ]='\x1b[1;33m';
_colors_[ 'cyan' ]='\x1b[1;36m';
_colors_[ 'reset' ]='\x1b[0m';

function colorize(){
    if [[ ${_colors_[ $1 ]} ]]; then
        echo -e "${_colors_[ $1 ]}$2${_colors_[ 'reset' ]}";
    else
        echo 'wrong color name!';
    fi
}

################################################################################
# __help function
################################################################################
function __help(){
    echo -e  " $0 help ...\n
definition:
wrapper around ffmpeg for going live

 -R | --run             Run
    |                   $(colorize 'cyan' 'server'): running ffserver

 =C | --capture         Capture mic, speaker, mix
    |                   $(colorize "cyan" "mic")
    |                   $(colorize "cyan" "speaker")
    |                   $(colorize "cyan" "mix")

 -S | --stream          Stream mic, speaker, mix
    |                   $(colorize "cyan" "mic")
    |                   $(colorize "cyan" "speaker")
    |                   $(colorize "cyan" "mix")

 -h | --help            print this help

Copyright (C) 20XX Shakiba Moshiri
https://github.com/k-five/fflive "
    exit 0;
}

################################################################################
# print the result of each action
################################################################################
function print_result(){
    echo -e "\noption: $2" >&2;
    echo "action:" $(colorize 'cyan'  $3) >&2;
    if [[ $1 == 0 ]]; then
        echo "status:" $(colorize 'green' 'OK') >&2;
    else
        echo "status:" $(colorize 'red' 'ERROR') >&2;
    fi
}

################################################################################
# check for required commands
# curl, curlftpfs
# grep, sed
# nmap, perl
################################################################################
declare -A _cmds_;
_cmds_['curl']=$(which curl);
_cmds_['curlftpfs']=$(which curlftpfs);
_cmds_['perl']=$(which perl);
_cmds_['nmap']=$(which nmap);

for cmd in ${_cmds_[@]}; do
    if ! [[ -x $cmd ]]; then
        echo "ERROR ...";
        echo "the $cmd is required";
        echo "please install it";
        exit 1;
    fi
done

################################################################################
# if there is no flags, prints help
################################################################################
if [[ $1 == "" ]]; then
    __help;
fi


################################################################################
# main flags, both longs and shorts
################################################################################
ARGS=`getopt -o "hc:F:S:H:D:E:m:l:r:d:" -l "" -- "$@"`
eval set -- "$ARGS"

################################################################################
# global variable 
################################################################################
declare -A email;
email['flag']=0;
email['conf']='';
email['body']='';
email['user']='';
email['pass']='';
email['smtp']='';
email['port']='';
email['rcpt']='';


################################################################################
# extract options and their arguments into variables.
################################################################################
while true ; do
    case "$1" in
        -h | --help )
            __help;
        ;;
        # last line
         --)
            shift;
            break;
         ;;

         *) echo "Internal error!" ; exit 1 ;;
    esac
done


