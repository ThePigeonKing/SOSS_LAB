#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S')]: $*" >&2
}

check() {
	if [ $1 -ne 0 ]; then
		err ${@:3}
		exit
	else
		if [ "$2" != "" ]; then
			echo $2
		fi
	fi
}

display() {
    if [ $(wc -l <<< "$1") -lt 30 ]; then
        echo "$1"
    else
        less <<< "$1"
    fi
}

listselect() {
	local -n list=$1
	list+=("Info" "Exit")
	select opt in "${list[@]}"; do
	case $opt in
		Exit) return 0;;
		Info) echo "$2";;
		*)
			if [[ -z $opt ]]; then
				echo "[!ERR] Select number from list" >&2
			else
				return $REPLY
			fi
			;;
	esac
	done
}

index() {
	local -n list=$1
	for i in "${!list[@]}"; do
		if [[ "${list[$i]}" = "$2" ]]; then
			return "$((i+1))"
		fi
	done
	return 0
}

partselect() {
	read -p "$2" name
	index $1 "$name"
	res=$?
	if [ $res == 0 ]; then
		local -n list=$1
		readarray -t filtered < <(printf -- '%s\n' "${list[@]}" | grep "$name")
		listselect filtered "$3"
		res=$?
		if [ $res == 0 ]; then
			return 0
		else
			index $1 "${filtered[res - 1]}"
			return $?
		fi
	else
		return $res
	fi
}

if [ "$EUID" -ne 0 ]; then
	echo "[!ERR] Must be run as root"
	exit
fi

if [ "$1" = "--help" ]; then
	echo 'Лабораторная работа "Регистрация системных событий"

Данный скрипт позволяет интерактивно регистрировать и анализировать события с помощью системы Linux Auditing System.
Запустите скрипт без аргументов чтобы увидеть список возможностей.
Меню
'
	exit
fi



PS3=$'\n> '
options=(
	"Search audit actions"
	"Audit reports"
	"Configure audit subsystem"
	"Info"
	"Exit"
)

select opt in "${options[@]}"
do
	case $opt in
	"Search audit actions")
		read -p "Event type (empty = ALL): " eventtype
		if [ "$eventtype" == "" ]; then
			eventtype=ALL
		fi
		read -p "Selet user uid (might be empty): " userid
		read -p "Select search string: " searchstring
		if [ "$search" == "" ]; then
			search="="
		fi
		if [ "$userid" == "" ]; then
			ausearch -m $eventtype | grep $search -B 2
		else
			ausearch -m "$eventtype" -ui "$userid" | grep "$search" -B 2
		fi
		;;

	"Audit reports")
		report=""
		echo "Select required info: "
		select opt in "Users login report" "Failures report" "Info" "Back"; do
		case $opt in
            "Users login report")
				report="-au"
                break
                ;;
            "Failures report")
				report="--failed --user"
                break
                ;;
            "Info")
                echo "Select required report"
                ;;
            "Back")
                break
                ;;
	        *) echo "Wrong command $REPLY";;
		esac
		done
		[ "$report" == "" ] && continue
		period=""
		echo "Select period: "
		select opt in "today" "week" "month" "year" "Info" "Back"; do
		case $opt in
            "today")
				period="today"
                break
                ;;
            "week")
				period="this-week"
                break
                ;;
            "month")
				period="this-month"
                break
                ;;
            "year")
				period="this-year"
                break
                ;;
            "Info")
                echo "Select required report time period"
                ;;
            "Back")
                break
                ;;
	        *) echo "Wrong command $REPLY";;
		esac
		done
		[ "$period" == "" ] && continue

		aureport $report -ts "$period" > report
		check $? "Report saved to file 'report'" "Error saving report"
        ;;

	"Configure audit subsystem")
		select opt in "Add folder/file for monitoring" "Delete for monitoring" "Monitoring report" "Info" "Exit"; do
		case $opt in
            "Add folder/file for monitoring")
				read -e -p "Select path to file/dir: " path
				if [ "$path" == "" ]; then
					err "Path can't be empty"
					continue
				fi
				if [ -d "$path" ]; then
					auditctl -a exit,always -F "dir=$path" -F perm=warx
				elif [ -f "$path" ]; then
					auditctl -w "$path" -p warx
				else
					err "This file doesn't exist"
					continue
				fi
                ;;
            "Delete from monitoring")
				rules=$(auditctl -l)
				if [[ "$rules" == "No rules"* ]]; then
					echo "[!ERR] No rules"
					continue
				fi
				readarray -t paths < <(auditctl -l | cut -d " " -f2)
				listselect paths "Select rule"
				res=$?
				[ $res == 0 ] && continue
				rule="${paths[res - 1]}"
				auditctl -W $rule
                ;;
            "Monitoring report")
				rules=$(auditctl -l)
				if [[ "$rules" == "No rules"* ]]; then
					echo "No rules"
					continue
				fi
				readarray -t paths < <(cut -d " " -f2 <<< "$rules")
				listselect paths "Select required path"
				res=$?
				[ $res == 0 ] && continue
				path=${paths[res - 1]}
				res=$(aureport --file | grep $path)
				[ "$res" == "" ] && res="No event"
				echo "${res}"
                ;;
            "Info")
                echo "Select command"
                ;;
            "Back")
                break
                ;;
	        *) echo "Wrong command $REPLY";;
		esac
		done
        ;;
	"Info")
		echo "Select command"
		;;
	"Exit")
		break
		;;
    "q")
        break ;;
	*) echo "Wrong command";;
	esac
done

echo "Shutting down..."