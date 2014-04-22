#! /bin/bash

#=========================================================================
# Copyright (c) 2013-2014 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#=========================================================================

startstone $GEMSTONE_NAME

# start standard upgrade
upgradeImage -s $GEMSTONE_NAME
if [ "$?" != "0" ]; then
  echo "ERROR: running upgradeImage. See topazerrors.log for more information"
  exit 1
fi

# setup Bootstrap globals
topaz -l -T50000 << EOF
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
 UserGlobals
  at: #BootstrapApplicationPostloadClassList
  put: #( #MBConfigurationRoot).
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


# start "seaside" upgrade to upgrade GLASS to 1.0-beta.9.1
upgradeSeasideImage -s $GEMSTONE_NAME
if [ "$?" != "0" ]; then
  echo "ERROR: running upgradeImage. See topazerrors.log for more information"
  exit 1
fi

#install application code
topaz -l -T50000 << EOF
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
GsDeployer
  deploy: [
    [
    Metacello new
      configuration: 'Seaside3';
      version: '3.0.9.1';
      repository: 'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main';
      get.
    [
    Metacello new
      configuration: 'Seaside3';
      version: '3.0.9.1';
      repository: 'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main';
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
%
commit
logout
output pop
exit 0
EOF
if [ "$?" != "0" ]; then
  echo "ERROR: running topaz to install application code"
  exit 1
fi

