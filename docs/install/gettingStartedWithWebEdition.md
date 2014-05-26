# Getting started with Web Edition

To use **Web Edition Home**, [fork][4] and [clone][5] the **Web Edition Home** 
project. With this repository cloned to your local machine you'll
be able to customize the scripts for your own use and share the scripts
with the rest of the community.

It would be a good idea to define a `WE_HOME` environment variable in
your `.bashrc` file, so that it is easy to access the shell scripts from
anywhere on your local system. 

## Installing Gemstone/S
Downloads for the various versions of GemStone/S 64 bit are available on
the [GemTalk Systems][2] 
[ftp site](ftp://ftp.gemtalksystems.com/pub/GemStone64/).

You can choose to follow the step by step instructions in the [GemStone/S 64 
Bit Installation Guide][3] or run the
[installWebEdition.sh script](../../bin/installWebEdition.sh) that's 
available in the `$WE_HOME/bin` directory. The *installWebEdition.sh* script is 
invoked by passing in the version of GemStone that you wish to install:

```Shell
$WE_HOME/bin/installWebEdition.sh 3.2.0
```

The script is intended for use with OS/X and Linux. Besides downloading the
release from the GemTalk Systems ftp site, the script:

1. unzips and installs the release in `/opt/gemstone`.
1. links the release directory to `/opt/gemstone/product`, which is used
   by a number of the Web Edition utility scripts.
2. configures the OS shared memory, assuming a 2GB shared page cache.
3. registers the netldi service in `/etc/services`, using port 50377.
4. creates the `/opt/gemstone/`, `/opt/gemstone/log` and `/opt/gemstone/locks` 
   directories.
5. prepares `/opt/gemstone/product/seaside/data` so that GemStone is ready to 
   run.

## Running Web Edition 

### Set up environment variables
Before starting the GemStone system (aka `starting a stone`), you need to define a
number of environment variables.

Probably the most important environment variable is **$GEMSTONE**. **$GEMSTONE**
defines the root of the product tree where the scripts and utility files for GemStone
can be found. 

There are a number of environent variables that are used by GemStone and the Web
Edition.  The file 
`/opt/gemstone/product/seaside/etc/gemstone.conf` defines the environment variables
that are used by the scripts in `/opt/gemstone/product/seaside/bin` and
`/opt/gemstone/product/bin`. As you get more familiar with GemStone you can customize the
`gemstone.conf` file to match your needs, but for now, I will assume that you using the
default `gemstone.conf`.

In addition to defining the necessary environment variables, you will also want to have
$GEMSTONE/bin and $GEMSTONE/seaside/bin in your PATH environment variable so that
you can easily execute the GemStone shell scripts and executables.

The file `$WE_HOME/bin/defWebEdition` has been created to simplify the process
of defining the environment variables and updating your $PATH. To use the 
`defWebEdition` script, perform the following in your shell:

```Shell
. $WE_HOME/bin/defWebEdition
```

### Starting GemStone

1. [Starting and Stopping the stone](#starting_and_stopping_the_stone).
2. [Starting the netldi](#starting_the_netldi).
3. [GemStone Status](#gemstone_status).

#### Starting and Stopping the stone

```Shell
startGemstone
```

```Shell
stopGemstone
```

#### Start the netldi

```Shell
startnet
```

#### GemStone Status

```Shell
gslist -lc
```

```
Status   Version    Owner    Pid   Port   Started     Type       Name
------- --------- --------- ----- ----- ------------ ------      ----
exists  3.2.0     daleh     19522 50377 May 26 13:16 Netldi      gs64ldi
exists  3.2.0     daleh     19495 52215 May 26 13:16 Stone       seaside
exists  3.2.0     daleh     19496 52207 May 26 13:16 cache       seaside~90895bd348ba8c27
```
## Web Edition Development Environments

1. [GemTools](../../dev/gemtools/gemtools.md)
2. [Jade](http://programminggems.wordpress.com/2013/10/01/jade/)
3. [tODE (under development)](./gettingStartedWithTode.md)

## Seaside

Workspace for loading Seaside into the **Web Edition**

```Smalltalk
| project version repository |
project := 'Seaside3'.
version := '3.0.10'.
repository := 'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main'.

GsDeployer
  deploy: [
    [
    Metacello new
      configuration: project;
      version: version;
      repository: repository;
      get.
    Metacello new
      configuration: project;
      version: version;
      repository: repository;
      onConflict: [ :ex | ex allow ];
      load: 'ALL'
     ]  on: Warning do: [:ex |
           Transcript
              cr;
              show: ex description.
            ex resume ].
  ].
```

[1]: http://gemtalksystems.com/index.php/community/gss-support/documentation/gs64/
[2]: http://gemtalksystems.com
[3]: http://gemtalksystems.com/index.php/community/gss-support/documentation/gs64/
[4]: https://help.github.com/articles/fork-a-repo
[5]: https://help.github.com/articles/fork-a-repo#step-2-clone-your-fork
