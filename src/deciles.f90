program deciles
  use fgsl
  use iso_c_binding

  ! uses linear interpolation, I believe
  
  implicit none
  double precision :: decs(0:10), v(1:1000), inp
  integer::i
  integer (c_size_t) :: n, rejects


  ! input from stdin
  rejects = 0
  n = 0
  do
     read(unit=*, fmt=*, err=999, end=999) inp
     if(isnan(inp)) then
        rejects = rejects +1
     else
        n = n +1
        v(n) = inp
     endif
  end do
999 continue

  ! sort and calculate deciles
  call fgsl_sort(v, 1_fgsl_size_t, n)
  do i=0,10
     decs(i) = fgsl_stats_quantile_from_sorted_data(v, 1_fgsl_size_t, n, dble(i)/dble(10.0))
  enddo

  !print results
  do i = 0,10
     print *, dble(i)/dble(10.), decs(i)
  enddo
  print *, "Number of accepted:", n
  print *, "Number of rejects:", rejects
  
  !print *, "Sorted inputs"
  !do i = 1:n
     

end program deciles
