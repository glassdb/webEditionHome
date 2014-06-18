Smalltalk
  at: #'BaselineOfGLASS1'
  ifPresent: [ :ignored | 
    Smalltalk
      at: #'MetacelloProjectRegistration'
      ifPresent: [ :cls | 
        (cls registrationForClassNamed: 'BaselineOfGLASS1' ifAbsent: [  ])
          ifNotNil: [ :registration | 
            registration loadedInImage
              ifTrue: [ 
                Transcript
                  cr;
                  show: '-----GLASS already upgraded to 1.0-beta.9.1'.
                ^ nil ] ] ] ].
Transcript
  cr;
  show: '-----Upgrading GLASS to 1.0-beta.9.1'.
Gofer new
  package: 'ConfigurationOfGLASS';
  url: 'http://seaside.gemtalksystems.com/ss/MetacelloRepository';
  load.
GsDeployer
  deploy: [ (ConfigurationOfGLASS project version: '1.0-beta.9.1') load ].
System commitTransaction ifFalse: [ nil error: 'commit conflicts' ].
