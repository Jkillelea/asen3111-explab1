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

% airfoils first
f = figure; hold on; grid on;
title('Normalized Airfoil Velocity Deficit (15 m/s)');
ylabel('y position / half-width (mm/mm)');
xlabel('Normalized velocity deficit (m/s)');
for i = 1:length(airfoils15)
  filename = airfoils15(i).name;
  data = load_csv(['../data/', filename], 1, 0);
  [normalized_deficit, normalized_y] = normalize_data(data);
  plot(normalized_deficit, normalized_y);
end
print(f, '-dpng', [graphs_folder, 'normalized_airfoil15.png'])

f = figure; hold on; grid on;
title('Normalized Airfoil Velocity Deficit (25 m/s)');
ylabel('y position / half-width (mm/mm)');
xlabel('Normalized velocity deficit (m/s)');
for i = 1:length(airfoils25)
  filename = airfoils25(i).name;
  data = load_csv(['../data/', filename], 1, 0);
  [normalized_deficit, normalized_y] = normalize_data(data);
  plot(normalized_deficit, normalized_y);
end
print(f, '-dpng', [graphs_folder, 'normalized_airfoil25.png'])

% exactly the same thing as above but for cylinders
f = figure; hold on; grid on;
title('Normalized Cylinder Velocity Deficit (15 m/s)');
ylabel('y position / half-width (mm/mm)');
xlabel('Normalized velocity deficit (m/s)');
for i = 1:length(cylinders15)
  filename = cylinders15(i).name;
  data = load_csv(['../data/', filename], 1, 0);
  [normalized_deficit, normalized_y] = normalize_data(data);
  plot(normalized_deficit, normalized_y);
end
print(f, '-dpng', [graphs_folder, 'normalized_cylinder15.png'])

f = figure; hold on; grid on;
title('Normalized Cylinder Velocity Deficit (25 m/s)');
ylabel('y position / half-width (mm/mm)');
xlabel('Normalized velocity deficit (m/s)');
for i = 1:length(cylinders25)
  filename = cylinders25(i).name;
  data = load_csv(['../data/', filename], 1, 0);
  [normalized_deficit, normalized_y] = normalize_data(data);
  plot(normalized_deficit, normalized_y);
end
print(f, '-dpng', [graphs_folder, 'normalized_cylinder25.png'])
