#! /bin/bash
SCRIPT=`basename $0`
ERROR=1
SUCCESS=0
SEPERATOR="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

usage()
{
	echo "$SCRIPT: usage: $SCRIPT "
}

if [ `id -u` -eq 0 ]
then
	echo "$SCRIPT: ERROR: Script cannot be run as root or with sudo."	
	exit $ERROR
fi

while getopts ":h" opt; do
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

echo "$SCRIPT: Updating RVM..."
rvm get latest
if [ $? -eq 0 ]
then
	echo "$SCRIPT: RVM updated."
else
	echo "$SCRIPT: ERROR: RVM could not be updated." >&2
	exit $ERROR 
fi

echo "$SEPERATOR"

echo "$SCRIPT: Updating Gems..."
gem update --system
if [ $? -eq 0 ]
then
	echo "$SCRIPT: Gems updated."
else
	echo "$SCRIPT: ERROR: Gems could not be updated." >&2
	exit $ERROR 
fi
gem -v

echo "$SEPERATOR"

echo "$SCRIPT: Updating Rake..."
gem update rake
if [ $? -eq 0 ]
then
	echo "$SCRIPT: Rake updated."
else
	echo "$SCRIPT: ERROR: Rake could not be updated." >&2
	exit $ERROR 
fi
rake --version

echo "$SEPERATOR"

#echo "$SCRIPT: Installing bundler."
#gem install bundler
#if [ $? -eq 0 ]
#then
#	echo "$SCRIPT: Bundler installed."
#else
#	echo "$SCRIPT: ERROR: Bundler could not be installed." >&2
#	exit $ERROR 
#fi

echo "$SEPERATOR"

echo "$SCRIPT: Installing rails."
gem install rails
if [ $? -eq 0 ]
then
	echo "$SCRIPT: rails installed."
else
	echo "$SCRIPT: ERROR: Bundler could not be installed." >&2
	exit $ERROR 
fi

echo "$SEPERATOR"

rvm reload

exit $SUCCESS
