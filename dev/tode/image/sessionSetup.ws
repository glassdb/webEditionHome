(OGCustomSessionDescription new
    name: 'seaside';
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
    serverGitRoot: '/opt/git';
    serverTodeHome: '/opt/git/todeHome/dev/tode/home`;
    yourself) exportTo: TDShell sessionDescriptionHome.
TDShell testLogin: 'seaside'.
