program h5plot
  use plplot
  implicit none
  integer, parameter :: dp=kind(0.0d0)
  real(kind=plflt), dimension(3):: x, y, ctimes
  real(kind=plflt) :: xlabel_step, scale, offset1, offset2, xmin, xmax
  real(kind=plflt), parameter :: dp0=0.0_dp
  character (len=10) :: dstamps(3), dstamp
  integer(kind=plint) :: yr,m,d
  integer :: i
  character(:), allocatable :: driver, ofname

  scale = 365.242198781_plflt
  offset1 = -678940.0_plflt
  offset2 = -0.3641639_plflt
  call plconfigtime(scale, offset1, offset2, 0, 0, 0, 0, 0, 0,  0, 0._plflt)
  !call plconfigtime(1.0_dp/86400.0, 0.0_dp, 0.0_dp, 0, 1, 1970, 0, 1, 0, 0, 0.0_plflt)
  !call plconfigtime(0.0_dp,0.0_plflt,0.0_plflt,0,0,0,0,0,0,0,0.0_plflt)
  !call plconfigtime(1.0_plflt, dp0, dp0, 0, 1, 0, 0, 0, 0,  0, 0._plflt)


  
  dstamps = [ "2013-08-01", "2014-01-01", "2015-12-20"]

  print *, "Calculating times"
  do i=1,3
     dstamp = dstamps(i)
     read(dstamp(1:4), fmt=*) yr
     read(dstamp(6:7), fmt=*) m
     read(dstamp(8:10), fmt =*) d
     call plctime(yr,m-1,d,0_plint,0_plint,0.0_dp, ctimes(i))
     !ctimes(i) = 

  enddo
  print *, ctimes
  
  
  x = [1,2,3]
  y = [1, 4, 9]


  
  ! originally
  driver = 'pngqt'
  ofname = 'myplot.png'

  ! possibly works better under cubie
  driver = 'psc'
  ofname = 'myplot.ps'

  print *, 'output will go to file ', ofname
  !call plsdev('pngqt')
  call plsdev(driver)
  call plsfnam(ofname)
  
  call plinit()
  call pladv(0)
  call plctime(2013,0,2,0_plint,0_plint,dp0, xmin)
  call plctime(2016,0,2,0_plint,0_plint,dp0, xmax)
  !call plenv(xmin, xmax,1.0_dp, 9.0_dp, 0, 0)


  call plvsta()

  call plwind(xmin, xmax, 0.0_dp, 10.0_dp)
  call pllab("Date", "Y-Values", "my fancy plot")
  
  call pltimefmt('%Y%n%m-%d')
  call plctime(1,0,0,0,0,0.0_dp, xlabel_step)
  call plbox('bcdnst',xlabel_step, 12, 'bcgmnstv', 0.0_plflt, 2)
  !call plbox('bcdnst', 0.0_plflt, 12, 'bcgnstv', 0.0_plflt, 0)
  
  call plcol0(9) ! blue
  call plline(ctimes, y)
  call plend()


end program h5plot
