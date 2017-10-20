% plot velocity deficit for each test case
clear
clc
close all

% get filenames
files = dir('../data/*.csv');

% plot the velocity deficit for each
for i = 1:length(files)
  filename = files(i).name;
  try
    data = load_csv(['../data/', filename], 1, 0);
  catch err
    warning('Unable to parse file %s. Skipping...\n', filename);
    continue
  end

  % pull out the requisite data
  airspeed = mean(data.airspeed);
  rho      = mean(data.atmo_density);
  xpos     = mean(data.probe_x);

  % calculate velocity deficit
  q = data.aux_dynamic_pressure;
  v = sqrt(2.*q/rho);
  y = data.probe_y;
  deficit = airspeed - v; % a negative number

	% fit the data to a curve
  spline_fit = fit(y(2:end-1), deficit(2:end-1), 'smoothingspline');
  dy         = 0.01;
  y_line     = min(y):dy:max(y);
  deficit_line = feval(spline_fit, y_line);

  [half_width, y1, y2, d1, d2] = find_half_width(deficit_line, y_line);

  % Generate a title
  titlestr = '%s: x = %.2f mm, v = %.0f m/s, delta = %.1f mm';
  if contains(filename, 'Cylinder')
    titlestr = sprintf(titlestr, 'Cylinder', xpos, airspeed, half_width);
  elseif contains(filename, 'Airfoil')
    titlestr = sprintf(titlestr, 'Airfoil',  xpos, airspeed, half_width);
  end

  % plot and save
  f = figure; hold on; grid on;
  scatter(deficit, data.probe_y);
  plot(deficit_line, y_line);
  plot(d1, y1, 'ro');
  plot(d2, y2, 'ro');
  plot([d1, d2], [y1, y2], 'r');


	title(titlestr);
  ylabel('y-axis (mm)');
  xlabel('Velocity deficit (m/s)');

  print(f, '-dpng', ['../graphs/', filename, '.png']);
	close(f);

end
