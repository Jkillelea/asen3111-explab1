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
  deficit = airspeed - v; % a negative number

  % find the maximum deficit
  max_deficit = max(deficit); % negative number
  y_deficit   = data.probe_y(deficit == max_deficit);

  % % where we've recovered 95% of freestream
  freestream   = deficit(find(((airspeed - deficit) / airspeed) <= 0.95, 1, 'first')); % basically where it's recovered to freestream
  y_freestream = data.probe_y(deficit == freestream);

  half_width = abs(y_freestream - y_deficit);

  % Generate a title
  titlestr = '%s: x = %.2f mm, v = %.0f m/s, delta = %.2f mm';
  if contains(filename, 'Cylinder')
    titlestr = sprintf(titlestr, 'Cylinder', xpos, airspeed, half_width);
  elseif contains(filename, 'Airfoil')
    titlestr = sprintf(titlestr, 'Airfoil',  xpos, airspeed, half_width);
  end

  % plot and save
  f = figure; hold on; grid on;
  scatter(deficit, data.probe_y);
  plot(max_deficit, y_deficit,    'ro');
  plot(freestream,  y_freestream, 'ro');
  plot([max_deficit, freestream], [y_deficit, y_freestream]);

  title(titlestr);
  ylabel('y-axis (mm)');
  xlabel('Velocity deficit (m/s)');

  print(f, '-dpng', ['../graphs/', filename, '.png']);
  close(f);
end