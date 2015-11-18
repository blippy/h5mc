# -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([h5mc], [0.0], [alt.mcarter@gmail.com])
AC_CONFIG_SRCDIR([src/h5print.c])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE
PKG_PROG_PKG_CONFIG

# Externally set CFLAGS
EXTERNAL_CFLAGS="$CFLAGS"

# Checks for programs.
AC_PROG_CC_C99
AC_PROG_CPP
AC_PROG_RANLIB # Is this necessary?
AC_PROG_FC([gfortran], [Fortran 90])

# Reset the externally set CFLAGS after calling AC_PROG*
CFLAGS="$EXTERNAL_CFLAGS"



# Use the C language and compiler
AC_LANG([C])
#AC_LANG([Fortran])
#AC_FC_SRCEXT([f90])


# Checks for libraries.
PKG_CHECK_MODULES([GSL], [gsl])
PKG_CHECK_MODULES([FGSL], [fgsl])
PKG_CHECK_MODULES([HDF5], [hdf5])


# Checks for header files.
AC_HEADER_STDC
#AC_CHECK_HEADERS([stdio.h])
#AC_CHECK_HEADERS([stdlib.h])


AC_FC_CHECK_BOUNDS()

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_MALLOC

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
AC_FC_LIBRARY_LDFLAGS
AC_FC_MODULE_FLAG


# Wrapping it up
AC_CONFIG_FILES([Makefile
                 src/Makefile])
AC_OUTPUT
