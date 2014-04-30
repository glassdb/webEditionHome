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

###Packag Naming Guidelines

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
$WE_HOME/bin/upgrade.sh -C -e /opt/gemstone/3.1/product/seaside/data/extent0.dbf \
                        -a $WE_HOME/bin/upgrade/loadSeaside3.0.10.tpz \
                        -b $WE_HOME/bin/upgrade/bootstrapConfigurationOf
```

If you are copying the extent from the data dir of an old stone (as
above), make sure that the stone has been shut down cleanly.

If you omit the `-e` option when running the script no extent copy will
be performed and you are responsible for making sure that the proper
extent is present in the $GEMSTONE_DATADIR.

### Start stone
Once the source extent is in place, the script starts the stone using
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

After the stone is started, the script waits 5 minutes for the stone to
be ready for logins.

### Run *upgradeImage* script
Once the stone has been started, the script runs *upgradeImage*
using the following command:

```Shell
$GEMSTONE/bin/upgradeImage -s $GEMSTONE_NAME
```
If there are errors during the exectuion of the script, 
the *topazerrors.log* file contains pointers to the error conditions. 

### Execute *bootstrap-globals* topaz file

As described in the *Configure Seaside Upgrade* section of the 
**Installation Guides for [Linux][1] or [Mac][2]** there are a number of
**Bootstrap Globals**  that can be set to control the operation of the
*upgradeSeasideImage* script.

The original intent of the *upgradeSeasideImage* script was that it
would bootstrap the correct version of the ConfigurationOfGLASS (GLASS
1.0-beta.9.1 for GemStone 3.2) into the image as well as load the
correct version of your application. 

The script made the assumption
that it would be relatively straightforward to arrange to have all of
the mcz files used by your application located in a single
directory-based Monticello repository
(**BootstrapRepositoryDirectory**). With the increased usage of git-base 
repositories, this particular assumption is no longer valid.

[As pointed out by Pieter Nagel][4] in a discussion on the [GLASS mailing
list][5], it turns out that the
*upgradeSeasideImage* really only needs to bootstrap the code referenced
by **ConfigurationOfGLASS** and produce an upgraded version of the
*extent0.seaside.dbf* file.

To that end I have created a default [*bootstrap-globals*
file](../../bin/upgrade/bootstrapConfigurationOfGLASS1.0-beta.9.1.tpz) with the following
contents:

```Smalltalk
 UserGlobals
  at: #BootstrapRepositoryDirectory
  put: GsPackageLibrary getMonticelloRepositoryDirectory.
true
%
run
 UserGlobals
  at: #BootstrapApplicationLoadSpecs
  ifAbsent: [
    UserGlobals
      at: #BootstrapApplicationLoadSpecs
      put: {
        { 'ConfigurationOfGLASS' . '1.0-beta.9.1' . #('default') .
              BootstrapRepositoryDirectory } .
           }.
  ].
```

The above is the absolute minimum needed to correctly bootstrap GLASS
into an upgraded repository.


The location of the *bootstrap-globals* file is specified by the `-b` option:

```Shell
$WE_HOME/bin/upgrade.sh -C -e /opt/gemstone/3.1/product/seaside/data/extent0.dbf \
                        -a $WE_HOME/bin/upgrade/loadSeaside3.0.10.tpz \
                        -b $WE_HOME/bin/upgrade/bootstrapConfigurationOf
```

In the event that you want to follow the original formula of upgrading
using the full range of **Bootstrap Globals**, then you can create and substitute your 
own *bootstrap-globals* file. 

### Run *upgradeSeasideImage* script
### Execute *application-load* topaz file

## Upgrade Error Diagnostics

### Application Load Error

For example, The
*topazerrors.log* file contains lines like the following:

```
near line 110 of file /export/foos2/users/dhenrich/3.0/n_gss64bit/upgrades/upgradeDir/topazApplication_1.out, ERROR: UNEXPECTED ERROR
topaz> time
 04/23/2014 14:10:46.634 PDT
```

that reference an error at a particular line number in the given file.
Here's the chunk of the file referenced in the last error:

```
--transcript--'Warning: This package depends on the following classes:
  BaselineOf
You must resolve these dependencies before you will be able to load these definitions:
  BaselineOfMetacello
  BaselineOfMetacello>>baseline:
  BaselineOfMetacello>>gemstone10beta311PostLoadDoIt
  BaselineOfMetacello>>reprimeRegistryIssue197
  BaselineOfMetacello>>testResourcePostLoadDoIt
