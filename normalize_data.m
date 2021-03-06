function [normalized_deficit, normalized_y] = normalize_data(data)
  % Normalizes the deficit and half width of a velocity deficit measurement
  %  params:
  %  data -> struct from load_csv
  %  returns:
  %  normalized_deficit -> vector of deficit/max(deficit)
  %  normalized_y       -> vector of y/half_width

  % pull out the requisite data
  airspeed = mean(data.airspeed);
  rho      = mean(data.atmo_density);

  % calculate velocity deficit
  q = data.aux_dynamic_pressure;
  v = sqrt(2.*q/rho);
  y = data.probe_y;
  deficit = airspeed - v; % a negative number

  % fit the data to a curve. Ignore points that might be in the boundary layer
  spline_fit   = fit(y(2:end-1), deficit(2:end-1), 'smoothingspline');
  dy           = 0.01;
  y_line       = min(y):dy:max(y);
  deficit_line = feval(spline_fit, y_line);

  max_deficit = max(abs(deficit_line));

  % calculate half width
  [half_width, ~, ~, ~, ~] = find_half_width(deficit_line, y_line);

  % normalize velocity deficit and y, make some more plots
  normalized_deficit = deficit / max_deficit;
  normalized_y       = y / half_width;
end
