#!/bin/bash

USER='sdsmith@iastate.edu'


usage(){
cat << EOF

USAGE: sh $0 -d -v [operation] [local_folder] [Box_folder]

REQUIRED:
  [operation]
  	push	-syncs filed from your local drive to Box
	pull	-syncs files from Box to your local drive

OPTIONS:
   -d      Delete all files in target directory that are not in the source
   -v      Verbose
	
[local_folder]	default is present working directory	
[Box_fodler]	default is the name of the directory of local_folder
		to change this both [local_folder] and [Box_folder] must be specified.

EOF
}

while getopts ":hdv" OPTION; do
     case $OPTION in
         h)
            usage
            exit 1
            ;;
         # m)
         #    METHOD=$OPTARG
         #    ;;
         d)
            DELETE=TRUE
            ;;
         v)
            VERBOSE=1
            ;;
         :)
			echo "Option -$OPTARG requires an argument." >&2
      		exit 1
			;;
         ?) echo "Invalid option: -$OPTARG\\nUse \"sh $0 -h\" to see usage and list of legal arguments." >&2
            exit 1
            ;;
     esac
done
shift $((OPTIND -1))


METHOD=$1
if [ -z "$METHOD" ]
then
     cat << EOF

Missing operation argument.

Use "sh $0 -h" to see usage and arguments.
EOF
     exit 1
fi

if [ -n "$2" ]
then
	LOCAL=$2
else
	LOCAL=$PWD
fi
if [ -n "$3" ]
then
	BOX=$3
else
	BOX=`basename $LOCAL`
fi
if [ -z ${PASSWORD+x} ]
then
	read -s -p "Box password: " password
fi

if [ "$METHOD" = 'push' ]; then
	if [ "$DELETE" = TRUE ]; then
		# Get confirmation 
			echo "This will DELETE any files not seen in the source."
			read -p "Are you sure? (y/n) " ans
			# Lowercase $ans and compare it 
			if [ "${ans}" = "y" ]
			then
lftp -u "$USER","$PASSWORD" ftps://ftp.box.com:990<<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ssl:verify-certificate no
mirror --reverse --delete --no-perms --verbose $LOCAL $BOX;
exit
EOF
			else
				exit 1
			fi
	else
lftp -u "$USER","$PASSWORD" ftps://ftp.box.com:990<<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ssl:verify-certificate no
mirror --reverse --no-perms --verbose $LOCAL $BOX;
exit
EOF
	fi 
elif [ "$METHOD" = 'pull' ]; then
	if [ "$DELETE" = TRUE ]; then
		# Get confirmation 
			echo "This will DELETE any files not seen in the source."
			read -p "Are you sure? (y/n) " ans
			if [ "${ans}" = "y" ]
			then
lftp -u "$USER","$PASSWORD" ftps://ftp.box.com:990<<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ssl:verify-certificate no
mirror --delete --no-perms --verbose $LOCAL $BOX;
exit
EOF
			else
				exit 1
			fi
	else
lftp -u "$USER","$PASSWORD" ftps://ftp.box.com:990<<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ssl:verify-certificate no
mirror --no-perms --verbose $LOCAL $BOX;
exit
EOF
	fi 
else 
	cat << EOF

Invalid operation argument. Should be:
	push	-syncs filed from your local drive to Box
	pull	-syncs files from Box to your local drive

Use "sh $0 -h" to see usage and arguments.
EOF
fi