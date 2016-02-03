# -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([h5mc], [0.1], [alt.mcarter@gmail.com])
AC_CONFIG_SRCDIR([src/h5print.c])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([foreign])
PKG_PROG_PKG_CONFIG
AC_MSG_NOTICE([Let's rock and roll])

# Externally set CFLAGS
EXTERNAL_CFLAGS="$CFLAGS"

#AC_CHECK_FILE([/usr/local/lib/fortran/modules/plplot/plplot.mod],
#	AC_SUBST([PLOT1], [-I/usr/local/lib/fortran/modules/plplot]))

#AC_MSG_NOTICE([Fortran messy HDF5 checking])
#AX_LIB_HDF5()

# Checks for programs.
#AC_PROG_LIBTOOL
#AC_PROG_CC_C99
#AC_PROG_CPP
#AC_PROG_RANLIB # Is this necessary?
AC_PROG_FC([gfortran], [Fortran 90])

# Reset the externally set CFLAGS after calling AC_PROG*
CFLAGS="$EXTERNAL_CFLAGS"


# Use the C language and compiler
#AC_LANG([C])
#AC_LANG([Fortran])
#AC_FC_SRCEXT([f90])


# Checks for libraries.
PKG_CHECK_MODULES([DT], [datetime-fortran])
PKG_CHECK_MODULES([GSL], [gsl])
PKG_CHECK_MODULES([MARKS_FGSL], [fgsl]) # sets $MARKS_FGSL_CFLAGS $MARKS_FGSL_LIBS
#PKG_CHECK_MODULES([HDF5], [hdf5])
PKG_CHECK_MODULES([PLPLOT], [plplot-f95])
AC_MSG_NOTICE([Marks FGSL $MARKS_FGSL_CFLAGS])

AC_PROG_FC([gfortran], [Fortran 90])

# Checks for header files.
AC_HEADER_STDC
#AC_CHECK_HEADERS([stdio.h])
#AC_CHECK_HEADERS([stdlib.h])


AC_FC_CHECK_BOUNDS() # sets FCFLAGS

# Checks for typedefs, structures, and compiler characteristics.
#AC_TYPE_SIZE_T

# Checks for library functions.
#AC_FUNC_MALLOC

# Add debug support
AC_ARG_ENABLE(debug,
   AS_HELP_STRING(
     [--enable-debug],
     [enable debugging, default: no]),
     [case "${enableval}" in
       yes) debug=true ;;
       no)  debug=false ;;
       *)   AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
      esac],
      [debug=false])
AM_CONDITIONAL(DEBUG, test x"$debug" = x"true")
AM_COND_IF(DEBUG,
    AC_DEFINE(DEBUG, 1, [Define to 0 if this is a release build]),
    AC_DEFINE(DEBUG, 0, [Define to 1 or higher if this is a debug build]))
                                                

# Fortran stuff
AC_LANG([Fortran])
AC_FC_SRCEXT([f90])
# FIXME take a look at the AC_FC_MODULE_FLAG for possible inclusion
#AM_FCFLAGS = -I/usr/include/fgsl
#PKG_CHECK_MODULES([HDF5], [hdf5])
AC_FC_LIBRARY_LDFLAGS
AC_FC_MODULE_FLAG
#AC_SEARCH_LIBS([h5open_f], [hdf5_fortran],
#   [echo "Found HDF5 Fortran library"],
#   [echo "Did not find HDF5 Fortran library"])
AX_LIB_HDF5() # http://www.gnu.org/software/autoconf-archive/ax_lib_hdf5.html
AC_MSG_NOTICE([Hello world])
#if test "$with_hdf5" = "yes"; then
#   AC_MSG_RESULT([HDF5 found])
#else
#   AC_MSG_ERROR([HDF5 unfound])
#fi   

# Wrapping it up
AC_CONFIG_FILES([Makefile scripts/Makefile src/Makefile])
AC_OUTPUT
