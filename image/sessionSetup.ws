TDShell todeHome: '/opt/git/todeHome/'.

(OGCustomSessionDescription new
    name: 'glass';
    gemstoneVersion: '3.2.0';
    adornmentColor: Color lightGreen;
    stoneHost: 'localhost';
    stoneName: 'seaside';
    gemHost: 'localhost';
    netLDI: '50377';
    gemTask: 'gemnetobject';
    userId: 'DataCurator';
    password: 'swordfish';
    osUserId: '';
    osPassword: '';
    backupDirectory: '';
    dataDirectory: '';
    yourself) exportTo: TDShell sessionDescriptionHome.
TDShell testLogin: 'glass'.
