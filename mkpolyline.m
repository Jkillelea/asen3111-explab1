function y = mkpolyline(x, p)
  % fills out a vector y based on the polynomials in p and the positions in x
  % basically used to compute the actual values of a fit line given by `polyfit`
  y = zeros(length(x), 1);

  for i = 1:length(x)
    x_i = x(i);
    tmp = 0;
    N = length(p);
    for j = 1:N
      tmp = tmp + p(j)*x_i^(N-j);
    end
    y(i) = tmp;
  end
end
