clear all; clc;

% file descriptors for the console
STDOUT = 1;
STDERR = 2;

% get filenames
cylinders = dir('../data/*Cylinder*.csv');
airfoils  = dir('../data/*Airfoil*.csv');

n_airfoils = length(airfoils);

fig_v15 = figure; hold on;
title('15 m/s');
fig_v25 = figure; hold on;
title('25 m/s');

for i = 1:length(cylinders)
  % load in the file (with error handling)
  filename = cylinders(i).name;
  try
    data = load_csv(['../data/' filename], 1, 0);
  catch exception
    fprintf('[WARNING] Unable to parse file %s. Continuing...\n', filename);
  end

  % determine which plot the data belongs on (with error handling)
  if round(mean(data.airspeed)) == 15
    set(0, 'currentfigure', fig_v15); % set the plot for 15 m/s to current
  elseif round(mean(data.airspeed)) == 25
    set(0, 'currentfigure', fig_v25); % set the plot for 25 m/s to current
  else
    fprintf('[WARNING] Expected airspeed of either 15 or 25, found %d in file %s.\n', ...
     round(mean(data.airspeed)), filename);
  end

  x = data.probe_x;
  y = data.probe_y;
  q = data.aux_dynamic_pressure;

  scatter3(x, y, q);
end
