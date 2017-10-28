function indicies = group_into(x, desired, tol)
  indicies = cell(length(desired), 1);
  for i = 1:length(desired)
    d = desired(i);
    indicies{i} = find(abs(x - d) < tol);
  end
end
