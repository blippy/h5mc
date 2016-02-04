module yahoo

  use fates

  ! yahoo decade record
  type ydec
     integer :: y, m, d ! year, month, day
     integer :: ymd ! YYYYMMDD
     double precision :: opn, high, low, cls
     integer :: vol
     double precision :: acls ! adjusted close
  end type ydec

  ! collection of yahoo decade records
  !integer, parameter :: maxydecs = 3000 ! max number of yahoo decade records
  !type ydecs     
  !   integer :: n = 0 ! number actually used
  !   type(ydec) :: ys(maxydecs)
  !end type ydecs
  
contains

  !> Read a yahoo file for a decade's worth of data
  !! typical calling:
  !! type(ydec), allocatable :: ydecs(:)
  !! ydecs = read_brwm()
  !! do i = 1, n
  !!    print *, ydecs(i)
  !! enddo
  function read_ydecs(ticker) result(res)
    type(ydec), allocatable :: res(:)

    character*(*) ticker
    character*256 fname
    integer :: y, m, d, i, vol, u, n, stat
    character :: x, hdr(8) ! don't change size of hdr, it slurps the first line
    double precision :: opn, high, low, cls,  adjc

    
    integer, parameter :: dims = 3000
    type(ydec) :: ydecs(dims)
    type(ydec) :: yd

    fname = "/home/mcarter/.fortran/" //  ticker // "/raw.dat"
    !print *, "calling read_ydecs on ticker file:", fname
    open(newunit =u, file = fname, action='read') ! , stream='Stream_LF')
    read (u, *), hdr
    !print *, hdr
    n = 0
    do !i =1,10
       n = n +1
       !if(n.gt.ndims) stop
       read (unit = u, fmt = '(I4,X, I2, X, I2)', iostat = stat, &
            advance = 'no'), y, m, d
!            ydecs(n)%y, ydecs(n)%m ,  ydecs(n)%d
       if(stat /= 0) exit
       read (unit = u, fmt = *), x, opn,  high,  &
            low , cls,  vol,  acls
!       yd%ymd - ymd2i(y, m ,d)
       ydecs(n) = ydec(y, m, d, ymd2i(y, m, d), opn, high, low, cls, vol, acls)
!       print *, y, m, d, opn, high, low, cls, vol, adjc
    enddo
    n = n -1
    close(u)

    allocate(res(1:n))
    res = ydecs(1:n)
    !do i =1,n
    !   print *, res(i)
    !enddo
    !print *, "finished"
  end function read_ydecs

end module yahoo
