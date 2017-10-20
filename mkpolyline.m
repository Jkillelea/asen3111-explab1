function y = mkpolyline(x, p)
  y = zeros(length(x), 1);

  for i = 1:length(x)
    x_i = x(i);

    tmp = 0;
    N = length(p); % 4
    for j = 1:N
      tmp = tmp + p(j)*x_i^(N-j);
    end
    y(i) = tmp;
  end
end
