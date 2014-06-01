Transcript
  cr;
  show: '-----Upgrading Metacello to issue_238 branch ... tODE needs the bugfixes in that branch'.
[ 
Metacello new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:issue_238/repository';
  get.
Metacello new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:issue_238/repository';
  load: 'ALL' ]
  on: Warning
  do: [ :ex | 
    Transcript
      cr;
      show: ex description.
    ex resume ].
System commitTransaction ifFalse: [ nil error: 'commit conflicts' ].
