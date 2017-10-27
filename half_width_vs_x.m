% Plot the half-width of the wake behind a body for the
% airfoil and cylinder at 15 and 25 m/s each.
% This script depends on avg_vec.m and load_csv.m
clear
close all
clc

files = dir('../data/*.csv');

% half_width
hw_cyl_15 = zeros(length(files), 2); % cylinder, 15 m/s
hw_cyl_25 = zeros(length(files), 2); % 25 m/s
hw_afl_15 = zeros(length(files), 2); % airfoil, 15 m/s
hw_afl_25 = zeros(length(files), 2); % 25 m/s

% deficit
def_cyl_15 = zeros(length(files), 2); % cylinder, 15 m/s
def_cyl_25 = zeros(length(files), 2); % 25 m/s
def_afl_15 = zeros(length(files), 2); % airfoil, 15 m/s
def_afl_25 = zeros(length(files), 2); % 25 m/s

% process every file
for i = 1:length(files)
  filename = files(i).name;

  % load or skip
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

  % fit the data to a curve. Ignore points that might be in the boundary layer
  spline_fit   = fit(y(2:end-1), deficit(2:end-1), 'smoothingspline');
  dy           = 0.01;
  y_line       = min(y):dy:max(y);
  deficit_line = feval(spline_fit, y_line);

  max_deficit = max(abs(deficit_line));

  % calculate half width
  [half_width, y1, y2, d1, d2] = find_half_width(deficit_line, y_line);

  % find out which variable to store it in
  if contains(filename, 'Cylinder')
    if round(airspeed) == 15
      hw_cyl_15(i, :) = [xpos, half_width];
      def_cyl_15(i, :) = [xpos, max_deficit];
    elseif round(airspeed) == 25
      hw_cyl_25(i, :) = [xpos, half_width];
      def_cyl_25(i, :) = [xpos, max_deficit];
    else
      warning('Couldnt find apropriate place for data from file %s\n', filename);
    end
  else
    if round(airspeed) == 15
      hw_afl_15(i, :) = [xpos, half_width];
      def_afl_15(i, :) = [xpos, max_deficit];
    elseif round(airspeed) == 25
      hw_afl_25(i, :) = [xpos, half_width];
      def_afl_25(i, :) = [xpos, max_deficit];
    else
      warning('Couldnt find apropriate place for data from file %s\n', filename);
    end
  end
end

% prune empty rows, since we allocated enough space to put every data set into
% one of these variables.
hw_afl_25 = hw_afl_25((hw_afl_25(:, 1) ~= 0), :);
hw_afl_15 = hw_afl_15((hw_afl_15(:, 1) ~= 0), :);
hw_cyl_25 = hw_cyl_25((hw_cyl_25(:, 1) ~= 0), :);
hw_cyl_15 = hw_cyl_15((hw_cyl_15(:, 1) ~= 0), :);

def_afl_25 = def_afl_25((def_afl_25(:, 1) ~= 0), :);
def_afl_15 = def_afl_15((def_afl_15(:, 1) ~= 0), :);
def_cyl_25 = def_cyl_25((def_cyl_25(:, 1) ~= 0), :);
def_cyl_15 = def_cyl_15((def_cyl_15(:, 1) ~= 0), :);

% sort into order based on x (ascending)
hw_afl_25 = sortrows(hw_afl_25);
hw_afl_15 = sortrows(hw_afl_15);
hw_cyl_25 = sortrows(hw_cyl_25);
hw_cyl_15 = sortrows(hw_cyl_15);

def_afl_25 = sortrows(def_afl_25);
def_afl_15 = sortrows(def_afl_15);
def_cyl_25 = sortrows(def_cyl_25);
def_cyl_15 = sortrows(def_cyl_15);

N_powers = 4; % for polyfit

% I'm sorry Lord, please forgive me for the sins I am about to commit
f = figure; hold on; grid on;
scatter(hw_afl_25(:, 1), hw_afl_25(:, 2));
title('Airfoil at 25 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');
p = polyfit(hw_afl_25(:, 1), hw_afl_25(:, 2), N_powers);
y = mkpolyline(hw_afl_25(:, 1), p);
plot(hw_afl_25(:, 1), y);

f = figure; hold on; grid on;
scatter(hw_afl_15(:, 1), hw_afl_15(:, 2));
title('Airfoil at 15 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');
p = polyfit(hw_afl_15(:, 1), hw_afl_15(:, 2), N_powers);
y = mkpolyline(hw_afl_15(:, 1), p);
plot(hw_afl_15(:, 1), y);

f = figure; hold on; grid on;
scatter(hw_cyl_25(:, 1), hw_cyl_25(:, 2));
title('Cylinder at 25 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');
p = polyfit(hw_cyl_25(:, 1), hw_cyl_25(:, 2), N_powers);
y = mkpolyline(hw_cyl_25(:, 1), p);
plot(hw_cyl_25(:, 1), y);

f = figure; hold on; grid on;
scatter(hw_cyl_15(:, 1), hw_cyl_15(:, 2));
title('Cylinder at 15 m/s');
xlabel('distance behind body (mm)');
ylabel('size of half width (mm)');
p = polyfit(hw_cyl_15(:, 1), hw_cyl_15(:, 2), N_powers);
y = mkpolyline(hw_cyl_15(:, 1), p);
plot(hw_cyl_15(:, 1), y);

f = figure; hold on; grid on;
scatter(def_afl_25(:, 1), def_afl_25(:, 2));
title('Airfoil at 25 m/s');
xlabel('distance behind body (mm)');
ylabel('max velocity deficit (m/s)');
p = polyfit(def_afl_25(:, 1), def_afl_25(:, 2), N_powers);
y = mkpolyline(def_afl_25(:, 1), p);
plot(def_afl_25(:, 1), y);

f = figure; hold on; grid on;
scatter(def_afl_15(:, 1), def_afl_15(:, 2));
title('Airfoil at 15 m/s');
xlabel('distance behind body (mm)');
ylabel('max velocity deficit (m/s)');
p = polyfit(def_afl_15(:, 1), def_afl_15(:, 2), N_powers);
y = mkpolyline(def_afl_15(:, 1), p);
plot(def_afl_15(:, 1), y);

f = figure; hold on; grid on;
scatter(def_cyl_25(:, 1), def_cyl_25(:, 2));
title('Cylinder at 25 m/s');
xlabel('distance behind body (mm)');
ylabel('max velocity deficit (m/s)');
p = polyfit(def_cyl_25(:, 1), def_cyl_25(:, 2), N_powers);
y = mkpolyline(def_cyl_25(:, 1), p);
plot(def_cyl_25(:, 1), y);

f = figure; hold on; grid on;
scatter(def_cyl_15(:, 1), def_cyl_15(:, 2));
title('Cylinder at 15 m/s');
xlabel('distance behind body (mm)');
ylabel('max velocity deficit (m/s)');
p = polyfit(def_cyl_15(:, 1), def_cyl_15(:, 2), N_powers);
y = mkpolyline(def_cyl_15(:, 1), p);
plot(def_cyl_15(:, 1), y);
