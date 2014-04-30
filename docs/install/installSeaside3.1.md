#Install Seaside3.1.0

Clone Web Edition:

```Shell
cd /opt/git
git clone git@github.com:glassdb/webEditionHome.git
export WE_HOME=/opt/git/webEditionHome
```

At topaz prompt, input script that upgrades GLASS to 1.0-beta.9.1 and then input script that loads Seaside3.1.0:

```
input $WE_HOME/server/scripts/upgradeConfigurationOfGLASS.tpz
input $WE_HOME/server/scripts/loadSeaside3.1.0.tpz
```
