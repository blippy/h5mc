! sort input into buckets of 10
program h5cut
  use fgsl
  use iso_c_binding
  use common ! MAXROWS

  implicit none
  !include "common.f90" ! MAXROWS
  double precision :: decs(MAXROWS), v(MAXROWS), v1(MAXROWS), inp
  integer (c_size_t)::i, stat, bucket
  integer (c_size_t) :: n, rejects,  good, idx(MAXROWS), cut(MAXROWS), inv(MAXROWS)
  double precision, parameter :: nbuckets = 10.0 ! maybe we'll want to generalise
  logical :: mask(MAXROWS)
  double precision :: buckets(10)
  integer :: good4, j

  mask = .false.
  ! input from stdin
  rejects = 0
  n = 0
  do
     read(unit=*, fmt=*, iostat =stat) inp
     if (stat /=0) exit
     !if(isnan(inp)) then
     !   rejects = rejects +1
     !   inp = HUGE(inp) !1.d0/0.d0 ! infinity
     !endif
     n = n +1
     v(n) = inp
     mask(n) = .not.(isnan(v(n)))
  end do
  
  good4 = count(mask)
  good = good4
  !print *, good, good4
  call enmask(v(1:n), mask, v1(1:n), good4)

  call fgsl_sort(v1(1:good), 1_fgsl_size_t, good)

  ! create buckets
  do i = 1, 10
     j = ceiling( dble(i)* dble(good4)/nbuckets)
     !print *, j
     !call flush(5)
     buckets(i) = v1(j)
  enddo
  !idx = idx +1

  ! print buckets
  do i = 1, n
     if (isnan(v(i))) then
        bucket = -1
     else
        do j =1, 10
           bucket = j
           if(buckets(j).gt.v(i)) exit
        enddo
     endif
     write(*, '(A,I02.2)') 'D', bucket
  enddo
  ! invert the lookup
  !do i = 1,n
  !   inv(idx(i)) = i
  !enddo

  !good = count(
  !do i = 1,n
  !   !print *, i, inv(i), v(inv(i))
  !   bucket = ceiling( dble(inv(i))* nbuckets/ dble(good))
  !   if (v(i).eq.HUGE(v(i))) bucket = -1 ! undefined
  !   !write(*, '(A,I02.2)') 'D', bucket
  !   print *, bucket
  !enddo

  !do i = 1,n
  !   print *, cut(i)
  !enddo

  ! write deciles to file for future reference
  open(unit= 24, file = 'decile.txt', action = 'write')
  write(unit=24, fmt = '(A, I02.2, F12.4)') 'D' , 0, v1(1) ! min val
  do i = 1, 10
     write(unit=24, fmt = '(A, I02.2, F12.4)') 'D' , i, buckets(i)
  enddo
  close(24)
  
contains

  ! FIXME promote to re-usable
  subroutine enmask(arr, mask, dest, n)
    double precision, intent(in):: arr(:)
    logical, intent(in) :: mask(:)
    double precision, intent(out) :: dest(:)
    integer, intent(out) :: n
    
    integer :: i
    
    n = 0
    do i = 1, size(arr)
       if(mask(i))then
          n = n + 1
          dest(n) = arr(i)
       endif
    enddo
    
  end subroutine enmask
  
end program h5cut
