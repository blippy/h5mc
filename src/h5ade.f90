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

  double precision, dimension(mrows) :: sma50
  

!!! inputs
  open(unit=11, file = "raw.dat", action = 'read')
  read(unit=11,fmt =*), dummy
  n = 0
  do
     n = n+1
     read(unit=11, fmt=*, end=115) dstamp(n), opn(n), high(n), low(n), clse(n), vol(n), adjclose(n)
     !print *, n, " dstamp=", dstamp(n), ", adjclose=", adjclose(n)
  enddo
115 continue
  n = n -1
  close(11)

!!! process
  call calc_sma(adjclose, n, 50, sma50)
  
!!! output
  print *, n
  open(unit=12, file = "sma50.dat", action = "write")
  write(unit=12, fmt=*) "Date,sma50"
  do i=1,n
     write(unit=12, fmt='(A,A,F0.2)'), dstamp(i), ',', sma50(i)
  enddo
  close(12)
  print *, "produced file sma50.dat for file raw.dat"
  print *, "NB rsi14 is untested"
  print *, "Version: 0.1"
end program h5ade
