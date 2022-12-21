#!/usr/bin/env bash

version="v0.0.9"
path="./"
backup=false
restore=false

#================= functions information =================#
function usage(){
    echo "
	usage:

		flatckup [OPTION] [FILE-NAME]

            flatckup -b 'backup-name-file'
            flatckup -b 'backup-name-file' -p 'path'

            flatckup -r 'backup.txt'

    -b|--backup)        Create a backup file.
    -p|--path)          Path to save backup.

    -r|--restore)       Restore programs with backup file.
    
    --version)          Show version.

    "
    exit 0
}
function version(){
    echo -e "
    #==================#
    #     flatckup     #
    #==================#

    Version: $version
    Author: Bruno Dupim
    Project: https://github.com/brunodupim08/flatckup.git
    "
    exit 0
}
#================= functions alerts =================#
function alert_sound(){
    echo -e "\a"
}
function concluded_alert(){
    echo "
    Concluded !!!
    "
    alert_sound
}
#================= functions errors messages =================#
function error_1(){
    echo "
	Parameter error !!!
	usage:

		flatckup [OPTION] [FILE-NAME]
		
	Try "flatckup -h or --help" for more options.
	"
    alert_sound
	exit 1
}
function error_2(){
    echo -e "Error 2 !!!

        Unable to create file

    Make sure you have permissions for this directory.
    Try "flatckup -h or --help" for more options.
    "
    alert_sound
    exit 2
}
function error_3(){
    echo -e "Error 3 !!!

        File not found

    Make sure you have permissions for this directory and file.
    Try "flatckup -h or --help" for more options.
    "
    alert_sound
    exit 3
}
#================= functions process =================#
function backup(){
    if [[ -z "${file}" ]]; then
        file="flatckup-backup-list $(date)"
    fi
    list=$(flatpak list --app --columns=application | tail -n +1) 
    (
        echo -e "${list}" > "${file}".txt
    )
}
function restore(){
    if [[ ! -d "${file_input}" && -e "${file_input}" ]]; then
        while IFS= read -r line_input; do
            (
                flatpak install ${line_input} -y
            )
        done < "$file_input"
    else
        error_3
    fi
}
#Option.
[[ "${#}" -eq "0" || "${#}" -gt "3" ]] && error_1
while [[ "${#}" -ne "0" ]]; do
    case "${1}" in
        --version)
            version
        ;;
        -h|--help)
            usage
        ;;
        -p|--path)
            path="${2}"
            if [[ ! -d "${file}" && ! -e "${file}" ]]; then
                mkdir -p -m 750 "${file}" 2> /dev/null || error_2
            fi
            p=true
            shift
        ;;
        -b|--backup)
            file="${2}"
            backup=true
            shift
        ;;
        -r|--restore)
            file_input="${2}"
            restore=true
            shift
        ;;
        *)
            error_1
        ;;
    esac
    shift
done
if [[ "$backup" = true && "$restore" = true ]];then
    error_1
elif [[ "$restore" = true && "$p" = true ]];then
    error_1
elif [[ "$backup" = true ]];then
    backup
elif [[ "$restore" = true ]];then
    restore
fi
concluded_alert