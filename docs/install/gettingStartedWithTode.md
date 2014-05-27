# Getting Started with TODE

 * tODE is known to work with GemStone/S 3.1.x and 3.2.x. 
 * tODE should work with GemStone 3.0.x, but it has not been 
   heavily tested. 
 * tODE can be used with GemStone 2.4.x, but there are some 
   critical bugs that can cause the vm to crash. 
   Only hard-core users should attempt to use tODE with GemStone 2.4.x.

1. [Install and Start GemStone](#install_and_start_gemstone)
2. [Download tODE Client](#download_tode_client)
3. [Prepare for GemStone Login](#prepare_for_gemstone_login)

## Install and Start GemStone

Before getting started with tODE, you need to [install GemStone][1] and 
[start the stone and netldi processes][2]. 

## Download tODE Client
Once GemStone is up and running, you will need a tODE client. 

Currently the tODE client software can be installed in Pharo1.4, 
[Pharo2.0][4], and [Pharo3.0][5]. 

tODE relies pretty heavily on custom keyboard shortcuts and at the present
time I have had trouble with getting the keyboard shortcuts defined correctly on
the various versions of Pharo. I assume that I will eventually get things 
figured out, but until then:

* Pharo3.0 is not usable with either Linux or OS X. Most notably `CMD-o` 
  appears to be swallowed by Pharo and I have yet to discover the magic
  incantation to allow me to use `CMD-o` for my own purposes.
* Pharo2.0 is usable in OS X, but has some critical problems on Linux. Most
  notably, the `ALT` and `CTL` modifiers are incosistently mapped on Linux.
* Pharo1.4 is usable in both OS X and Linux. For Linux this is the only usable
  platform. For the most part the `CTL` modifier works fine on Linux, 
  but in a couple of cases you must use the `ALT` modifier instead:
  * `CTL-C` and `CTL-B` are not mapped correctly so `ALT-C` and `ALT-B` must be
    used instead. There may be others.

With regards to Windows clients, I have not done any testing, so we will learn
together. 

### Download tODE Client
The current version of the one-click tODE client is `0.0.1`. 
Version `0.0.1-p2.0` is based upon [Pharo2.0][4] and `0.0.1-1.4` is based upon
Pharo1.4i. Click on the link below to download the Pharo version of your choice:

  * [tODE_0.0.1-p2.0][6]
  * [tODE_0.0.1-p1.4][7]

## Prepare for GemStone Login

If you haven't already [forked and cloned the Web Edition Home repository][9],
now is a good time to do so.

The tODE System Menu:

![tODE System Menu][8]

is your entrypoint for setting up and controlling tODE. Before using tODE for the 
first time you will need to perform the following operations:

1. [Define tODE Home](#define_tode_home)
2. [Update tODE Client](#update_tode_client)
3. [Choose tODE Window Layout](#choose_tode_window_layout)
4. [Define tODE Session Description](#define_tode_session_description)
5. [Test tODE Login](#test_tode_login)

### Define tODE home
Using the `Define tODE Home` menu item on the System Menu to define the root
directory of your Web Edition checkout (i.e., `/opt/git/webEditionHome`):
### Update tODE Client
The `Update tODE Client` menu item updates the client-side tODE code using the
sript defined in `$WE_HOME/dev/tode/client/scripts/updateClient. By default the
following script is used:

```
updateClient --clientRepo=github://dalehenrich/tode:master/repository
```

As you gain more experience with tODE you may want to customize the script so that
you can use your own client-side tODE repository.

### Choose tODE Window Layout
This is the default window layout for tODE based on the `mac_PharoDefault` layout:

![default window layout][10]

Using the `tODE Window Layout` menu item you can choose a different layout to better 
fit on your display:

![tODE windowLayout menu][12]

### Define tODE Session Description

The default session description is named `seaside` and is defined in the file 
`$WE_HOME/dev/tode/client/descriptions`:

```
OGCustomSessionDescription {
        #name : 'seaside',
        #stoneHost : 'localhost',
        #stoneName : 'seaside',
        #gemHost : 'localhost',
        #netLDI : '50377',
        #gemTask : 'gemnetobject',
        #userId : 'DataCurator',
        #password : 'swordfish',
        #backupDirectory : '',
        #gemstoneVersion : '3.2.0'
        }
}
```

For those of you familiar with GemTools, you should recognize fields. 
If you need to change some of the settings, you can edit the file directly, or using
the client-side workspace in `$WE_HOME/dev/tode/image/sessionSetup.ws`:

```Smalltalk
(OGCustomSessionDescription new
    name: 'seaside';
    gemstoneVersion: '3.2.0';
    adornmentColor: Color lightGreen;
    stoneHost: 'localhost';
    stoneName: 'seaside';
    gemHost: 'localhost';
    netLDI: '50377';
    gemTask: 'gemnetobject';
    userId: 'DataCurator';
    password: 'swordfish';
    osUserId: '';
    osPassword: '';
    backupDirectory: '';
    dataDirectory: '';
    yourself) exportTo: TDShell sessionDescriptionHome.
TDShell testLogin: 'seaside'.
```

to adjust the fields to match your installation. 

The above workspace will write your changes into the directory 
`$WE_HOME/dev/tode/client/descriptions`, using the name field of the session description
as the name of the file (the **#exportTo:** message).

### Test tODE Login
In the above workspace, you may have noticed the **testLogin:** message. The 
**testLogin:** message executes the tODE `testLogin` command.

The `testLogin` command can be invoked several different ways:

1. via the **testLogin:** message in a client-side workspace:

   ```Smalltalk
   TDShell testLogin: 'seaside'
   ```
2. via the `tODE Test Login` menu item on the System Menu:

   ![tode test login menu item][13]
3. via the command line:

   ![testLogin shell][14]

You should run the `testLogin` command until you get a successful login message:

![successful test login][11]

Note that the `testLogin` command gives you information about the state of the image. In this case, the lines:

```
GLASS1 not installed
Tode not installed
```

indicate that tODE needs to be installed.

[1]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#installing-gemstones
[2]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#running-web-edition
[3]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1.app.zip
[4]: http://old.pharo-project.org/pharo-download/release-2-0
[5]: http://pharo.org/download
[6]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1-p2.0.app.zip
[7]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1-p1.4.app.zip
[8]: ../images/defineTodeHome.png
[9]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md
[10]: ../images/defaultWindowLayout.png
[11]: ../images/testLoginSuccessSample.png
[12]: ../images/windowLayoutChoices.png
[13]: ../images/testLoginMenuItem.png
[14]: ../images/testLoginShellCommand.png

