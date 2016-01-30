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
  !character :: ticker(10)

  !type ncepics ! stuff for ncepics file
  !   integer :: ncid, varid, x_dimid, dimids(1), idx
  !   integer :: dsi(NVALS)
  !   double precision :: darr(NVALS)
  !   integer :: status
  !end type ncepics

  type(datetime)  :: dt, dt1
  type(tm_struct) :: tm1
  double precision:: base
  type(ydec), allocatable :: ydecs(:)
  type(ydec) :: y

  character(len=32) :: arg, ticker

  dt = datetime(year = 2004,month = 12,day=31)
  base = date2num(dt)
    
  ! parse arguments
  if(iargc().ge.1) then
     call getarg(1, arg)
     select case (arg)
     case ('impdec')
        call getarg(2, ticker)
        !ticker = trim(ticker)
        print *, 'import decade ', ticker , '.'
        call impdec(trim(ticker))
        !print *, 'TODO'
     case ('show')
        print *, "arg is: ", arg
        call getarg(2, ticker)
        call show(trim(ticker))
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
  

  call mkclose("JRS.L")
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
    print *, "calling show on ticker: ", ticker, "."
    call check(nf90_open(FILE_NAME, NF90_NOWRITE, ncid))

    call check(nf90_inq_ncid(ncid, ticker, grp_ncid))
    call check(nf90_inq_varid(grp_ncid, "price", varid))
    !call check(nf90_inq_varid(nc%ncid, ticker, nc%varid))
    call check(nf90_get_var(grp_ncid, varid, darr))

    call check(nf90_inq_varid(ncid, "dsi", varid))
    call check(nf90_get_var(ncid, varid, dsi))
    
    call check(nf90_close(ncid))
    
    do i=1,NVALS
       if(darr(i).ne.-1.0d0) write(*, fmt = '(I8,X,F10.3)'), dsi(i), darr(i)
    enddo

  end subroutine show

  ! import decade worth of data
  subroutine impdec(ticker)
    character(len=*), intent(in) :: ticker ! TODO ANNOTATE THIS
    print *, 'TODO. import ticker: ', ticker, '.'

    !print 
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
    print *, NF90_EBADID
    print *, NF90_ENOTNC4
    print *, NF90_ESTRICTNC3
    print *, NF90_EHDFERR
    !if(status == nf90
    !call check(status)
    if(status == -125) then ! doesn't exist, so create ! TODO replace by symbolic error, rather than '-125'
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
       dt = datetime(year = y%y, month = y%m, day = y%d)
       idx = date2num(dt) - base
       !write( *, fmt = "(I6,I8,X, I4,2I0.2)") , i, idx, y%y, y%m, y%d
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
      !stop 2
      call abort ! TODO in gfortran this produces a backtrace. VERY USEFUL TO ANNOTATE!
    end if
  end subroutine check


  !> Make nvals and dsi, but only if non-existent
  subroutine mkdsi()

    ! create dates

    do i = 1, NVALS
     
       !ndays = 
       dt1 = num2date(base + dble(i))
       !print *, dt1%isoformat()
       tm1 = dt1%tm()
       dsi(i) = (tm1%tm_year + 1900) * 10000 + (tm1%tm_mon +1) * 100 + tm1%tm_mday
       !print *, i, dsi(i)
       !print *, dsi
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
    print *, 'NF90_NOERR ', NF90_NOERR
    print *, 'NF90_NOERR ', NF90_NOERR
  end subroutine prinerrs
    
end program mkepics
