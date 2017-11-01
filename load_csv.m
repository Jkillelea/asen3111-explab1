function data = load_csv(filename, R, C)
  % load csv data into struct with offset of row = R, column = C
  %   handles averaging the 10_000 data points down into 20
  raw_data = csvread(filename, R, C);

  % place into struct
  data = struct('atmo_pressure',          raw_data(:, 1), ...
                'atmo_temperature',       raw_data(:, 2), ...
                'atmo_density',           raw_data(:, 3), ...
                'airspeed',               raw_data(:, 4), ...
                'pitot_dynamic_pressure', raw_data(:, 5), ...
                'aux_dynamic_pressure',   raw_data(:, 6), ...
                'probe_x',                raw_data(:, 27), ...
                'probe_y',                raw_data(:, 28));

  % take averages of all the points (20 single points instead of 500 samples each at 20 locations)
  data.atmo_pressure          = avg_vec(data.atmo_pressure);
  data.atmo_temperature       = avg_vec(data.atmo_temperature);
  data.atmo_density           = avg_vec(data.atmo_density);
  data.airspeed               = avg_vec(data.airspeed);
  data.pitot_dynamic_pressure = avg_vec(data.pitot_dynamic_pressure);
  data.aux_dynamic_pressure   = avg_vec(data.aux_dynamic_pressure);
  data.probe_x                = avg_vec(data.probe_x);
  data.probe_y                = avg_vec(data.probe_y);
end
