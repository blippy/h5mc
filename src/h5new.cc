#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <string>
#include <assert.h>
#include <algorithm>
#include <sys/stat.h>

#include "hdf5.h"

//#include <mcstats.h>


#include "common.hpp"
#include "common5.hpp"

using std::cout;
using std::endl;
using std::vector;
using std::string;



void write_h5()
{
	char fname[] = "new.h5";

	hid_t fid = H5Fcreate(fname, H5F_ACC_EXCL, H5P_DEFAULT, H5P_DEFAULT);
	hid_t gid = H5Gcreate(fid, "example", H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);

	auto ds = doubles { 6.765, 9.877, 5.732, 4.902, 7.071, 4.668, 0.664, 2.235, 8.897, 7.902};
	write_doubles_h5(gid, "doubles", ds);

	auto strs = strings {"the", "hare", "and", "the", "tortoise"};
	write_strings_h5(gid, "aesop", strs);

	H5Gclose(gid);
	H5Fclose(fid);

}

int main()
{
	write_h5();
	return EXIT_SUCCESS;

}
