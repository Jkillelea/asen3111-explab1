function [hw, y1, y2, d1, d2] = find_half_width(deficit, y)
  % find the half width
  idx1 = find(deficit/max(deficit) > 0.5, 1, 'first');
  idx2 = find(deficit/max(deficit) > 0.5, 1, 'last');

  % on one side of the curve
  d1 = deficit(idx1);
  y1 = y(idx1);

  % and the other size (upper side)
  d2 = deficit(idx2);
  y2 = y(idx2);

  hw = 0.5*(y2 - y1);
end
