clear
clc
close all

airfoils  = dir('../data/*Airfoil*.csv');
cylinders = dir('../data/*Cylinder*.csv');

% airfoils first
f = figure; hold on; grid on;
title('Normalized Airfoil Velocity Deficit');
ylabel('y position / half-width (mm/mm)');
xlabel('Normalized velocity deficit (m/s)');

for i = 1:length(airfoils)
  filename = airfoils(i).name;

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

  % normalize velocity deficit and y, make some more plots
  normalized_deficit = deficit      / max_deficit;
  normalized_y       = data.probe_y / half_width;

  plot(normalized_deficit, normalized_y);
end

print(f, '-dpng', ['../graphs/normalized_airfoil.png'])


% exactly the same thing as above but for cylinders
f = figure; hold on; grid on;
title('Normalized Cylinder Velocity Deficit');
ylabel('y position / half-width (mm/mm)');
xlabel('Normalized velocity deficit (m/s)');

for i = 1:length(cylinders)
  filename = cylinders(i).name;

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

  % normalize velocity deficit and y, make some more plots
  normalized_deficit = deficit      / max_deficit;
  normalized_y       = data.probe_y / half_width;

  plot(normalized_deficit, normalized_y);
end

print(f, '-dpng', ['../graphs/normalized_cylinder.png'])

