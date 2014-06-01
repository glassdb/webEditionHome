# Getting Started with TODE

 * tODE is known to work with GemStone/S 3.1.x and 3.2.x. 
 * tODE should work with GemStone 3.0.x, but it has not been 
   heavily tested. 
 * tODE can be used with GemStone 2.4.x, but there are some 
   critical bugs that can cause the vm to crash. 
   Only hard-core users should attempt to use tODE with GemStone 2.4.x.

1. [Install and Start GemStone](#install-and-start-gemstone)
2. [Download tODE Client](#download-tode-client)
3. [Prepare for GemStone Login](#prepare-for-gemstone-login)
4. [Open tODE Shell](#open-tode-shell)

## Install and Start GemStone

Before getting started with tODE, you need to [install GemStone][1] and 
[start the stone and netldi processes][2]. Once you've got your netldi started
return to this document.

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

With regards to Windows clients, at the moment it appears that the with respect to
the modifier keys, Windows is similar to Linux in that Pharo1.4 is probably the best
fit. Unfortunately, the FileTree implementation for `github:` repositories is
broken for Windows in Pharo1.4. I believe that the FileTree implementation for 
Windows in Pharo3.0 is functional, but I'm afraid that the keymapping issues aren't
yet solved and I haven't built a one-click for Pharo3.0 (it appears that there is no 
on-click available for Pharo3.0 so there's even more work that needs to be done to
produce a tODE image based on Pharo3.0...). It **is** possible to use a Pharo1.4
tODE with Windows, but updating the client software is problematic. At the end of 
the day, I would say that if you need to use a Windows client, you should wait for a 
bit until I solve the Pharo3.0 issues.

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

is your entry point for setting up and controlling tODE. 

Before using tODE for the 
first time you will need to perform the following operations:

1. [Define WebEdition Root](#define-webedition-root)
2. [Update tODE Client](#update-tode-client)
3. [Choose tODE Window Layout](#choose-tode-window-layout)
4. [Define tODE Session Description](#define-tode-session-description)
5. [Test tODE Login](#test-tode-login)
6. [Install tODE on Server](#install-tode-on-server)

### Define WebEdition Root
Use the `Define WebEdition Root` menu item on the System Menu to define the root
directory of your Web Edition checkout (i.e., `/opt/git/webEditionHome`).

Most of the tODE menu items are derived from the contents of the directories
located in `$WE_HOME/dev/tode/client`, so it is important that you have:

1. Cloned [Web Edition Home][20] to your client machine.
2. Cloned [Web Edition Home][20] to your server machine, if
   you are running your server on a remote machine.
3. Defined the WebEdition root for your client using the  `Define WebEdition Root`
   or by executing the following expression in a workspace on the client:
  ```Smalltalk
  TDShell webEditionRoot: '/opt/git/webEditionHome'.
  ```
### Update tODE Client
It is always a good idea to update the client software after downloading a new one-click
image, because the one-click images are not updated nearly as frequently as the tODE
code base changes.

The `Update tODE Client` menu item updates the client-side tODE code using the
sript defined in `$WE_HOME/dev/tode/client/scripts/updateClient`:

```
updateClient --clientRepo=github://dalehenrich/tode:master/repository
```

As you gain more experience with tODE you may want to customize the script so that
you can use your own client-side tODE repository.

### Choose tODE Window Layout
At this point in time, you should change your system font from *Bitmap Deja Vu Sans* 
to a mono-spaced font. Many of the tODE windows display textual information that is
layed out assuming mono-spaced fonts. Compare the **Projects** windows in the two
layouts below; the first layout is using *Bitmap Deja Vu Sans*
and the second layout is using *Menlo Regular 9*; notice how the columns are mis-aligned
in the first layout.
The Mac, Linux and Windows platforms each have a variety of pleasant
mono-spaced fonts from which to choose. Over time, I've found that my font preference
changes as I use different window layouts and different sizes of displays.

Here is the default window layout for tODE based on the `standard-small` layout:

![default window layout][10]

Here is an example of the `alternate-large` layout:

![alternate window layout][19]

Using the `tODE Window Layout` menu item you can choose a different layout to better 
fit on your display:

![tODE windowLayout menu][12]

The `small` layouts are designed for small displays
and/or large fonts and provide for using the minimum number of windows. 
The `large` layouts are designed for large displays and/or
small fonts and provide additional areas for windows.

It is possible to create a custom layout using the `tODE Workspaces > windowsLayout.ws`
menu item:

![tode workspaces windowlayout.ws menu][21]

The workspace allows you change the proportions of the different layout components
and the number of extra lists that you'd like to make room for:

```Smalltalk
"choose TDStandardWindowProperties or 
 TDAlernativeWindowProperties class for different layouts.
 Adjust parameters to change  proportions or configuration of 
 layout. "
| layoutName sessionDescriptionName propertiesClass |
"TDShell webEditionRoot:'/opt/git/webEditionHome/'"
layoutName := 'custom'.
sessionDescriptionName := 'seaside'.
propertiesClass := TDStandardWindowProperties.
(propertiesClass new
  margin: 3 @ 3;		"inset from edges of display"
  codeWidthFactor: 0.45;	"% of width devoted to code window"
  extraLists:2 ;		"number of extra lists"
  shellHeightFactor: 0.33;	"% of height devoted to shell window"
  topHeightFactor: 0.25;	"% of height devoted to top windows"
  yourself) 
    exportTo: TDShell windowLayoutHome, layoutName.
TDAbstractWindowProperties install: layoutName.
TDShell testWindowLayout: sessionDescriptionName.
```

You can also subclass **TDAbstractWindowProperties** and define a completely different
window layout for tODE, if you so desire.

### Define tODE Session Description

The default session description is named `seaside` and is defined in the file 
`$WE_HOME/dev/tode/client/descriptions`:

```
TDSessionDescription {
        #name : 'seaside',
        #stoneHost : 'localhost',
        #stoneName : 'seaside',
        #gemHost : 'localhost',
        #netLDI : '50377',
        #gemTask : 'gemnetobject',
        #userId : 'DataCurator',
        #password : 'swordfish',
        #backupDirectory : '',
        #gemstoneVersion : '3.2.0',
        #serverGitRoot : '/opt/git',
        #serverTodeRoot : '/opt/git/webEditionHome/dev/tode`
}
```

For those of you familiar with GemTools, you should recognize most of the fields. 
Definitely look at the values for **#serverGitRoot** and **#serverTodeRoot** and change 
them to match your installation: remember that the paths for these two fields
represent directories on your server machine.
**50377** is the default netldi port. To determine which port the netldi process
is listening on, run the [gslist command][18].

If you need to change some of the settings, you can edit the file directly, or using
the client-side workspace in `$WE_HOME/dev/tode/image/sessionSetup.ws`
to adjust the fields to match your installation:

```Smalltalk
| webEditionRoot sessionName |
webEditionRoot := '/opt/git/webEditionHome/'.
sessionName := 'seaside'.
TDShell webEditionRoot: webEditionRoot.
(TDSessionDescription new
    name: sessionName;
    gemstoneVersion: '3.2.0';
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
    serverGitRoot: '/opt/git';
    serverTodeRoot: webEditionRoot, '/dev/tode`;
    yourself) exportTo: TDShell sessionDescriptionHome.
TDShell testLogin: sessionName.
```

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

###Install tODE on Server

To install tODE on the server, use `tODE Install` menu item:

![tODE Install menu item][15]

The `tODE install` menu item actually executes the script located in the file
`$WE_HOME//dev/tode/client/scripts/installTode`:

```Shell
updateClient --clientRepo=github://dalehenrich/tode:master/repository
updateServer --clientScriptPath=scripts
bu backup tode.dbf
mount --todeRoot home /
mount --todeRoot projects /home
bu backup home.dbf
cd 
```

As you can see, script starts by updating the client-side code, then updates the 
server-side code, followed by a backup to a file
named `tode.dbf`, execution of the `mount` 
command, and finally a backup to a file name `home.dbf`.

##Open tODE Shell

Once tODE has been successfuly installed on the server. You can
use the tODE System Menu:

![tODE Shell menu item][16]

to open the tODE shell window:

![tODE Shell][17]


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
[15]: ../images/installTodeMenuItem.png
[16]: ../images/todeShellMenuItem.png
[17]: ../images/todeShell.png
[18]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#gemstone-status
[19]: ../images/alternateWindowLayout.png
[20]: https://github.com/glassdb/webEditionHome
[21]: ../images/todeWindowsLayoutWorkspaceMenuItem.png
