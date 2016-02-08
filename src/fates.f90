module fates
! For bindings, see https://www.mpp.mpg.de/~huber/util/main/cvdate.F90

  use, intrinsic :: iso_c_binding, only : C_INT, C_PTR, c_loc , c_int64_t ! C_CHAR, C_NULL_CHAR

  implicit none
contains


!interface
integer(c_int64_t) function mktime(tm) bind(c, name ="mktime") !result(t)
!   type(c_ptr), value :: tm
   integer(c_int), target :: tm(9)
   !type(c_ptr), 
!   t = c_f_pointer(
end function
!end interface

function ymd2i(y, m, d)
  integer:: y, m, d, ymd2i
  ymd2i = y * 10000 + m * 100 + d
end function

subroutine test_fates
!  THIS ACTUALLY DOESN'T WORk
! ACTUALLY - I SEEM TO GET SOMETHING WITH using c_int64_t
!  integer, target :: tm(9)
  integer(c_int) :: tm(9), tm1(9)
  type(c_ptr):: ptm
  integer(c_int64_t) :: base
  character(len=30) :: dstr
!         s[0,60] m[0,29], h[0,23] d[1,31] m[0,11] y(-1900) wd[0,6] yd[0, 365]
!         dlt          
  tm = [ 0, 0, 0, 31, 12-1, 2004 - 1900, 0, 0, 0]
  !ptm = c_loc(tm(1))
  base = mktime(tm)
  print *, base
  call ctime(base, dstr)
  !call ltime(base, tm1)
  print *, dstr
!  do i = 1, 100
    !86400 seconds in a day
end subroutine

end module        
