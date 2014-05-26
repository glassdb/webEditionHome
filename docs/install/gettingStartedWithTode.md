# Getting Started with TODE

 * tODE is known to work with GemStone/S 3.1.x and 3.2.x. 
 * tODE should work with GemStone 3.0.x, but it has not been 
   heavily tested. 
 * tODE can be used with GemStone 2.4.x, but there are some 
   critical bugs that can cause the vm to crash. 
   Only hard-core users should attempt to use tODE with GemStone 2.4.x.

1. [Install and Start GemStone](#install_and_start_gemstone)
2. [Download tODE Client](#download_tode_client)

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

[1]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#installing-gemstones
[2]: https://github.com/glassdb/webEditionHome/blob/master/docs/install/gettingStartedWithWebEdition.md#running-web-edition
[3]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1.app.zip
[4]: http://old.pharo-project.org/pharo-download/release-2-0
[5]: http://pharo.org/download
[6]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1-p2.0.app.zip
[7]: http://seaside.gemtalksystems.com/tODE/tODE_0.0.1-p1.4.app.zip
