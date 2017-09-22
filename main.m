clear all; clc;

% get filenames
files = dir('../data/*.csv');
n_files = length(files);

% xmat = zeros(20, n_files);
% ymat = zeros(20, n_files);
% qmat = zeros(20, n_files);

% figure; hold on;
for i = 1:n_files
  filename = files(i).name;
  data     = load_csv(['../data/' filename], 1, 0);

  x = data.probe_x;
  y = data.probe_y;
  q = data.aux_dynamic_pressure;
  % scatter3(x, y, q);

  % xmat(:, i) = x;
  % ymat(:, i) = y;
  % qmat(:, i) = q;
end

% plot3(xmat, ymat, qmat);
