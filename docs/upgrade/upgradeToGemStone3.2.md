#Upgrade to GemStone 3.2

---

**READ THE INSTALL GUIDES for [Linux][1] or [Mac][2] FIRST**. 

---

To perform a GemStone/S Web Edition upgrade, you need to accomplish
three things:

1. Install the GemStone/S Core code base for GemStone 3.2, which may include new
   methods and classes.
2. Install the GLASS code base for GemStone 3.2, which may include different sets of
   packages.
3. Install your own application code, which may need to be
   different for GemStone 3.2.

This upgrade process can get a little complicated, so I have created a
[shell script][3] that acts as a driver for the entire Web Edition upgrade
process. The shell script can be used as is or it can be used as a guide
for creating a custom upgrade script for your application:

```Shell
# Script driver for Web Edition upgrades. Before using script
# READ THE Install Guide for your platform.
#
# Before running this script the following environment variables
# must be set:
#
#  GEMSTONE         - directory where GemStone resides
#  GEMSTONE_DATADIR - directory where the extent and tranlogs reside
#  GEMSTONE_NAME    - name of the stone
#  upgradeLogDir    - directory where upgrade log files will be written
#
# The script performs the following operations:
#
#  1. If -e option is present, the given extent is copied into 
#     the GemStone 3.2 data directory ($GEMSTONE_DATADIR) and
#     tranlogs present in the data directory are removed.
#  2. A stone named $GEMSTONE_NAME is started. If the -C option
#     is present, the stone is started with the -C option.
#     The -C option is required if you are upgrading from 2.x.
#  3. Run the standard upgradeImage script. If an error
#     occurs details about the error or errors can found in 
#     topazerrors.log file.
#  4. Define bootstrap globals by executing the bootstrap globals 
#     topaz input file specified in the -b option. 
#  5. Run the standard upgradeSeasideImage script to upgrade
#     ConfigurationOfGLASS to the correct version. If an error
#     occurs details about the error or errors can found in 
#     topazerrors.log file.
#  6. Upgrade your application code by executing the application load
#     topaz input file specified in the -a option.
#
```

##Before Upgrading

---

**READ THE INSTALL GUIDES for [Linux][1] or [Mac][2] FIRST**. 

---

As part of the upgrade process, you need to port your application code to
GemStone 3.2 and verify that the application code itself works well in
GemStone 3.2.

If you are upgrading from GemStone 3.1.x the port may be no more
complicated than installing your application in a virgin seaside extent
and running your tests.

If you are upgrading from GemStone 2.x, the port may be more complicated
and you should pay special attention to the section entitled 
*Prior to Upgrade in existing application* in **Chapter 3** of the
Install Guides for [Linux][1] and [Mac][2].

###Packaging Guidelines

If you find that you do indeed have code changes that are specific to
GemStone 3.2, then you will need to decide on a re-packaging strategy. You can 
take one of two routes:

1. Create a package branch for 3.2, where you simply make the necessary
   changes for 3.2 in-place and then save the Monticello package,
   with a branch name. For example, the package named *MyApplication-Core* would be
   saved as *MyApplication-Core.v32*. Your configuration baseline
   would look like the following:

   ```Smalltalk
   spec for: #'gemstone' do: [ 
     spec package: 'MyApplication-Core' ].
   spec for: #'gs3.2.x' do: [ 
     spec package: 'MyApplication-Core' with: [ spec file: 'MyApplication-Core.v3']
   ```

