program h5ade
  !use fgsl
  !use iso_c_binding
  use quant ! FIXME now use this to calculate rsi
  implicit none

  integer, parameter:: mrows = 3000
  double precision, dimension(mrows) :: opn, high, low, clse, vol, adjclose
  double precision::  decs(0:10), inp, pcile
  integer  :: i, n, idx(mrows), count
  character (len=10) :: epic(mrows)
  character(len=30) :: date
  character (len=80) :: dummy
  character (len=10) :: dstamp(mrows)

  double precision, dimension(mrows) :: rsi14
  

!!! inputs
  open(unit=11, file = "/home/mcarter/.fortran/DPLM.L", action = 'read')
  read(unit=11,fmt =*), dummy
  n = 0
  do
     n = n+1
     read(unit=11, fmt=*, end=115) dstamp(n), opn(n), high(n), low(n), clse(n), vol(n), adjclose(n)
     print *, n, " dstamp=", dstamp(n), ", adjclose=", adjclose(n)
  enddo
115 continue
  n = n -1
  close(11)

!!! process
  call calc_rsi(adjclose, n, 14, rsi14)
  
!!! output
  print *, n
  print *, rsi14(1:n)
  print *, "unchecked"
end program h5ade
