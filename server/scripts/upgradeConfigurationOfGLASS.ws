Transcript
  cr;
  show: '-----Upgrading GLASS to 1.0-beta.9.1'.
ConfigurationOfGLASS project updateProject.
GsDeployer
  deploy: [ (ConfigurationOfGLASS project version: '1.0-beta.9.1') load ].
System commitTransaction ifFalse: [ nil error: 'commit conflicts' ].
