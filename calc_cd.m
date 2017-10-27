clear
clc
close all

airfoils15  = dir('../data/*Airfoil*.csv');

for i = 1:length(airfoils15)
  filename = airfoils15(i).name;
  data     = load_csv(['../data/', filename], 1, 0);

  airspeed = mean(data.airspeed);         % m/s
  rho      = mean(data.atmo_density);     % kg/m^3
  q        = data.aux_dynamic_pressure;   % Pa
  u        = sqrt(2.*q/rho);              % m/s
  y        = data.probe_y / 1000;         % meters
  vinf     = airspeed*ones(length(y), 1); % vector of the same length

  disp(filename);

  if contains(filename, 'Airfoil')
    chord = 8.89 / 100; % meters
  elseif contains(filename, 'Cyilnder')
    chord = 1.27 / 100; % meters
  end

  Cd = 2/(airspeed^2 * chord) * trapz(y, (u.^2 - vinf.*u))
end
