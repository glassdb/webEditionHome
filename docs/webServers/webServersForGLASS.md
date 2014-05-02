#WebServers for WebEdition

##Swazoo
The http://www.swazoo.org/ Swazoo2 web adaptor is currently available for Seaside3.0.

##FastCGI
I recommend that [lighttpd](http://www.lighttpd.net) and [FastCGI](http://www.fastcgi.com/) be used as the web front-end for Seaside. 
Here's a blog post in favor of FastCGI:
* [ My Favorite GLASS Front-End Server: lighttpd](http://kentreis.wordpress.com/2009/10/07/my-favorite-glass-front-end-server-lighttpd/)

Here's a blog post in favor of using Swazoo:
* [Faking a https client for GLASS](http://www.monkeysnatchbanana.com/posts/2010/06/22/faking-a-https-client-for-glass.html)

In addition all of the scaling tests that I have done for Seaside have been performed running a combination of [ lighttpd](http://www.lighttpd.net/)
and [FastCGI](http://www.fastcgi.com/):
*  GLASS: A Share Everything Architecture for Seaside – ESUG 2008](http://gemstonesoup.wordpress.com/2009/10/18/glass-a-share-everything-architecture-for-seaside-esug-2008/)
* [Scaling Seaside with GemStone/S](http://gemstonesoup.wordpress.com/2007/10/19/scaling-seaside-with-gemstones/)

#Apache, Lighttpd and Nginx

I recommend that [lighttpd](http://www.lighttpd.net) and [FastCGI](http://www.fastcgi.com/) be used as the web front-end for Seaside and 
here are some posts that support that recommendation:

* [My Favorite GLASS Front-End Server: lighttpd](http://kentreis.wordpress.com/2009/10/07/my-favorite-glass-front-end-server-lighttpd/)
* [Shedding Light on Lighttpd](http://gemstonesoup.wordpress.com/2008/09/28/shedding-light-on-lighttpd/)
* [Gemstone/S and FastCGI with lighttpd](https://web.archive.org/web/20130615140022/http://miguel.leugim.com.mx/index.php/2008/09/27/gemstones-and-fastcgi-with-lighttpd/)
* [GLASS is Flying with lighttpd](http://gemstonesoup.wordpress.com/2007/10/12/glass-is-flying-with-lighttpd/)
  
[Apache](http://httpd.apache.org/):

* [Installing and Configuring Apache on Slicehost for GLASS](http://programminggems.wordpress.com/2008/09/12/slice-4/)
* [FastCGI is slow to close connection?](http://programminggems.wordpress.com/2010/01/10/fastcgi-2/)
* [mod_fastcgi interaction with mod_deflate](http://programminggems.wordpress.com/2010/01/11/fastcgi-3/)

[Nginx](http://nginx.org/en/):

* [GemStone with Nginx](https://web.archive.org/web/20101008033233/http://www.hyperbomb.com/2009/02/01/gemstone-with-nginx)
