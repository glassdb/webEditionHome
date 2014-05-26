# Getting Started with TODE

tODE is known to work with GemStone/S 3.1.x and 3.2.x. tODE should work with
GemStone 3.0.x, but it has not been heavily tested. tODE can be used with 
GemStone 2.4.x, but there are some critical bugs that can cause the vm to 
crash, so only hard-core users should attempt to use tODE with GemStone 2.4.x.

1. [Install and Start GemStone](#install_and_start_gemstone]
2. [Build or Download tODE Client](#build_or_download_tode_client)

## Install and Start GemStone

Before getting started with tODE, you need to [install GemStone][1] and 
[start the stone and netldi processes][2]. 

## Build or Download tODE Client
Once GemStone is up and running, you will need a tODE client. 

Currently the tODE client software can be installed in Pharo1.4, 
[Pharo2.0][4], and [Pharo3.0][5]. 

tODE relies pretty heavily on custom keyboard shortcuts and at the present
time I have had trouble with getting the keyboard shortcuts defined correctly on
the various versions of Pharo. I assume that I will eventually get things 
figured out, but until then:

* Pharo3.0 is not usable with either Linux or OS X.
* Pharo2.0 is usable in OS X, but has some critical problems on Linux.
* Pharo1.4 is usabel in both OS X and Linux. .

### Download tODE Client
The current version of the one-click tODE client is `0.0.1`. Version `0.0.1` is
based upon [Pharo2.0][4].
### Build tODE Client
#### Install Client Code
#### Install GemStone GCI libraries

[1]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#installing-gemstones
[2]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#running-web-edition
[3]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1.app.zip
[4]: http://old.pharo-project.org/pharo-download/release-2-0
[5]: http://pharo.org/download
