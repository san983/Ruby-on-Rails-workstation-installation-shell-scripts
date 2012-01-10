#! /bin/bash
SCRIPT=`basename $0`
ERROR=1
SUCCESS=0
SEPERATOR="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

CURL="/usr/bin/curl"
RVMHTTP="https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer"
CURLARGS="-s"

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

echo "$SEPARATOR"

echo "$SCRIPT: Downloading and installing RVM ..."
$CURL $CURLARGS $RVMHTTP > ./install_rvm.sh
RETURN=$?

if [ $RETURN -eq 0 ]
then
	echo "$SCRIPT: RVM downloaded successfully"
else
	echo "$SCRIPT: ERROR: RVM failed to download." $>2
	exit $ERROR
fi

echo "$SEPARATOR"

echo "$SCRIPT: Installing RVM"
bash install_rvm.sh
if [ $? -eq 0 ]
then
	echo "$SCRIPT: RVM installed"
else
	echo "$SCRIPT: ERROR: System failed to install RVM" >&2
	exit $ERROR
fi
rm install_rvm.sh

##Already done by RVM install
#echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc

echo "$SEPARATOR"
echo "$SEPARATOR"

echo "$SCRIPT: ATTETION! Please close this terminal and open a new one in order to proceed"

echo "$SEPARATOR"
echo "$SEPARATOR"

exit $SUCCESS
