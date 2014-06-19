#/bin/bash
# replace seaside extent with fresh copy & delete tranlogs
#
cp $GEMSTONE/bin/extent0.seaside.dbf $GEMSTONE/seaside/data/extent0.dbf
chmod +w $GEMSTONE/seaside/data/extent0.dbf
rm -f $GEMSTONE/seaside/data/tranlog*.dbf

