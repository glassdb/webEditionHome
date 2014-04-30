#GLASS, Seaside, Web Edition Terminology
In the existing body of documentation and product artifacts you will see 
references to **GLASS**, **Seaside** and **Web Edition**. At the end of 
the day, 
these terms all refer to the same thing, which we are now calling the
**Web Edition**.

In the beginning, [Seaside][3] was provided pre-installed in the 
`$GEMSTONE/bin/extent0.seaside.dbf` extent file and it was appropriate to
use Seaside to describe the product and many of the product artifects and 
early documentation were created with Seaside in the name.

Around the same time, in the very early days, GLASS was invented as an acronym 
standing for <b>G</b>emstone, <b>L</b>inux, <b>A</b>pache, <b>S</b>easide, <b>S</b>malltalk 
and GLASS was then used in more documentation.

After a couple of years it became obvious that it wasn't practical to ship 
Seaside pre-installed in the GemStone product tree (in 
`$GEMSTONE/bin/extent0.seaside.dbf`) as Seaside evolved at a different 
pace than the GemStone product releases.  In addition, new releases of Seaside
were not necessarily backward compatible with older releases which made it
necessary to *uninstall* Seaside from `extent0.seaside.dbf` before installing
a new version of Seaside. Finally there were other web frameworks like [Aida][1]
and [iliad][2] that were not necessarily compatible with Seaside, so the 
decision was made to not include Seaside in the `extent0.seaside.dbf`.

In actual fact, the code in `extent0.seaside.dbf` was divided into two very
distinct layers. The Squeak/Pharo compatibility layer and the Seaside code base.
The Squeak/Pharo compatibility layer made the job of porting applications 
developed in Squeak or Pharo much easier, so there was real utility to 
providing that layer separate from Seaside.

In the documentation, I began calling the compatibility layer GLASS. The split
was announced in [July of 2010][4].

For a variety of reasons (none of them **good** reasons), the product
artifacts retained their original names, while I continued to the the GLASS 
acronym to describe the compatibility layer code.

Today I am starting an effort to slowly rename and rebrand the compatibility layer
as the Web Edition. The product artifacts will change with the next major release
of GemStone (beyond 3.2) and as the documentation is consolidated in the **Web Edition
Home**, the terminology will be corrected.

Until then, please bear with me. 

[1]: http://www.aidaweb.si/
[2]: http://www.iliadproject.org/
[3]: http://www.seaside.st/
[4]: http://gemstonesoup.wordpress.com/2010/07/15/gemstones-64-version-2-4-4-1-is-shipping/