'
--transcript--'Loaded -> BaselineOfMetacello-ChristopheDemarey.68 --- filetree:///opt/git/metacello-work/repository --- filetree:///opt/git/metacello-work/repository'
-----------------------------------------------------
GemStone: Error         Nonfatal
a MessageNotUnderstood occurred (error 2010), a UndefinedObject does not understand  #'project'
Error Category: 231169 [GemStone] Number: 2010  Arg Count: 4 Context : 299651585 exception : 246793217
Arg 1: [19544065 sz:7 cls: 110849 Symbol] project
Arg 2: [2 sz:0 cls: 74241 SmallInteger] 0 == 0x0
Arg 3: [20 sz:0 cls: 76289 UndefinedObject] nil
Arg 4: [246792961 sz:0 cls: 66817 Array] anArray
ERROR: UNEXPECTED ERROR
topaz> time
 04/23/2014 14:10:46.634 PDT
topaz > exec iferr 1 : stk
==> 1 MessageNotUnderstood >> defaultAction         @2 line 3   [methId 212055297]
2 MessageNotUnderstood (AbstractException) >> _signalWith: @5 line 25   [methId 212120321]
3 MessageNotUnderstood (AbstractException) >> signal @2 line 47   [methId 212123905]
4 UndefinedObject (Object) >> doesNotUnderstand: @9 line 10   [methId 168907521]
5 UndefinedObject (Object) >> _doesNotUnderstand:args:envId:reason: @7 line 12   [methId 168899073]
6 [] in  ExecBlock0 (MetacelloScriptEngine) >> get @13 line 12   [methId 241598209]
7 ExecBlock0 (ExecBlock) >> ensure:             @2 line 12   [methId 210496001]
8 MetacelloProjectRegistration class >> copyRegistryRestoreOnErrorWhile: @8 line 14   [me
thId 234215169]
9 MetacelloScriptEngine >> get                  @2 line 6   [methId 234177537]
10 [] in  ExecBlock1 (MetacelloScriptExecutor) >> execute: @11 line 12   [methId 241584129]
11 [] in  ExecBlock1 (MetacelloScriptApiExecutor) >> executeString:do: @5 line 4   [methId 241436417]
12 Array (Collection) >> do:                     @5 line 10   [methId 210610433]
13 MetacelloScriptApiExecutor >> executeString:do: @5 line 4   [methId 235000833]
14 Unicode7 (String) >> execute:against:         @2 line 2   [methId 242037505]
15 MetacelloScriptApiExecutor (MetacelloScriptExecutor) >> execute: @6 line 6   [methId 234164993]
16 Metacello >> execute                          @6 line 5   [methId 234410241]
17 Metacello >> get                              @3 line 5   [methId 234409729]
18 [] in  Executed Code                          @5 line 22   [methId 246608129]
19 ExecBlock0 (ExecBlock) >> on:do:              @3 line 42   [methId 210482433]
20 [] in  Executed Code                          @10 line 37   [methId 246504449]
21 Array (Collection) >> do:                     @5 line 10   [methId 210610433]
22 [] in  Executed Code                          @2 line 12   [methId 246500353]
23 [] in  ExecBlock0 (GsDeployer) >> deploy:     @8 line 8   [methId 243635969]
24 ExecBlock0 (ExecBlock) >> on:do:              @3 line 42   [methId 210482433]
25 [] in  ExecBlock0 (GsDeployer) >> deploy:     @2 line 9   [methId 240842753]
26 [] in  ExecBlock0 (MCPlatformSupport class) >> commitOnAlmostOutOfMemoryDuring: @3 line 7   [methId 241037057]
27 ExecBlock0 (ExecBlock) >> ensure:             @2 line 12   [methId 210496001]
```

From this information, you should be able to deduce the problem. In the
above case, the class **BaselineOf** was missing from the repository.


[1]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-InstallGuide-Linux-3.2.pdf
[2]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-InstallGuide-Mac-3.2.pdf
[3]: ../../bin/upgrade.sh
[4]: http://forum.world.st/Glass-Upgrade-GS-2-4-GS-3-1-when-GLASS-Seaside-etc-versions-have-already-diverged-tp4745943p4746183.html
[5]: http://lists.gemtalksystems.com/mailman/listinfo/glass
