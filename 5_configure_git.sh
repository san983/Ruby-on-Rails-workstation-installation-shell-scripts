#! /bin/bash
SCRIPT=`basename $0`

ERROR=1
SUCCESS=0

SEPERATOR="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

ENT_ID=""
ACN_EMAIL="@accenture.com"

usage()
{
	echo "$SCRIPT: usage: "
}

config_git()
{
	git config --global user.name \""$1\""
	if [ $? -eq 0 ]
	then
		git config --global user.email \""$1$ACN_EMAIL\""
	else
		return $ERROR
	fi

	return $SUCCESS
}

config_ssh()
{
	ssh-keygen -t rsa -C $ENT_ID$ACN_EMAIL
	if [ $? -ne 0 ]
	then
		RET_CODE=$ERROR
	else
		RET_CODE=$SUCCESS
	fi

	return $RET_CODE
}

if [ `id -u` -eq 0 ]
then
	echo "$SCRIPT: ERROR: Script cannot be run as root or with sudo."	
	exit $ERROR
fi

if ( ! getopts ":hu:" opt; )
then
	usage
	exit $SUCCESS 
fi

while getopts :hu: opt; do
	case $opt in

		h)
		 usage
		 exit $SUCCESS
		 ;;			

		u)
		 ENT_ID="$OPTARG"
		 ;;			

		\?)
		 echo "$SCRIPT: Invalid option: -$OPTARG" >&2
		 usage
		 exit $ERROR
		 ;;

		:)
		 echo "$SCRIPT: Option -$OPTARG requires an enterprise id sans @accenture.com." >&2
		 usage
		 exit $ERROR
		 ;; 
	esac
done

echo "$SCRIPT: Configuring git."
config_git $ENT_ID
if [ $? -eq 0 ]
then
	echo "$SCRIPT: git configured successfully." 
else
	echo "$SCRIPT: ERROR: git was not configured." >&2
	exit $ERROR 
fi

echo "$SCRIPT: creating ssh keys for $ENT_ID$ACN_EMAIL."
config_ssh
if [ $? -eq 0 ]
then
	echo "$SCRIPT: keys generated successfully." 
else
	echo "$SCRIPT: ERROR: keys failed to generate." >&2
	exit $ERROR 
fi

exit $SUCCESS
