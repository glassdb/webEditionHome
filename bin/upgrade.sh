#! /bin/bash

usage() {
  cat <<EOF
usage: $0 -a <application-topaz-file> -b <bootstrap-topaz-file> [-C][-e <source-extent-path>]
Parameters:
    -a <application-topaz-file>
        REQUIRED. 
        Path to application load topaz input file. 
        See topaz/upgradeGLASSApplication.tpz for an example.
    -b <bootstrap-topaz-file>
        REQUIRED. 
        Path to Bootstrap setup topaz input file. 
        See topaz/upgradeGLASSBootstrap.tpz for an example.
    -e <source-extent-path>
        If present, the extent at source-extent-path is copied to 
        $GEMSTONE_DATADIR
    -C
        If present, the -C flag is passed to the startstone command 
        indicating an upgrade from GemStone 2.x
EOF
}


COPYDBF_DOC="  - the extent to be upgraded has been copied to $GEMSTONE_DATADIR by you."
STARTSTONE_OPTION=""

while getopts "Ca:b:e:" opt; do
  case $opt in
    a ) APPLICATION_TPZ=$OPTARG ;;
    b ) BOOTSTRAP_TPZ=$OPTARG ;;
    e ) 
        EXTENT_NAME=$OPTARG
        COPYDBF_DOC="  - copies $EXTENT_NAME to $GEMSTONE_DATADIR."
      ;;
    C ) STARTSTONE_OPTION="-C";;
   \? ) usage; exit 1 ;;
  esac
done

if [ "a$APPLICATION_TPZ" = "a" ]; then
  echo "Missing application load file (-a)"
  usage
  exit 1
fi

if [ "a$BOOTSTRAP_TPZ" = "a" ]; then
  echo "Missing upgrade bootstrap setup file (-b)"
  usage
  exit 1
fi

cat <<EOF

This script performs a standard upgrade for the stone $GEMSTONE_NAME.
This script:

$COPYDBF_DOC
  - removes any old tranlog files in the the $GEMSTONE_DATADIR directory.
  - starts the stone $GEMSTONE_NAME.
  - runs the upgradeImage script.
  - sets up the Bootstrap globals for the upgradeSeasideImage script.
  - runs the upgradeSeasideImage script.
  - runs an application upgrade script, that you should have customized
    BEFORE running this script

If an error occurs during execution of this script, the details of the error are
available in the topazerrors.log file.

Press the return key to continue...
EOF
read prompt

if [ "${EXTENT_NAME}x" = "x" ] ; then
  echo "no extent file supplied, upgrading extent in $GEMSTONE_DATADIR"
else
  echo "copying extent $1 to $GEMSTONE_DATADIR"
  cp $EXTENT_NAME $GEMSTONE_DATADIR/extent0.dbf
  rm -f $GEMSTONE_DATADIR/tranlog*.dbf
fi

echo "STARTING upgrade stone $GEMSTONE_NAME"
$GEMSTONE/bin/startstone $STARTSTONE_OPTION $GEMSTONE_NAME
if [ "$?" != "0" ]; then
  echo "ERROR: starting upgrade stone"
  exit 1
fi

# start standard upgrade
echo "STARTING standard upgradeImage "
$GEMSTONE/bin/upgradeImage -s $GEMSTONE_NAME << EOF

EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running upgradeImage. See topazerrors.log for more information"
  exit 1
fi

# setup Bootstrap globals
echo "STARTING setup Bootstrap globals"
$GEMSTONE/bin/topaz -l -T50000 > $upgradeLogDir/topaz.out << EOF
output pushnew $upgradeLogDir/topazBootstrap.out only
set gemstone $GEMSTONE_NAME

display resultcheck
level 0

set user DataCurator pass swordfish
login

display oops
iferr 1 stk
iferr 2 stack
iferr 3 input pop
iferr 4 exit 1

input $BOOTSTRAP_TPZ

commit
logout
output pop
exit 0
EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running topaz to set up Bootstrap globals"
  exit 1
fi

# start "seaside" upgrade to upgrade GLASS to 1.0-beta.9.1
echo "STARTING upgradeSeasideImage"
$GEMSTONE/seaside/bin/upgradeSeasideImage -s $GEMSTONE_NAME << EOF

EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running upgradeImage. See topazerrors.log for more information"
  exit 1
fi

#install application code
echo "STARTING install application code"
$GEMSTONE/bin/topaz -l -T50000 > $upgradeLogDir/topaz.out << EOF
output pushnew $upgradeLogDir/topazApplication.out only
set gemstone $GEMSTONE_NAME

display resultcheck
level 0

set user DataCurator pass swordfish
login

display oops
iferr 1 stk
iferr 2 stack
iferr 3 input pop
iferr 4 exit 1

input $APPLICATION_TPZ

commit
logout
output pop
exit 0
EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running topaz to install application code. See topazerrors.log for more information"
  exit 1
fi

exit 0

