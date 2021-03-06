program rs6
  use fgsl
  use iso_c_binding
  implicit none

  integer, parameter:: mrows = 1000
  double precision, dimension(mrows) :: rs6mb
  double precision::  decs(0:10), inp, pcile
  integer (c_size_t) :: i, n, idx(mrows), count
  character (len=10) :: epic(mrows)
  character(len=30) :: date



!!! INPUTS

  open(unit=11, file='_count', action = 'read')
  read(unit=11, fmt='(I5)'), count
  close(11)


  open(unit=11, file='epic', action= 'read')
  read (unit=11, fmt='(A4)') , epic(1:count)
  close(11)
  
  open(unit = 11, file = 'rs6mb', action = 'read')
  read(unit = 11, fmt = *) rs6mb(1:count) ! read even the Nans
  close(11)
  

!!! CLEAN

  n = 0
  do i=1,count
     if(.not.isnan(rs6mb(i))) then
        n = n + 1
        epic(n) = epic(i)
        rs6mb(n) = rs6mb(i)
     endif
  enddo

  
!!! PROCESS

  call fgsl_sort_index(idx, rs6mb, 1_fgsl_size_t, n)
  idx = idx +1
  call fgsl_sort(rs6mb, 1_fgsl_size_t, n)

!!! OUTPUT

  print *, "Version: 0.4"
  
  ! print percentiles
  print *, "rs6mb ordered in percentiles"
  write (*,fmt='(A1,x,A7,x,A5,x,A7)'), "H", "pcile", "epic", "rs6mb"
  !call fgsl_sort_index(idx, rs6mb, 1_fgsl_size_t, n)
  do i=1,n
     pcile = dble(100*(i-1))/dble(n)
     write(*,fmt='(A1, x, f7.2, 1x, A5, f7.2)') , '1', pcile, epic(idx(i)), &
          & rs6mb(i)
  enddo
  
  ! decile summary
  do i=0,10
     pcile = dble(i)/dble(10.0)
     print *,  pcile,  fgsl_stats_quantile_from_sorted_data(rs6mb, 1_fgsl_size_t, n, pcile)
  enddo


  print *, "Good inputs:  ", n
  print *, "Bad inputs:   ", count - n
  print *, "Total inputs: ", count
 
  call fdate(date)
  print *, "Generated by rs6 from h5mc git on ", date
  print *, "Try doing:"
  print *, "rs6>calcs/rs6mb.rs6"
end program rs6
