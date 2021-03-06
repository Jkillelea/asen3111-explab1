% Plot the half-width of the wake behind a body for the
% airfoil and cylinder at 15 and 25 m/s each.
% This script depends on avg_vec.m and load_csv.m
clear
close all
clc

data_folder   = 'data/';
graphs_folder = 'graphs/';

airfoils15  = dir([data_folder, '*15*Airfoil*.csv']);
airfoils25  = dir([data_folder, '*25*Airfoil*.csv']);
cylinders15 = dir([data_folder, '*15*Cylinder*.csv']);
cylinders25 = dir([data_folder, '*25*Cylinder*.csv']);

% each set of data
for files = {airfoils15, airfoils25, cylinders15, cylinders25}
  files   = cell2mat(files);
  hw_v_x  = zeros(length(files), 2); % 2 cols
  def_v_x = zeros(length(files), 2); % 2 cols

  for i = 1:length(files) % each file
    filename = files(i).name;
    data     = load_csv([data_folder, filename], 1, 0);

    airspeed = mean(data.airspeed);
    rho      = mean(data.atmo_density);
    x        = mean(data.probe_x);

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
    max_deficit  = max(abs(deficit_line));

    [half_width, y1, y2, d1, d2] = find_half_width(deficit_line, y_line);

    hw_v_x(i, :) = [x, half_width];
    def_v_x(i, :) = [x, max_deficit];
  end

  % sort by x location
  hw_v_x  = sortrows(hw_v_x);
  def_v_x = sortrows(def_v_x);

  % Generate a title
  if contains(files(1).name, 'Cylinder')
    titlestr = sprintf('Cylinder - %.0f m/s - ', airspeed);
    filestr = sprintf('cylinder_%.0f', airspeed);
    desired_x = [90, 180, 240]; % desired x locations
    tol = 10; % tolerance
  elseif contains(files(1).name, 'Airfoil')
    titlestr = sprintf('Airfoil - %.0f m/s - ', airspeed);
    filestr = sprintf('airfoil_%.0f', airspeed);
    desired_x = [13, 18, 23, 28, 33, 38, 43];
    tol = 2;
  end

  % group by how close they are to the desired x locations
  idxs = group_into(hw_v_x(:, 1), desired_x, tol);
  hw_v_x_reduced = zeros(length(idxs), 2);
  def_v_x_reduced = zeros(length(idxs), 2);
  for i = 1:length(idxs)
    range = idxs{i};
    hw_v_x_reduced(i, :)  = [mean(hw_v_x(range, 1)), mean(hw_v_x(range, 2))];
    def_v_x_reduced(i, :) = [mean(def_v_x(range, 1)), mean(def_v_x(range, 2))];
  end

  % create best fit lines for both datasets
  opts = fitoptions('Method', 'SmoothingSpline', 'SmoothingParam', 0.0005);
  x          = hw_v_x_reduced(:, 1);
  hw         = hw_v_x_reduced(:, 2);
  spline_fit = fit(x, hw, 'SmoothingSpline', opts);
  x_line     = min(x):max(x);
  hw_line    = feval(spline_fit, x_line);

  x          = def_v_x_reduced(:, 1);
  def        = def_v_x_reduced(:, 2);
  spline_fit = fit(x, def, 'SmoothingSpline', opts);
  x_line     = min(x):max(x);
  def_line   = feval(spline_fit, x_line);

  % make some pretty plots
  f = figure; hold on; grid on;
  xlabel('x-location (mm)');
  ylabel('half-width (mm)');
  title([titlestr, 'half-width vs x location']);
  scatter(hw_v_x(:, 1),         hw_v_x(:, 2));
  scatter(x,                    hw,                   'r');
  plot(   x_line,               hw_line,              'r');
  print(f, '-dpng', [graphs_folder, filestr, '_hw']);

  f = figure; hold on; grid on;
  xlabel('x-location (mm)');
  ylabel('maximum velocity deficit (m/s)');
  title([titlestr, 'max velocity deficit vs x location']);
  scatter(def_v_x(:, 1),         def_v_x(:, 2));
  scatter(x,                     def,                   'r');
  plot(   x_line,                def_line,              'r');
  print(f, '-dpng', [graphs_folder, filestr, '_deficit']);
end
