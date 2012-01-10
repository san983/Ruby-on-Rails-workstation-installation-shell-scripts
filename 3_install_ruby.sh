#! /bin/bash
SCRIPT=`basename $0`
ERROR=1
SUCCESS=0
SEPERATOR="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

REBARRUBY="1.9.3"

usage()
{
	echo "$SCRIPT: usage: "
}

if [ `id -u` -eq 0 ]
then
	echo "$SCRIPT: ERROR: Script cannot be run as root or with sudo."	
	exit $ERROR
fi

while getopts ":h:" opt; do
	case $opt in

		h)
		 usage
		 exit $SUCCESS
		 ;;			

		\?)
		 echo "$SCRIPT: Invalid option: -$OPTARG" >&2
		 usage
		 exit $ERROR
		 ;;

		:)
		 echo "$SCRIPT: Option -$OPTARG requires an argument." >&2
		 usage
		 exit $ERROR
		 ;; 
	esac
done

rvm reload

echo "$SCRIPT: Installing Ruby $REBARRUBY"
rvm install ruby-$REBARRUBY
if [ $? -eq 0 ]
then
	echo "$SCRIPT: System configured for Ruby $REBARRUBY"
else
	echo "$SCRIPT: ERROR: System failed to use $REBARRUBY" >&2
	exit $ERROR
fi

echo "$SCRIPT: Setting 1.9.3 as the default."
rvm --default use 1.9.3
if [ $? -eq 0 ]
then
	echo "$SCRIPT: 1.9.3 set as the system default."
else
	echo "$SCRIPT: ERROR: System failed to set the default." >&2
	exit $ERROR
fi

rvm reload

exit $SUCCESS
