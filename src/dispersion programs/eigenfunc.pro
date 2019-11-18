FUNCTION eigenfunc, A, Eval

  ON_ERROR, 2
  
  Evec = DCOMPLEXARR(2, 2)
  for j = 0, 1 do begin                   ;j th evec
      evec(0,j) = A(0,1)
      evec(1,j) = eval(j) - A(0,0)
      n = norm(evec(*,j), /double)
      evec(*,j) /= n
  endfor
  
  return, evec

end
