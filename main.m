basefolder = 'Flight';

pixhawkpath = sprintf('%s/Pixhawk',basefolder);
weatherpath = sprintf('%s/WeatherStation',basefolder);

pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
weatherfiles = fcnFILELIST(weatherpath,'.CSV');
