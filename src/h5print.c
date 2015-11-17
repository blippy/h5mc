/*
  Example of reading data in HDF
  Compile using:
  gcc h5print.c -lhdf5 

  Dataset is available in UUENCODED format at:
  https://gist.github.com/blippy/82c23d1d0cdb932a4c29

  Quite possibly not all resources have been cleaned up
*/

#include <assert.h>
#include "hdf5.h"
#include <stdio.h>
#include <stdlib.h>

#define FILE            "/home/mcarter/cubie/home/mcarter/data/sharelock.h5"
#define DATASET         "D20151113/PER"
#define DIM0            32
#define DIM1            64
#define CHUNK0          4
#define CHUNK1          8

//#define CHECK(x) { if(x<0) {H5Eprint(stdout); exit(1);} ; };
#define CHECK(x) { x; }

void read_dates(hid_t fid);

int
main (void)
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
    

    //H5Eset_auto(NULL, NULL); // turn off auto error handling, which may not be a good idea

    /*
     * Open file and dataset using the default properties.
     */
    file = H5Fopen (FILE, H5F_ACC_RDONLY, H5P_DEFAULT);
    dset = H5Dopen (file, DATASET, H5P_DEFAULT);

    /*
     * Retrieve dataset creation property list.
     */
    dcpl = H5Dget_create_plist (dset);


    
    space = H5Dget_space(dset);
    printf("Sizeof float is %d\n", sizeof(float));

    nelmts = H5Sget_simple_extent_npoints(space);
    printf("Number of elements: %ld\n", nelmts);
    /*
     * Read the data using the default properties.
     */
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

    read_dates(file);

    CHECK(H5Sclose(space));
    CHECK(H5Pclose(dcpl));
    CHECK(H5Dclose(dset));
    CHECK(H5Fclose(file));
    //H5Eclear1();
    
    return 0;
}

void read_dates(hid_t fid)
{
  hid_t dset = H5Dopen(fid, "/D20151113/epic", H5P_DEFAULT);
  {
    hid_t space = H5Dget_space(dset);

    int rank = H5Sget_simple_extent_ndims(space);
    hsize_t npoints = H5Sget_simple_extent_npoints(space);
    printf("epic ndims=%d, npoints = %d\n", rank, npoints);
    
    hsize_t dims[2], mdims[2];
    herr_t status = H5Sget_simple_extent_dims(space, dims, mdims);
    printf("Dims: %lu (meaningless? %lu)\n", dims[0], dims[1]);
    printf("Max dims: %lu (meaningless? %lu)\n", mdims[0], mdims[1]);

    

    hid_t did = H5Dget_type(dset);
    size_t size = H5Tget_size(did);
    printf("size of each array is is %zu\n", size);
    hid_t htype = H5Tget_native_type(did, H5T_DIR_ASCEND);
    printf("type is %lu\n", htype);
    printf("type H5T_NATIVE_CHAR is %zu\n", H5T_NATIVE_CHAR);
    printf("type H5T_NATIVE_SCHAR is %lu\n", H5T_NATIVE_SCHAR);
    printf("type H5T_NATIVE_UCHAR is %lu\n", H5T_NATIVE_UCHAR);
    printf("type H5T_NATIVE_SHORT is %lu\n", H5T_NATIVE_SHORT);
    printf("type H5T_NATIVE_USHORT is %zu\n", H5T_NATIVE_USHORT);
    printf("type H5T_NATIVE_B8 is %lu\n", H5T_NATIVE_B8);
    printf("type H5T_NATIVE_INT8 is %zu\n", H5T_NATIVE_INT8);
    printf("type H5T_STRING is %zu\n", H5T_STRING);

    H5T_class_t cid = H5Tget_class(did);
    printf("Class number is: %zu\n", cid);
    printf("String class is type %zu\n", H5T_STRING);
    printf("Array class is type %zu\n", H5T_ARRAY);

      
    char *data = malloc(size*npoints);
    assert(data);
    status = H5Dread(dset, htype, H5S_ALL, H5S_ALL, H5P_DEFAULT, data);
    int i, j;
    for(i=0; i<npoints; i++){
      for(j=0; j<size; j++) {
        char c = data[i*size +j];
        if(c != 0) {printf("%c", c);}
        //      if (0 == data[i]) {puts("");}
      }
      puts("");
    }
    puts("");
    
    H5Sclose(space);
  }
  H5Dclose(dset);
}
