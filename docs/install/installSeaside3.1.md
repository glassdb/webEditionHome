#Install Seaside3.1.0

Bare bones instructions for loading Seaside3.1.0 into GemStone/S
(verified in 3.1.0.5, but should work in 2.4.x as well). 

Clone Web Edition:

```Shell
cd /opt/git
git clone git@github.com:glassdb/webEditionHome.git
export WE_HOME=/opt/git/webEditionHome
```

At topaz prompt, after logging in as DataCurator, input script that upgrades GLASS to 1.0-beta.9.1 and then input script that loads Seaside3.1.0:

```
input $WE_HOME/server/scripts/upgradeConfigurationOfGLASS.tpz
input $WE_HOME/server/scripts/loadSeaside3.1.0.tpz
```
