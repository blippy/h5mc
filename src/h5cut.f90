! sort input into buckets of 10
program h5cut
  use fgsl
  use iso_c_binding
  use common

  implicit none
  !include "common.f90" ! MAXROWS
  double precision :: decs(MAXROWS), v(MAXROWS), inp
  integer::i, stat, bucket
  integer (c_size_t) :: n, rejects, good, idx(MAXROWS), cut(MAXROWS), inv(MAXROWS)
  double precision, parameter :: nbuckets = 10.0 ! maybe we'll want to generalise


  ! input from stdin
  rejects = 0
  n = 0
  do
     read(unit=*, fmt=*, iostat =stat) inp
     if (stat /=0) exit
     if(isnan(inp)) then
        rejects = rejects +1
        inp = HUGE(inp) !1.d0/0.d0 ! infinity
     endif
     n = n +1
     v(n) = inp
  end do
  good = n - rejects

  call fgsl_sort_index(idx, v, 1_fgsl_size_t, n)
  idx = idx +1

  ! invert the lookup
  do i = 1,n
     inv(idx(i)) = i
  enddo
  
  do i = 1,n
     !print *, i, inv(i), v(inv(i))
     bucket = ceiling( dble(inv(i))* nbuckets/ dble(good))
     if (v(i).eq.HUGE(v(i))) then !bucket = -1 ! undefined
        print *, -1
     else
        print *, bucket
     endif
     !cut(idx(i)) = bucket
  enddo

  !do i = 1,n
  !   print *, cut(i)
  !enddo
  
end program h5cut
