AM_CFLAGS = -I$(top_srcdir)/src
AM_FFLAGS1 = $(AM_FFLAGS) $(MARKS_FGSL_CFLAGS) $(FCFLAGS)
#-DPKGVER=\"$(PACKAGE_VERSION)\"

# BUILT_SOURCES = a way of telling automake that some files need to be generated

# Install my_script in $(bindir) and distribute it.
dist_bin_SCRIPTS = h5get

CLEANFILES = *.mod

bin_PROGRAMS = h5ade h5cold h5cut h5gap h5mc deciles rs6

#FMOD_HDF5 = -I$(HOME)/.local/include

common.mod : common.f90
	gfortran -c common.f90

quant.mod : quant.f90
	gfortran -c quant.f90

h5ade_SOURCES = h5ade.f90
h5ade.o : quant.mod h5ade.f90
	gfortran -c h5ade.f90 quant.f90
h5ade$(EXEEXT) : h5ade.o quant.o
	gfortran  -o h5ade quant.o h5ade.o

h5cut$(EXEEXT) : h5cut.f90 
	gfortran $(AM_FFLAGS1) $^ -o $@  $(MARKS_FGSL_LIBS)

h5gap$(EXEEXT) : h5gap.f90
	gfortran $^ -o $@

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

h5cold_LDADD = $(HDF5_LIBS)
h5cold_SOURCES = h5cold.c

h5mc_LDADD = $(HDF5_LIBS)
h5mc_SOURCES = h5print.c
