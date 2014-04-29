#Upgrade to GemStone 3.2

To perform a GemStone/S Web Edition upgrade, you need to accomplish
three things:

1. Install the GemStone/S Core code base for GemStone 3.2, which may include new
   methods and classes.
2. Install the GLASS code base for GemStone 3.2, which may include different sets of
   packages.
3. Install your own application code, which may need to be
   different for GemStone 3.2.

This upgrade process can get a little complicated, so I have created a
shell script that acts as a driver for the entire Web Edition upgrade
process. The shell script can be used as is or it can be used as a guide
for creating a custom upgrade script for your application.

##Before Upgrading

**READ THE INSTALL GUIDES for [Linux][1] and [Mac][2]**. 

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
GemStone 3.2, then you will need to decide on a re-packaging strategy. 

You can take one of two routes:

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

[1]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-InstallGuide-Linux-3.2.pdf
[2]: http://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-InstallGuide-Mac-3.2.pdf

