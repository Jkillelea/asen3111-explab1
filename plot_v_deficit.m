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
    fprintf('[WARNING] Unable to parse file %s. Continuing...\n', filename);
    disp(err.message);
    continue
  end

  airspeed = mean(data.airspeed);
  rho      = mean(data.atmo_density);
  xpos     = mean(data.probe_x);

  q = data.aux_dynamic_pressure;
  v = sqrt(2.*q/rho);

  deficit = airspeed - v;

  titlestr = '';
  if contains(filename, 'Cylinder')
    titlestr = sprintf('%s - x = %.2f mm, v = %.2f m/s', 'Cylinder', xpos, airspeed);
  elseif contains(filename, 'Airfoil')
    titlestr = sprintf('%s - x = %.2f mm, v = %.2f m/s', 'Airfoil', xpos, airspeed);
  end

  f = figure;
  scatter(deficit, data.probe_y);
  grid on;
  title(titlestr);
  ylabel('y-axis (mm)');
  xlabel('Velocity deficit (m/s)');

  print(f, '-dpng', ['../graphs/', filename, '.png']);
  close
end