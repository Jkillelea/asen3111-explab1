% Plot the half-width of the wake behind a body for the
% airfoil and cylinder at 15 and 25 m/s each.
% This script depends on avg_vec.m and load_csv.m
clear
close all
clc

files = dir('../data/*.csv');
hw_vs_x_cyl_15 = zeros(length(files), 2); % cylinder, 15 m/s
hw_vs_x_cyl_25 = zeros(length(files), 2); % 25 m/s
hw_vs_x_afl_15 = zeros(length(files), 2); % airfoil, 15 m/s
hw_vs_x_afl_25 = zeros(length(files), 2); % 25 m/s

for i = 1:length(files)
  filename = files(i).name;
  % load the file
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
  spline_fit   = fit(y, deficit, 'smoothingspline');
  dy           = 0.01;
  y_line       = min(y):dy:max(y);
  deficit_line = feval(spline_fit, y_line);

  % calculate half width
  [half_width, y1, y2, d1, d2] = find_half_width(deficit_line, y_line);

  % find out which variable to store it in
  if contains(filename, 'Cylinder')
    if round(airspeed) == 15
      hw_vs_x_cyl_15(i, :) = [xpos, half_width];
    elseif round(airspeed) == 25
      hw_vs_x_cyl_25(i, :) = [xpos, half_width];
    else
      warning('Couldnt find apropriate place for data from file %s\n', filename);
    end
  else
    if round(airspeed) == 15
      hw_vs_x_afl_15(i, :) = [xpos, half_width];
    elseif round(airspeed) == 25
      hw_vs_x_afl_25(i, :) = [xpos, half_width];
    else
      warning('Couldnt find apropriate place for data from file %s\n', filename);
    end
  end
end

% prune empty rows, since we allocated enough space to put every data set into
% one of these variables.
hw_vs_x_afl_25 = hw_vs_x_afl_25((hw_vs_x_afl_25(:, 1) ~= 0), :);
hw_vs_x_afl_15 = hw_vs_x_afl_15((hw_vs_x_afl_15(:, 1) ~= 0), :);
hw_vs_x_cyl_25 = hw_vs_x_cyl_25((hw_vs_x_cyl_25(:, 1) ~= 0), :);
hw_vs_x_cyl_15 = hw_vs_x_cyl_15((hw_vs_x_cyl_15(:, 1) ~= 0), :);

f = figure; hold on; grid on;
scatter(hw_vs_x_afl_25(:, 1), hw_vs_x_afl_25(:, 2));
title('Airfoil at 25 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');

f = figure; hold on; grid on;
scatter(hw_vs_x_afl_15(:, 1), hw_vs_x_afl_15(:, 2));
title('Airfoil at 15 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');

f = figure; hold on; grid on;
scatter(hw_vs_x_cyl_25(:, 1), hw_vs_x_cyl_25(:, 2));
title('Cylinder at 25 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');

f = figure; hold on; grid on;
scatter(hw_vs_x_cyl_15(:, 1), hw_vs_x_cyl_15(:, 2));
title('Cylinder at 15 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');
