#define PRERR(e) print *, 'e', e
program mkepics
  use netcdf

  !use maff
  use datetime_module
  use yahoo
  
  implicit none
  character (len = *), parameter :: FILE_NAME = "/home/mcarter/.fortran/epics.nc"
  integer, parameter :: NVALS =5000 ! number of values
  integer :: ncid, grp_ncid, varid, x_dimid, dimids(1), idx
  integer:: dsi(NVALS), i, status
  double precision:: darr(NVALS)
  type(datetime)  :: dt, dt1
  type(tm_struct) :: tm1
  double precision:: base
  type(ydec), allocatable :: ydecs(:)
  type(ydec) :: y

  character(len=32) :: arg, ticker, ystr, mstr, dstr

  dt = datetime(year = 2004,month = 12,day=31)
  base = date2num(dt)
    
  ! parse arguments
  if(iargc().ge.1) then
     call getarg(1, arg)
     select case (arg)
     case('retr') ! retrieve ticker for a day
        call retr() !targ(), ystr, mstr, dstr)
     case ('impdec')
        !call getarg(2, ticker)
        print *, 'import decade ', ticker , '.'
        !call impdec(trim(ticker))
        call impdec(targ())
     case ('show')
        !call getarg(2, ticker)
        !call show(trim(ticker))
        call show(targ())
     case default
        print *, "unrecognised argument"
     end select
     stop
  endif

  !http://www.unidata.ucar.edu/software/netcdf/netcdf-4/newdocs/netcdf-f90/NF90_005fCREATE.html
  status = nf90_create(FILE_NAME, ior(nf90_noclobber , nf90_hdf5), ncid)
  if(status.eq.nf90_eexist) then
     !call check( nf90_create(FILE_NAME, nf90_netcdf4, ncid) )
  
     !http://www.unidata.ucar.edu/software/netcdf/netcdf-4/newdocs/netcdf-f90/NF90_005fOPEN.html
     call check(nf90_open(FILE_NAME, nf90_write, ncid))
  else
     call check(status)
  endif

  call mkdsi()
  

  !call mkclose("JRS.L")
  !call mkgrp
  print *, 'closing'
  call check( nf90_close(ncid) )

  call prinerrs()
  print *, '*** SUCCESS writing example file ', FILE_NAME, '!'

  
