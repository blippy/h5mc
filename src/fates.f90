module fates
  implicit none
contains

function ymd2i(y, m, d)
  integer:: y, m, d, ymd2i
  ymd2i = y * 10000 + m * 100 + d
end function

end module        
