
#Install Seaside3.0.14

To install Seaiside3.0.14 and Zinc:

```Smalltalk
 GsDeployer bulkMigrate: [
    Metacello new
      configuration: 'Seaside3';
      version: '3.0.14';
      repository: 'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main';
      load: #('default' 'Zinc-Seaside') ].
```

To run Zinc in separate vm:

```Smalltalk
  WAGemStoneRunSeasideGems default
	name: 'Zinc';
	adaptorClass: WAGsZincAdaptor;
	ports: #(8383).
  WAGemStoneRunSeasideGems restartGems.
```
