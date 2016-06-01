#AM_YFLAGS = -d
#AM_CFLAGS = -I$(top_srcdir)/src
#AM_FFLAGS1 = $(AM_FFLAGS) $(MARKS_FGSL_CFLAGS) $(FCFLAGS)
#-DPKGVER=\"$(PACKAGE_VERSION)\"

#NC_FFLAGS = $(shell nc-config --fflags)
#NC_FLIBS = $(shell nc-config --flibs)

# BUILT_SOURCES = a way of telling automake that some files need to be generated
#BUILT_SOURCES = shsl.tab.h
# Install my_script in $(bindir) and distribute it.
#dist_bin_SCRIPTS = h5get

#CLEANFILES = *.mod lex.yy.c shsl.tab.cc shsl.tab.c shsl.tab.h

STD = -fcheck=all -ggdb

#bin_PROGRAMS = 
#bin_PROGRAMS = h5ade h5gap 
# disabled h5plot from building - it requires a package
#bin_PROGRAMS += h5plot
#bin_PROGRAMS += h5cut deciles mkepics rs6 fatest
bin_PROGRAMS = shsl h5new h5rank

h5new_LDADD = -lhdf5
h5new_SOURCES = h5new.cc common.cc

h5rank_LDADD = -lhdf5 -lcxxstats
h5rank_SOURCES = h5rank.cc common.cc

# old programs h5cold h5mc

#shsl_SOURCES = shsl.cc shsl.tab.c lex.yy.c common.cc
shsl_LDADD = -lhdf5
shsl_SOURCES = shsl.cc common.cc

#shsl.tab.cc shsl.tab.h : shsl.y 
#	bison -d $^ -output shsl.tab.cc


#shsl : shsl.c shsl.tab.c lex.yy.c common.o
#	g++  -std=gnu++11  -ggdb $^ -lhdf5 -o $@

#h5new : h5new.cc common.o 
#	g++  -std=gnu++11  $^ -lhdf5 -o $@

#lex.yy.c : shsl.l shsl.tab.h
#	flex shsl.l

#shsll : lex.yy.c
#	g++ -std=gnu++11 -Dmain_lex=main lex.yy.c -o $@

#yahoo.o : yahoo.f90 fates.o
#	gfortran -c $(STD) $< -o $@

#common.o : common.cc
#	g++ -std=gnu++11 -c $<

#h5ade_SOURCES = h5ade.f90
#h5ade.o : h5ade.f90 quant.o
#	gfortran -c $(STD) $< -o $@
#h5ade$(EXEEXT) : h5ade.o quant.o
#	gfortran  $(STD) $^ -o $@

#h5cut$(EXEEXT) : h5cut.f90 common.o
#	gfortran $(AM_FFLAGS1) $^ -o $@  $(MARKS_FGSL_LIBS)

#h5gap$(EXEEXT) : h5gap.f90
#	gfortran $^ -o $@

#h5plot$(EXEEXT) : h5plot.f90
#	gfortran $(PLPLOT_CFLAGS)  $^ -o $@ $(PLPLOT_LIBS)

# do I need deciles anymore?
#deciles_SOURCES = deciles.f90
#deciles.o : deciles.f90
#	gfortran $(AM_FFLAGS1) -c deciles.f90
#deciles$(EXEEXT) : deciles.o
#	gfortran -o deciles deciles.o $(MARKS_FGSL_LIBS)

#rs6.o : rs6.f90
#	gfortran $(AM_FFLAGS1) -c rs6.f90 
#rs6$(EXEEXT): rs6.o
#	gfortran -o rs6 rs6.o $(MARKS_FGSL_LIBS)
#rs6_LDADD = $(MARKS_FGSL_LIBS)
#rs6_SOURCES = rs6.f90

#h5cold_LDADD = $(HDF5_LIBS)
#h5cold_SOURCES = h5cold.c


#mkepics_SOURCES = mkepics.f90 fates.f90 yahoo.f90

#mkepics.o : mkepics.f90  fates.o yahoo.o
#	gfortran -c $(STD)  $(DT_CFLAGS) $(NC_FFLAGS) -cpp $< -o $@

#mkepics$(EXEXT) : mkepics.o yahoo.o
#	gfortran $(NC_FFLAGS) -o $@  $^  $(DT_LIBS) $(NC_FLIBS)



#fatest$(EXEEXT) : fatest.o fates.o
#	gfortran  $^ -o $@

