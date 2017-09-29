% plot velocity deficit for each test case
clear
clc

% get filenames
files = dir('../data/*.csv');

% plot the velocity deficit for each
for i = 1:length(files)
  filename = files(i).name;
  try
    data = load_csv(['../data/', filename], 1, 0);
  catch err
    warning('Unable to parse file %s. Continuing...\n', filename);
    disp(err.message);
    continue
  end

  % pull out the requisite data
  airspeed = mean(data.airspeed);
  rho      = mean(data.atmo_density);
  xpos     = mean(data.probe_x);

  % calculate velocity deficit
  q = data.aux_dynamic_pressure;
  v = sqrt(2.*q/rho);
  deficit = airspeed - v;

  % Generate a title
  titlestr = '';
  if contains(filename, 'Cylinder')
    titlestr = sprintf('%s - x = %.2f mm, v = %.2f m/s', 'Cylinder', xpos, airspeed);
  elseif contains(filename, 'Airfoil')
    titlestr = sprintf('%s - x = %.2f mm, v = %.2f m/s', 'Airfoil', xpos, airspeed);
  end

  % plot and save
  f = figure; hold on; grid on;
  scatter(deficit, data.probe_y);

  title(titlestr);
  ylabel('y-axis (mm)');
  xlabel('Velocity deficit (m/s)');

  print(f, '-dpng', ['../graphs/', filename, '.png']);
  close(f);
end