Transcript
  cr;
  show: '-----Upgrading tODE to latest master version'.
GsDeployer bulkMigrate: [ 
  Metacello new
    baseline: 'Tode';
    repository: 'github://dalehenrich/tode:master/repository';
    get.
  Metacello new
    baseline: 'Tode';
    repository: 'github://dalehenrich/tode:master/repository';
    onConflict: [ :ex | ex allow ];
    onWarning: [:ex | 
      Transcript cr; show: ex description.
      ex resume ];
    load: 'GemStone Dev' ].
System commitTransaction ifFalse: [ nil error: 'commit conflicts' ].
