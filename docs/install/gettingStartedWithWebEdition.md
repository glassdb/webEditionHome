# Getting started with Web Edition

## Installation
Downloads for the various versions of GemStone/S 64 bit are available from
the [GemTalk Systems][2] 
[ftp site](ftp://ftp.gemtalksystems.com/pub/GemStone64/).

You can choose to follow the step by step instructions in the [GemStone/S 64 
Bit Installation Guide][3] or run the
[installWebEdition.sh script](../../bin/install/installWebEditions.sh) that's 
available in the `bin/install` directory. The *installWebEdition.sh* script is 
invoked by passing in the version of GemStone that you wish to install:

```Shell
$WE_HOME/bin/install/installWebEdition.sh 3.2
```

The script is intended for use with OS/X and Linux. Besides downloading the
release from the GemTalk Systems ftp site, the script:
1. unzips and installs the release in /opt/gemstone.
1. links the release directory to `/opt/gemstone/product`, which is used
   by a number of the Web Edition utility scripts.
2. configures the OS shared memory, assuming a 2GB shared page cache.
3. registers the netldi service in /etc/services, using port 50377.
4. creates the `/opt/gemstone/`, `/opt/gemstone/log` and `/opt/gemstone/locks` 
   directories.
5. prepares `/opt/gemstone/product/seaside/data` so that GemStone is ready to 
   run.

## Running Web Edition 
## Web Edition Development Environments
## Seaside and Web Edition

[1]: http://gemtalksystems.com/index.php/community/gss-support/documentation/gs64/
[2]: http://gemtalksystems.com
[3]: http://gemtalksystems.com/index.php/community/gss-support/documentation/gs64/
