clear
clc
close all

airfoils15  = dir('../data/*15*Airfoil*.csv');
airfoils25  = dir('../data/*25*Airfoil*.csv');
cylinders15 = dir('../data/*15*Cylinder*.csv');
cylinders25 = dir('../data/*25*Cylinder*.csv');
graphs_folder = '../graphs/';
[err, msg, msgid] = mkdir(graphs_folder);
if err ~= 0
  warning(msg)
end

for files = {airfoils15, airfoils25, cylinders15, cylinders25} % each data set
  f = figure; hold on; grid on;
  files = cell2mat(files);
  for i = 1:length(files) % all files in set
    filename = files(i).name;
    data     = load_csv(['../data/', filename], 1, 0);
    airspeed = mean(data.airspeed);

    [normalized_deficit, normalized_y] = normalize_data(data);
    scatter(normalized_deficit, normalized_y, '.');
  end

  % Generate a title and filename
  if contains(files(1).name, 'Cylinder')
    titlestr = sprintf('Cylinder Velocity Deficit (%.0f m/s)', airspeed);
    filestr  = sprintf('normalized_cylinder%.0f', airspeed);
  elseif contains(files(1).name, 'Airfoil')
    titlestr = sprintf('Airfoil Velocity Deficit (%.0f m/s)', airspeed);
    filestr  = sprintf('normalized_airfoil%.0f', airspeed);
  end

  title(titlestr);
  ylabel('y position / half-width (mm/mm)');
  xlabel('Normalized velocity deficit (m/s)');
  print(f, '-dpng', [graphs_folder, filestr, '.png'])
end
