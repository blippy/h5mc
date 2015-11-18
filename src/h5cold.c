/*
  Extract a column of doubles from HDF
  See h5print for obtaining strings


  Quite possibly not all resources have been cleaned up
*/

#include <assert.h>
#include "hdf5.h"
#include <stdio.h>
#include <stdlib.h>

//#define FILE            "/home/mcarter/cubie/home/mcarter/data/sharelock.h5"
//#define DATASET         "D20151113/PFCF"
#define DIM0            32
#define DIM1            64
#define CHUNK0          4
#define CHUNK1          8

//#define CHECK(x) { if(x<0) {H5Eprint(stdout); exit(1);} ; };
#define CHECK(x) { x; }

void read_dates(hid_t fid);

int main (int argc, char **argv)
{
    hid_t           file, space, dset, dcpl;    /* Handles */
    herr_t          status;
    htri_t          avail;
    H5Z_filter_t    filter_type;
    hsize_t         dims[2] = {DIM0, DIM1},
                    chunk[2] = {CHUNK0, CHUNK1};
    size_t          nelmts;
    unsigned int    flags,
                    filter_info;
    int             i, j;
    float rdata[DIM0][DIM1];

    assert(argc>2);
    char *filename = argv[1];
    char *dsetname = argv[2];
    //puts(filename);
    //puts(dsetname);

    file = H5Fopen (filename, H5F_ACC_RDONLY, H5P_DEFAULT);
    dset = H5Dopen (file, dsetname, H5P_DEFAULT);
    
    space = H5Dget_space(dset);
    //printf("Sizeof float is %d\n", sizeof(float));

    nelmts = H5Sget_simple_extent_npoints(space);
    //printf("Number of elements: %ld\n", nelmts);

    status = H5Dread (dset, H5T_NATIVE_FLOAT, H5S_ALL, H5S_ALL, H5P_DEFAULT, // me added FLOAT
                rdata[0]);


    // print the data -- not very elegent
    for (i=0; i<DIM0; i++)
        for (j=0; j<DIM1; j++)
	  {	    
	    printf("%f\n", rdata[i][j]);
	    if (--nelmts == 0) {goto bored;}
	  }
 bored:

  

    CHECK(H5Sclose(space));
    //CHECK(H5Pclose(dcpl));
    CHECK(H5Dclose(dset));
    CHECK(H5Fclose(file));
    //H5Eclear1();
    
    return 0;
}
