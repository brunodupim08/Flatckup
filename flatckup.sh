#!/usr/bin/env bash

version="v1.1"
backup=false
restore=false

#================= functions information =================#
function usage(){
    echo "
	usage:

		flatckup [OPTION] [FILE-NAME]

            flatckup -b
            flatckup -b 'path-name-file'
            flatckup -b 'name-file'

            flatckup -r 'backup.txt'

    -b|--backup)        Create a backup file.

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
function error_4(){
    echo -e "Error 4 !!!

        ${path} is a directory, not a file.

    Try "flatckup -h or --help" for more options.
    "
    alert_sound
    exit 3
}
#================= functions process =================#
function backup(){
    list=$(flatpak list --app --columns=application | tail -n +1)
    file="flatckup_backup_list-$(date +"%Y-%m-%d_%H:%M:%S")"

    if [[ -z "${path}" ]]; then
        touch "${file}".txt 2> /dev/null || error_2
        echo -e "${list}" > "${file}".txt
    elif [[ -d "${path}" && "${path:-1}" = "/" ]]; then
        error_4
    elif [[ -d "${path}" && ! "${path:-1}" = "/" ]]; then
        touch "${path}""${file}".txt 2> /dev/null || error_2
        echo -e "${list}" > "${path}""${file}".txt
    elif [[ ! -d "${path}" && "${path:-1}" = "/" ]]; then
        touch "${path}""${file}".txt 2> /dev/null || error_2
        echo -e "${list}" > "${path}""${file}".txt
    elif [[ ! -d "${path}" && ! "${path:-1}" = "/" ]]; then
        touch "${path}" 2> /dev/null || error_2
        echo -e "${list}" > "${path}"
    fi
}
function restore() {
    if [[ ! -d "${file_input}" && -e "${file_input}" ]]; then
        all_lines=$(paste -s -d ' ' "${file_input}")
        flatpak install ${all_lines} -y
    else
        error_3
    fi
}

#Option.
[[ "${#}" -eq "0" || "${#}" -gt "2" ]] && error_1
while [[ "${#}" -ne "0" ]]; do
    case "${1}" in
        --version)
            version
        ;;
        -h|--help)
            usage
        ;;
        -b|--backup)
            path="${2}"
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
elif [[ "$backup" = true ]];then
    backup
elif [[ "$restore" = true ]];then
    restore
fi
concluded_alert
