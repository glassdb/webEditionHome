#!/bin/bash
#=========================================================================
# Copyright (c) 2014 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#=========================================================================
#
# ./startGemStoneBackup runs a GemStone full backup (compressed) and validates 
#  the resulting backup file
#
# non-zero exit status if an error occurs during processing 
#
# logs output to $GEMSTONE_LOGDIR
#

source $WE_HOME/defWebEdition

if [ -s $GEMSTONE/seaside/etc/gemstone.secret ]; then
    . $GEMSTONE/seaside/etc/gemstone.secret
else
    echo 'Missing password file $GEMSTONE/seaside/etc/gemstone.secret'
    exit 1
fi

date=`date +%Y%m%d_%H%M%S`
backupfile=${GEMSTONE_DATADIR}/${GEMSTONE_NAME}_backup_${date}.dbf

echo "Starting backup: " `date` >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log

cat << EOF | $GEMSTONE/bin/topaz -l -T50000 >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log 2>&1 

set user DataCurator pass $GEMSTONE_CURATOR_PASS gems $GEMSTONE_NAME

display oops
iferr 1 where
iferr 2 stack
iferr 3 exit 1

login

run
(ObjectLogEntry trace: 'BACKUP: begin ' object: '${backupfile}') addToLog.
%   
commit 

run
| id  |
id := SystemRepository startNewLog.
[ id < 0 ] whileTrue: [
  System sleep: 1.
  id := SystemRepository startNewLog ].
SystemRepository fullBackupCompressedTo: '${backupfile}'
%

begin 

run
(ObjectLogEntry trace: 'BACKUP: completed ' object: '${backupfile}') addToLog.
%
commit

logout
quit

EOF

if [ $? -eq 0 ]
then
  echo "Successful backup ... starting validation of backup: " `date` >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
  echo "------------------------------------------------------------" >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
  $GEMSTONE/bin/copydbf ${backupfile} /dev/null >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log 2>&1
  if [ $? -eq 0 ]
    then
      echo "Successful validation: " `date` >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
      echo "------------------------------------------------------------" >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
      echo "------------------------------------------------------------" >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
      exit 0
    else
      reason="Failed validatino"
      echo "Failed validation: " `date` >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
  fi
else
  reason="Failed backup"
  echo "Failed backup: " `date` >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
fi

cat << EOF | $GEMSTONE/bin/topaz -l -T50000 >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log 2>&1 
set user DataCurator pass $GEMSTONE_CURATOR_PASS gems $GEMSTONE_NAME

login     
run
'For details about the failure, scan backward in log file to previous topaz session or copydbf sessions'
%
         
run       
(ObjectLogEntry fatal: 'BACKUP: failed ' object: '${reason}. See $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log for details') addToLog.
%       
commit 
logout
quit

EOF

echo "------------------------------------------------------------" >> $GEMSTONE_LOGDIR/${GEMSTONE_NAME}_backup.log
exit 101 #failure

