% calculate Cd for each of the test articles at each speed.
clear
clc
close all

airfoils15  = dir('../data/*15*Airfoil*.csv');
airfoils25  = dir('../data/*25*Airfoil*.csv');
cylinders15 = dir('../data/*15*Cylinder*.csv');
cylinders25 = dir('../data/*25*Cylinder*.csv');

for files = {airfoils15, airfoils25, cylinders15, cylinders25}
  files   = cell2mat(files);
  Cd = zeros(1, length(files));
  for i = 1:length(files)
    filename = files(i).name;
    data     = load_csv(['../data/', filename], 1, 0);

    airspeed = mean(data.airspeed);         % m/s
    rho      = mean(data.atmo_density);     % kg/m^3
    q        = data.aux_dynamic_pressure;   % Pa
    u        = sqrt(2.*q/rho);              % m/s
    y        = data.probe_y / 1000;         % meters
    vinf     = airspeed*ones(length(y), 1); % vector of the same length

    if contains(filename, 'Airfoil')
      chord = 8.89 / 100; % meters
    elseif contains(filename, 'Cyilnder')
      chord = 1.27 / 100; % meters
    end

    Cd(i) = -2/(airspeed^2 * chord) * trapz(y, (u.^2 - vinf.*u));
  end

  % Generate a title
  if contains(files(1).name, 'Cylinder')
    str = sprintf('Cylinder - %.0f m/s', airspeed);
  elseif contains(files(1).name, 'Airfoil')
    str = sprintf('Airfoil - %.0f m/s', airspeed);
  end

  fprintf('%s - Cd = %f\n', str, mean(Cd));
end
