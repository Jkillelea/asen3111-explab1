function [hw, y1, y2, d1, d2] = find_half_width(deficit, y)
  % Finds the half width
  %  params:
  %  deficit -> vector of floats, velocity deficit
  %  y       -> vector of floats, y position
  %  returns:
  %  hw      -> float, length of half width
  %  y1, y2  -> floats, y positions of each side of half width
  %  d1, d2, -> floats, values of the deficit (should be 1/2 * max(deficit))
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
