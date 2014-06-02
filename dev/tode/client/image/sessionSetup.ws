| webEditionRoot sessionName |
webEditionRoot := '/opt/git/webEditionHome/'.
sessionName := 'seaside'.
TDShell webEditionRoot: webEditionRoot.
(TDSessionDescription new
    name: sessionName;
    gemstoneVersion: '3.2.0';
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
    serverTodeRoot: webEditionRoot, '/dev/tode`;
    yourself) exportTo: TDShell sessionDescriptionHome.
TDShell testLogin: sessionName.
