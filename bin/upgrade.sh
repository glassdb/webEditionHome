#! /bin/bash
#
# Script driver for Web Edition upgrades. Before using script
# READ THE Install Guide for your platform.
#
# Before running this script the following environment variables
# must be set:
#
#  GEMSTONE         - directory where GemStone resides
#  GEMSTONE_DATADIR - directory where the extent and tranlogs reside
#  GEMSTONE_NAME    - name of the stone
#  upgradeLogDir    - directory where upgrade log files will be written
#
# The script performs the following operations:
#
#  1. If -e option is present, the given extent is copied into 
#     the GemStone 3.2 data directory ($GEMSTONE_DATADIR) and
#     tranlogs present in the data directory are removed.
#  2. A stone named $GEMSTONE_NAME is started. If the -C option
#     is present, the stone is started with the -C option.
#     The -C option is required if you are upgrading from 2.x.
#  3. Run the standard upgradeImage script. If an error
#     occurs details about the error or errors can found in 
#     topazerrors.log file.
#  4. Define bootstrap globals by executing the bootstrap globals 
#     topaz input file specified in the -b option. 
#  5. Run the standard upgradeSeasideImage script to upgrade
#     ConfigurationOfGLASS to the correct version. If an error
#     occurs details about the error or errors can found in 
#     topazerrors.log file.
#  6. Upgrade your application code by executing the application load
#     topaz input file specified in the -a option.
#
# For more information about using this script, see the "Upgrade to
# GemStone 3.2 article at:
#
#  https://github.com/glassdb/webEditionHome/blob/master/docs/upgrade/upgradeToGemStone3.2.md

if [ "a$GEMSTONE" = "a" ]; then
  echo "ERROR: This script requires a GEMSTONE environment variable."
  echo "       Please set it to the directory where GemStone resides."
  exit 1
fi
if [ "a$GEMSTONE_DATADIR" = "a" ]; then
  echo "ERROR: This script requires a GEMSTONE_DATADIR environment variable."
  echo "       Please set it to the directory where the extent and tranlogs reside."
  exit 1
fi
if [ "a$GEMSTONE_NAME" = "a" ]; then
  echo "ERROR: This script requires a GEMSTONE_NAME environment variable."
  echo "       Please set it to the name of the stone."
  exit 1
fi
if [ "a$upgradeLogDir" = "a" ]; then
  echo "ERROR: This script requires a upgradeLogDir environment variable."
  echo "       Please set it to the directory where upgrade log files will"
  echo "       be written."
  exit 1
fi

$upgradeLogDir

usage() {
  cat <<EOF
usage: $0 -a <application-load> -b <bootstrap-globals> [-C][-e <source-extent-path>]
Parameters:
    -a <application-load>
        REQUIRED. 
        Path to application load topaz input file. 
        See upgrade/loadSeaside3.0.10.tpz for an example.
    -b <bootstrap-global>
        REQUIRED. 
        Path to bootstrap global topaz input file. 
        See upgrade/bootstrapConfigurationOf.tpz for an example.
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
        COPYDBF_DOC="  - copies $EXTENT_NAME to $GEMSTONE_DATADIR and remove old tranlog files."
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

$GEMSTONE/bin/waitstone $GEMSTONE_NAME -1
if [ "$?" = "0" ]; then
  echo "The stone $GEMSTONE_NAME is currently running. It should be"
  echo "shutdown before running this script"
  exit 1
fi
  
  cat <<EOF

This script performs a standard upgrade for the stone $GEMSTONE_NAME.
This script:

$COPYDBF_DOC
  - starts the stone $GEMSTONE_NAME.
  - runs the upgradeImage script.
  - sets up the Bootstrap globals for the upgradeSeasideImage script.
  - runs the upgradeSeasideImage script.
  - runs an application upgrade script that loads your application code

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

$GEMSTONE/bin/waitstone $GEMSTONE_NAME 5
if [ "$?" != "0" ]; then
  echo "The stone $GEMSTONE_NAME has not started after waiting 5 minutes."
  echo "Please look at the stone log file to see what is going on."
  echo "It may be necessary to increase the timout."
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