2. Separate the code into a common package, a 2.x package, and a 3.2
   package. The *MyApplication-Core* package would become the common package.
   The methods and classes that are unique to 2.x would be be moved into
   a package named *MyApplication-2x-Core*. The methods and classes
   that are unique to 3.2 would be be moved into a package named  
   *MyApplication-32x-Core*. Your configuration baseline would be
   modified to look like the following:

   ```Smalltalk
   spec for: #'gemstone' do: [ 
     spec package: 'MyApplication-Core' ].
   spec
     for: #'gs2.4.x'
     do: [ 
       spec
         package: 'MyApplication-Core'
           with: [ spec includes: 'MyApplication-2x-Core' ];
         package: 'MyApplication-2x-Core'
           with: [ spec requires: 'MyApplication-Core' ] ].
   spec
     for: #'gs3.2.x'
     do: [ 
       spec
         package: 'MyApplication-Core'
           with: [ spec includes: 'MyApplication-32-Core' ];
         package: 'MyApplication-32-Core'
           with: [ spec requires: 'MyApplication-Core' ] ]
   ``` 

The first approach is appropriate if you will be moving your entire
development effort to GemStone 3.2 and most if not all code
modifications will take place in the 3.2 branch. It is relatively easy
to merge changes from *MyApplication-Core* to *MyApplication-Core.v32*,
but it is not quite as easy to merge changes from *MyApplication-Core.v32* 
back to *MyApplication-Core*.

The second approach is appropriate if you intend to continue development
for both GemStone 2.x (or 3.1.x) and GemStone 3.2 as it is much easier
to share the common code across multiple platforms, when merging
isn't required.

##Upgrade Script

---

**READ THE INSTALL GUIDES for [Linux][1] or [Mac][2] FIRST**. 

---

The [upgrade.sh script][3] automates the 6 main steps of the GemStone
upgrade process:

1. [Copy extent and remove tranlog files [**OPTIONAL**]](#copy-extent-and-remove-tranlog-files)
2. [Start stone](#start-stone)
3. [Run *upgradeImage* script](#run-upgradeimage-script)
4. [Execute *bootstrap-globals* topaz file](#execute-bootstrap-globals-topaz-file)
5. [Run *upgradeSeasideImage* script](#run-upgradeseasideimage-script)
6. [Execute *application-load* topaz file](#execute-application-load-topaz-file)

The script is provided as a template that you can customize to fit your
upgrade process requirements.

Before running this script, you should have [installed GemStone
3.2](../install/gettingStartedWithWebEdition.md) and use the
[defWebEdition source script](../../bin/defWebEdition) to define the
standard environment variables for the Web Edition.

In addition to the environment variables defined by *defWebEdition*, you
need to define the upgrade specific environment variable
**upgradeLogDir** that specifies the directory where the upgrade log
files will be located.

Finally the GemStone 3.2 stone should not be running when this script is
started.


---

### Copy extent and remove tranlog files
The first step of the upgrade process is to copy the source extent file
(from GemStone 2.4.x or GemStone 3.1) into the $GEMSTONE_DATADIR and
make sure that there are no tranlog files left over from previous runs.

The location of the source extent is specified by the `-e` option:

```Shell
$WE_HOME/bin/upgrade.sh -e /opt/gemstone/3.1/product/seaside/data/extent0.dbf
```

If you are copying the extent from the data dir of an old stone (as
above), make sure that the stone has been shut down cleanly.

If you omit the `-e` option when running the script no extent copy will
be performed and you are responsible for making sure that the proper
extent is present in the $GEMSTONE_DATADIR.

### Start stone
Once the source extent is in place, this script starts the stone using
the stone name specified by the $GEMSTONE_NAME environment variable. The
stone is started with the following command:

```Shell
$GEMSTONE/bin/startstone $GEMSTONE_NAME
```

If the the `-C` option is present (specifying that the source extent is
from GemStone 2.4.x), then the stone is started as follows:

```Shell
$GEMSTONE/bin/startstone -C $GEMSTONE_NAME
```

### Run *upgradeImage* script
### Execute *bootstrap-globals* topaz file
### Run *upgradeSeasideImage* script
### Execute *application-load* topaz file

[1]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-InstallGuide-Linux-3.2.pdf
[2]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-InstallGuide-Mac-3.2.pdf
[3]: ../../bin/upgrade.sh
