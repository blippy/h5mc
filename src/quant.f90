module quant

contains
  
subroutine calc_rsi(prices, npoints, n, rsi)
  ! appears to be correct
  ! calculate the relative strength
  integer, intent(in) :: npoints
  double precision, intent(in), dimension(npoints):: prices
  integer, intent(in) :: n
  double precision, intent(out), dimension(npoints) ::   rsi

  double precision, dimension(npoints):: deltas
  double precision :: up, down
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

end module quant
