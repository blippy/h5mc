AM_CFLAGS = -I$(top_srcdir)/src
AM_FFLAGS1 = $(AM_FFLAGS) $(MARKS_FGSL_CFLAGS) $(FCFLAGS)
#-DPKGVER=\"$(PACKAGE_VERSION)\"

# BUILT_SOURCES = a way of telling automake that some files need to be generated


bin_PROGRAMS = h5cold h5mc deciles rs6

#FMOD_HDF5 = -I$(HOME)/.local/include

# do I need deciles anymore?
deciles_SOURCES = deciles.f90
deciles.o : deciles.f90
	gfortran $(AM_FFLAGS1) -c deciles.f90
deciles$(EXEEXT) : deciles.o
	gfortran -o deciles deciles.o $(MARKS_FGSL_LIBS)

rs6.o : rs6.f90
	gfortran $(AM_FFLAGS1) -c rs6.f90 
rs6$(EXEEXT): rs6.o
	gfortran -o rs6 rs6.o $(MARKS_FGSL_LIBS)
#rs6_LDADD = $(MARKS_FGSL_LIBS)
#rs6_SOURCES = rs6.f90

h5cold_LDADD = -lhdf5
h5cold_SOURCES = h5cold.c

h5mc_LDADD = -lhdf5
h5mc_SOURCES = h5print.c
