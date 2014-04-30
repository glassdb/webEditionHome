#Install Seaside3.1.0

Bare bones instructions for loading Seaside3.1.0 into GemStone/S
(verified in 3.1.0.5, but should work in 2.4.x as well). 

Clone Web Edition:

```Shell
cd /opt/git
git clone git@github.com:glassdb/webEditionHome.git
export WE_HOME=/opt/git/webEditionHome
```

Define Web Edition environment variables:

```Shell
. $WE_HOME/bin/defWebEdition
```

Start stone and topaz:

```Shell
startGemstone
topaz -l
```

At topaz prompt, after logging in as DataCurator, input script that upgrades GLASS to 1.0-beta.9.1 and then input script that loads Seaside3.1.0:

```
set gemstone seaside
set user DataCurator pass swordfish
login
input $WE_HOME/server/topaz/upgradeConfigurationOfGLASS.tpz
input $WE_HOME/server/topaz/seaside3.1/loadSeaside3.1.0.tpz
input $WE_HOME//server/topaz/seaside3.1/startZinc.tpz
```

The topaz session will hang with the following message:

```
--transcript--'Starting Zinc adaptor'
```

If you want to quit the server, just hit `CTL-c`.

You should be able to hit Seaside using the following url:

```
http://localhost:8383/
```

