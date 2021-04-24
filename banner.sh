#!/bin/sh

header() {
    echo " ╔════════════════════════════════════════════════════════════════════════════════╗ "
}

suffix() {
    echo " ╚════════════════════════════════════════════════════════════════════════════════╝"
}

content() {

    banner_width=78
    text_len=${#1}

    prefix_indent=$(( (banner_width - text_len) / 2 ))
    suffix_indent=$(( banner_width - text_len - prefix_indent ))

    prefix=''
    for i in $(seq 1 $prefix_indent); do
        prefix+=" "
    done

    suffix=''
    for i in $(seq 1 $suffix_indent); do
        suffix+=" "
    done
    

    echo " ║ ${prefix}${1}${suffix} ║"    
}


CWD="$( dirname "$0" )"

header
content ""
echo " ║    ██████╗  █████╗ ██████╗ ██╗   ██╗██████╗  ██████╗        ██╗     ██████╗    ║"
echo " ║    ██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔═══██╗      ███║     ╚════██╗   ║"
echo " ║    ██████╔╝███████║██████╔╝ ╚████╔╝ ██║  ██║██║   ██║      ╚██║      █████╔╝   ║"
echo " ║    ██╔══██╗██╔══██║██╔═══╝   ╚██╔╝  ██║  ██║██║   ██║       ██║     ██╔═══╝    ║"
echo " ║    ██║  ██║██║  ██║██║        ██║   ██████╔╝╚██████╔╝       ██║ ██╗ ███████╗   ║"
echo " ║    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚═════╝  ╚═════╝        ╚═╝ ╚═╝ ╚══════╝   ║"
content ""
content "$(/bin/sh ${CWD}/print_versions.sh)"
content ""
suffix
