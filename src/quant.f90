module quant
  implicit none
  public :: sstddev
contains
  
subroutine calc_rsi(prices, npoints, n, rsi)
  ! appears to be correct
  ! calculate the relative strength
  integer, intent(in) :: npoints
  double precision, intent(in), dimension(npoints):: prices
  integer, intent(in) :: n
  double precision, intent(out), dimension(npoints) ::   rsi

  double precision, dimension(npoints):: deltas
  double precision :: up, down, rs
  integer::  i


  do i=1, npoints-1
     deltas(i) = prices(i+1) - prices(i)
  enddo

  up = 0
  down = 0
  do i = 1, min(n+1, npoints) ! default should be n+1
     up = up + dmax1(0., deltas(i))/n
     down = down + max(0., -deltas(i))/n
  enddo
  rs = up/down
  rsi = 0
  rsi(1:n) = 100.0 * rs/(1.0+rs)

  do i=n,npoints
     up = (up *(n -1.0) + max(0., deltas(i-1)))/n
     down = (down*(n-1.0) + max(0., -deltas(i-1)))/n
     rs = up/down
     rsi(i) = 100.0 * rs/(1.0+rs)
  enddo
end subroutine calc_rsi


subroutine calc_sma(prices, npoints, n, sma)
  !looks good
  ! calculate a simple moving average
  integer, intent(in) :: npoints
  double precision, intent(in), dimension(npoints):: prices
  integer, intent(in) :: n
  double precision, intent(out), dimension(npoints) ::  sma

  integer::  i, i0

  do i= 1, npoints
     i0 = max(1, 1+ i -n) ! cope with beginning points
     sma(i) = sum(prices(i0:i))/dble(i - i0+1)
  end do
end subroutine

function sstddev(arr,n, mask)
  ! calculate the sample std deviation
  ! TODO test
  implicit none
  double precision :: sstddev
  integer :: i, n
  double precision, dimension(n) :: arr
  logical, optional, dimension(n) :: mask
  logical :: accept

  double precision :: sx, sxx, npoints

  npoints = 0.d0
  sx = 0.d0
  sxx = 0.d0
  do i = 1,n
     if (present(mask)) then
        accept = mask(i)
     else
        accept = .true.
     endif

     if(accept) then
        npoints = npoints + 1.d0
        sx = sx + arr(i)
        sxx = sxx + arr(i) * arr(i)
     endif
  enddo

  sstddev = sqrt(( npoints * sxx - sx * sx)/n/(n-1.d0))
  return
end function sstddev
end module quant
