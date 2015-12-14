! useful for calculating the gap in rs1y and rs6m
! Input in order rs1y rs6m
program h5gap
  implicit none
  double precision :: a, b
  integer :: stat

  do
     !read(unit=*, iostat = stat) a, b
     read (*, *, iostat = stat) , a,b
     if (stat /=0) exit
     print *, (a-b)/(1.0 +b/100.0)
     !exit
  enddo
 
end program h5gap
