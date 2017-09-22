function [vec_out] = avg_vec(vec_in)
  % Takes a vector of 10_000 floats and finds the means with intervals of 500
  % Returns a vector of 20 floats
  vec_out = zeros(20, 1);
  for i = 1:20
    idx = (i-1)*500 + 1;
    idx_end = idx + 499;
    vec_out(i) = mean(vec_in(idx:idx_end));
  end
end
