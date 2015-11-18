AM_CFLAGS = -I$(top_srcdir)/src


bin_PROGRAMS = h5cold h5mc deciles

# total hack on the location of fgsl.mod
#deciles_FFLAGS = -I/usr/include/fgsl
#deciles_FLIBS = -lfgsl -lgsl -lm
#deciles_LDADD = fgsl.mod $(FLIBS)
deciles_SOURCES = deciles.f90
deciles.o : deciles.f90
	gfortran -I/usr/include/fgsl -fcheck=bounds -c deciles.f90
deciles$(EXEEXT) : deciles.o
	gfortran -o deciles deciles.o -lfgsl -lgsl -lm

h5cold_LDADD = -lhdf5
h5cold_SOURCES = h5cold.c

h5mc_LDADD = -lhdf5
h5mc_SOURCES = h5print.c
