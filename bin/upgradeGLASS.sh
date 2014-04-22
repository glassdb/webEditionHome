#! /bin/bash

#=========================================================================
# Copyright (c) 2014 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#=========================================================================

usage() {
  cat <<EOF
Usage:
upgradeGLASS.sh [-e <source-extent-path>][-C]
Parameters:
    -e <source-extent-path>
        If present, the extent at source-extent-path is copied to $GEMSTONE_DATADIR
    -C
        If present, the -C flag is passed to the startstone command indicating an upgrade
        from GemStone 2.x
EOF
}


COPYDBF_DOC="  - the extent to be upgraded has been copied to $GEMSTONE_DATADIR by you."
STARTSTONE_OPTION=""

while getopts "e:C" opt; do
  case $opt in
    e ) 
        EXTENT_NAME=$OPTARG
        COPYDBF_DOC="  - copies $EXTENT_NAME to $GEMSTONE_DATADIR."
      ;;
    C ) STARTSTONE_OPTION="-C";;
   \? ) usage; exit 1 ;;
  esac
done


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

$GEMSTONE/bin/startstone $STARTSTONE_OPTION $GEMSTONE_NAME
if [ "$?" != "0" ]; then
  echo "ERROR: starting upgrade stone"
  exit 1
fi
echo "stone $GEMSTONE_NAME started..."

# start standard upgrade
$GEMSTONE/bin/upgradeImage -s $GEMSTONE_NAME << EOF

EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running upgradeImage. See topazerrors.log for more information"
  exit 1
fi
echo "Upgrade image complete..."

# setup Bootstrap globals
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

run
 UserGlobals
  at: #BootstrapRepositoryDirectory
  put: GsPackageLibrary getMonticelloRepositoryDirectory.
true
%
run
 UserGlobals
  at: #BootstrapApplicationLoadSpecs
  ifAbsent: [
    UserGlobals
      at: #BootstrapApplicationLoadSpecs
      put: {
        { 'ConfigurationOfGLASS' . '1.0-beta.9.1' . #('default') .
              BootstrapRepositoryDirectory } .
           }.
  ].
 true
%
commit
logout
output pop
exit 0
EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running topaz to set up Bootstrap globals"
  exit 1
fi
echo "Bootstrap globals complete..."

# start "seaside" upgrade to upgrade GLASS to 1.0-beta.9.1
$GEMSTONE/seaside/bin/upgradeSeasideImage -s $GEMSTONE_NAME << EOF

EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running upgradeImage. See topazerrors.log for more information"
  exit 1
fi
echo "upgrade seaside image complete..."

#install application code
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

run
| project version repository |
project := 'Seaside3'.
version := '3.0.10'.
repository := 'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main'.

GsDeployer
  deploy: [
    [
    Metacello new
      configuration: project;
      version: version;
      repository: repository;
      get.
    [
    Metacello new
      configuration: project;
      version: version;
      repository: repository;
      onConflict: [ :ex | ex allow ];
      load: 'ALL' 
         ] on: MCPerformPostloadNotification do: [:ex |
           (#() includes: ex postloadClass theNonMetaClass name)
             ifTrue: [ 
               "perform initialization"
               ex resume: true ]
             ifFalse: [
               GsFile gciLogServer: '  Skip ', ex postloadClass name asString, ' initialization.'.
                ex resume: false ] ] 
     ]  on: Warning do: [:ex |
           Transcript
              cr;
              show: ex description.
            ex resume ].
  ].
true
%
commit
logout
output pop
exit 0
EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running topaz to install application code. See topazerrors.log for more information"
  exit 1
fi
echo "upgrade application complete"

exit 0

