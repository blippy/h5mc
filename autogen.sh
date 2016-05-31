autoreconf -iv

#Alternatively, you may set the environment variables HDF5_CFLAGS
#and HDF5_LIBS to avoid the need to call pkg-config.
./configure --prefix=$HOME/.local