contains

  subroutine show(ticker)
    character(len=*), intent(in) :: ticker
    
    !type(ncepics) :: nc
    !call check( nf90_create(FILE_NAME, nf90_netcdf4, ncid) )
    print *, "called show on ticker: ", ticker, "."
    call check(nf90_open(FILE_NAME, NF90_NOWRITE, ncid))

    call fill_ticker_prices(ticker) ! sets darr   
    call get_dsi() ! sets dsi

    
    call check(nf90_close(ncid))
    
    do i=1,NVALS
       if(darr(i).ne.-1.0d0) write(*, fmt = '(I8,X,F10.3)'), dsi(i), darr(i)
    enddo

  end subroutine show

  ! import decade worth of data
  subroutine impdec(ticker)
    character(len=*), intent(in) :: ticker

    call check(nf90_open(FILE_NAME, nf90_write, ncid))
    call mkclose(ticker)
    call check(nf90_close(ncid))
    
  end subroutine impdec
  
  subroutine mkclose(ticker)
    character(len=*), intent(in) :: ticker
    
    integer :: grp_ncid
    print *, 'calling mkclose'

    call check(nf90_inq_dimid(ncid, "nvals", x_dimid))
    dimids = [x_dimid]
    
    status = nf90_inq_ncid(ncid, ticker, grp_ncid)

    if(status == NF90_ENOGRP) then
       call check(nf90_def_grp(ncid, ticker, grp_ncid))
       call check(nf90_def_var(grp_ncid, "price", NF90_DOUBLE, dimids, varid))
       call check(nf90_enddef(grp_ncid))
    else
       call check(status)
    endif

    call check(nf90_inq_varid(grp_ncid, "price", varid))
    !call check(nf90_put_var(grp_ncid, varid, darr))
    !call check( nf90_def_var(ncid, "BRY.L", NF90_DOUBLE, dimids , varid))
    !call check( nf90_enddef(ncid) )
    ydecs = read_ydecs(ticker)
    darr = -1.0d0
    do i = 1, size(ydecs)
       y = ydecs(i)

       !write( *, fmt = "(I6,I8,X, I4,2I0.2)") , i, idx, y%y, y%m, y%d
       idx = ymd2idx( y%y, y%m, y%d)
       darr(idx) = y%acls
    enddo
    call check( nf90_put_var(grp_ncid, varid, darr) )
    !forall(i=1, size(ydecs)) print *, ydecs(i)
    print *, "Leaving mkclose"
  end subroutine mkclose
  
  subroutine check(status)
    integer, intent ( in) :: status
    
    if(status /= nf90_noerr) then
       print *, 'error code is value is ', status
      print *, trim(nf90_strerror(status))
      call abort
    end if
  end subroutine check


  !> Make nvals and dsi, but only if non-existent
  subroutine mkdsi()
    integer :: y, m, d
    do i = 1, NVALS
       call idx2ymd(i, y, m, d)
       dsi(i) = y * 10000 + m * 100 + d
       !print *, i, dsi(i)
    enddo

    
    status = nf90_inq_dimid(ncid, "nvals", x_dimid)
    if(status == nf90_noerr) then
       dimids = [x_dimid]
       return ! already exists, so just return
    endif
    call check( nf90_def_dim(ncid, "nvals", nvals, x_dimid) )
    dimids = [ x_dimid ]
    print *, 'about to define var'
    call check( nf90_def_var(ncid, "dsi", NF90_INT, dimids , varid))
    
    print *, 'define attribute'
    call check(nf90_put_att(ncid, varid, "units", "date in integer form YYYYMMDD, starting from 20050101"))
    
    print *, 'ending define mode'
    call check( nf90_enddef(ncid) ) ! end define mode



  
  call check( nf90_put_var(ncid, varid, dsi) )
  

  end subroutine mkdsi

  !> print all the error codes
  subroutine prinerrs
    print *, 'error codes'
    PRERR(NF90_ENOGRP)
    PRERR(NF90_NOERR)
    PRERR(NF90_EBADID)
    PRERR(NF90_ENOTNC4)
    PRERR(NF90_ESTRICTNC3)
    PRERR(NF90_EHDFERR)
    
  end subroutine prinerrs

  !> ticker argument (2nd argument)
  function targ()
    character(:), allocatable  :: targ
    character(len=32) :: arg2
    call getarg(2, arg2)
    targ = trim(arg2)
  end function targ

  !> convert argument number argn to an integer
  function arg2int(argn)
    integer :: arg2int
    integer :: argn

    character(len=23) :: str
    call getarg(argn, str)
    read(str, '(i10)') arg2int
  end function arg2int
  
  subroutine retr() !ticker, y, m, d)
    character(len=:), allocatable :: ticker
    integer :: y, m, d

    y = arg2int(3)
    m = arg2int(4)
    d = arg2int(5)
    ticker = targ()
    print *, 'Ticker is:', ticker, '.'
    call check(nf90_open(FILE_NAME, NF90_NOWRITE, ncid))
    !call check(nf90_open(FILE_NAME, NF90_NOWRITE, ncid))
    call get_dsi()
    call fill_ticker_prices(ticker) 
    call check(nf90_close(ncid))

    ! work backwards, bearing in mind that the current entry may be -1
    do idx = ymd2idx(y,m,d), 1, -1
       if(darr(idx).ne.-1) exit          
    enddo

    call idx2ymd(idx, y, m, d) 
    print *, "ticker", ticker, darr(idx), y, m, d
    
    
  end subroutine retr

  !> assumes ncid open
  subroutine get_dsi() ! sets dsi    
    call check(nf90_inq_varid(ncid, "dsi", varid))
    call check(nf90_get_var(ncid, varid, dsi))
  end subroutine get_dsi
  
  !> Fill darr with prices for a ticker. Assumes ncid is open
  subroutine fill_ticker_prices(ticker)
    character(len=*), intent(in) :: ticker
    call check(nf90_inq_ncid(ncid, ticker, grp_ncid))
    call check(nf90_inq_varid(grp_ncid, "price", varid))
    !call check(nf90_inq_varid(nc%ncid, ticker, nc%varid))
    call check(nf90_get_var(grp_ncid, varid, darr))
  end subroutine fill_ticker_prices

  !> Convert a year, month and date into a dsi index
  function ymd2idx(y, m, d) result(idx)
    integer :: y , m , d, idx
    type(datetime) :: dt
    dt = datetime(year = y, month = m, day = d)
    idx = date2num(dt) - base
  end function ymd2idx

  !> convert a dsi index to a year, month and date
  subroutine idx2ymd(idx, y, m, d)
    integer, intent(in) :: idx
    integer, intent(out) :: y, m, d
    type(datetime) :: dt
    type(tm_struct) :: tm
    dt = num2date(idx + base)
    tm = dt%tm()
    y = tm%tm_year + 1900
    m = tm%tm_mon +1
    d = tm%tm_mday
  end subroutine idx2ymd
end program mkepics
