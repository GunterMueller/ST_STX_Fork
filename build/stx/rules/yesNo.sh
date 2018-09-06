#!/bin/sh
#
# $Header: /cvs/stx/stx/rules/yesNo.sh,v 1.1 2000-03-02 16:05:10 cg Exp $
#
# shell script helper:
# ask a yes/no question
#
# usage:
#   yesNo.sh "message" [default]
#
# Notice: by purpose, we do not use any advanced kornshell 
# or bash features (we hope not to do so),
# in order for the scripts to execute under any old/crippled system ...
#
# (cg: actually, I'd rather do some things in smalltalk ...)
#
#set -x

message=$1
default=y

if [ "$2"x != ""x ]; then
    default=$2
fi

yesno_answer=""
while [ "${yesno_answer}"x = ""x ]; do
  echo ${message}' ['${default}']? ' | tr -d '\012'
  read yesno_answer
  case "${yesno_answer}" in
    "y" | y* | Y* )
	yesno_answer="y"
	;;

    "n" | n* | N* )
	yesno_answer="n"
	;;

    "" )
	yesno_answer=${default}
	;;

    * )
	yesno_answer=""  ;
	echo "Please answer 'y' or 'n'!" 
	;;
  esac
done
echo ${yesno_answer}

