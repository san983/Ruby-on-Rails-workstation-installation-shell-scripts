#! /bin/bash
SCRIPT=`basename $0`
ERROR=1
SUCCESS=0
APT_PARMS="-qq"
SEPERATOR="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

BUILD_TOOLS="wget curl build-essential clang bison openssl zlib1g libxslt1.1 libxml2-dev libffi-dev libyaml-dev libxslt-dev libssl-dev autoconf libc6-dev libreadline6 libreadline6-dev zlib1g-dev libcurl4-openssl-dev ncurses-dev automake" 

DB_TOOLS="libsqlite3-0 sqlite3 libsqlite3-dev postgresql postgresql-client libpq-dev"

IMAGE_TOOLS="imagemagick libmagick9-dev"

SOURCEMGMT_TOOLS="git-core"

TESTING_TOOLS="libnotify-bin"

usage()
{
	echo "$SCRIPT: usage: -h || <no args>"  
}

install_tools()
{
	apt-get install $1 $APT_PARMS
	RETURN=$?
	return $RETURN
}

if [ `id -u` -ne 0 ]
then
	echo "$SCRIPT: ERROR: Script needs to be run as root or with sudo."	
	exit $ERROR
fi


while getopts ":h :s:" opt; do
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

echo "Installing tools ..."
for TOOL in $BUILD_TOOLS $DB_TOOLS $IMAGE_TOOLS $SOURCEMGMT_TOOLS $TESTING_TOOLS
do
	echo $SEPERATOR

	echo "$SCRIPT: Installing $TOOL."

	install_tools $TOOL
	if [ $? -eq $SUCCESS ]
	then
		echo "$SCRIPT: $TOOL installed and configured successfully."
	else	
		echo "$SCRIPT: ERROR: $TOOL failed to install." >&2
	fi

	echo $SEPERATOR
done

exit $SUCCESS
