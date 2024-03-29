function [TLOG] = fcnTLOGLOAD(INFO,tlogpath,tlogfiles)
% This funciton loads the raw .mat files from the tlog as made from MP.
% Description of mavlink messages at:
% http://mavlink.org/messages/common

if nargin==2
    TLOG = load(tlogpath);
elseif nargin==3
    filename = tlogfiles{1};
    fprintf('\nLoading TLOG file: %s.\n',filename);
    TLOG = load(strcat(tlogpath,'/',filename));
    
else
    error('TLOG load error')
end
        
[~, neworder] = sort(lower(fieldnames(TLOG)));
TLOG = orderfields(TLOG, neworder);


%sort sensor data
load MAV_SYS_STATUS_SENSOR.mat

%bitwise compare of the bitmask in the tlog with the mavlink cmd id. 
temp = zeros(size(TLOG.onboard_control_sensors_enabled_mavlink_sys_status_t,1),length(MAV_SYS_STATUS_SENSOR.CMDID));
temp2 = zeros(size(TLOG.onboard_control_sensors_health_mavlink_sys_status_t,1),length(MAV_SYS_STATUS_SENSOR.CMDID));
temp3 = zeros(size(TLOG.onboard_control_sensors_present_mavlink_sys_status_t,1),length(MAV_SYS_STATUS_SENSOR.CMDID));

for count = 1:length(MAV_SYS_STATUS_SENSOR.CMDID)
temp(:,count) = bitand(uint32(TLOG.onboard_control_sensors_enabled_mavlink_sys_status_t(:,2)),MAV_SYS_STATUS_SENSOR.CMDID(count)');
temp2(:,count) =bitand(uint32(TLOG.onboard_control_sensors_health_mavlink_sys_status_t(:,2)),MAV_SYS_STATUS_SENSOR.CMDID(count)');
temp3(:,count) =bitand(uint32(TLOG.onboard_control_sensors_present_mavlink_sys_status_t(:,2)),MAV_SYS_STATUS_SENSOR.CMDID(count)');
end
clear count


%time isn't right in the matlab? I don't know.
%using time_boot_ms_mavlink_system_time_t and a dataflash entry, it looks like the estimation of
%boot time is 1 day, 4 hours and 16.5 seconds off? 
%TimeS is reference to INFO.pixhawkstart so it will align with the current
%dataflash

timelocal = datenum(TLOG.onboard_control_sensors_enabled_mavlink_sys_status_t(:,1)) - 1 + (4/24) + (16.5/60/60/24);
timeS = (timelocal - INFO.pixhawkstart).*86400;


%sort into new field in TLOG structure
for count = 1:length(MAV_SYS_STATUS_SENSOR.CMDID)
eval(sprintf('TLOG.sensors.%s.enabled= (temp(:,%i)~=0);',MAV_SYS_STATUS_SENSOR.SENSOR(count),count));
eval(sprintf('TLOG.sensors.%s.health= (temp2(:,%i)~=0);',MAV_SYS_STATUS_SENSOR.SENSOR(count),count));
eval(sprintf('TLOG.sensors.%s.present= (temp3(:,%i)~=0);',MAV_SYS_STATUS_SENSOR.SENSOR(count),count));

eval(sprintf('TLOG.sensors.%s.TimeLOCAL= timelocal;',MAV_SYS_STATUS_SENSOR.SENSOR(count)));
eval(sprintf('TLOG.sensors.%s.TimeS= timeS;',MAV_SYS_STATUS_SENSOR.SENSOR(count)));

end

%% guess of latency.
% time_unix_usec_mavlink_system_time_t(:,1) is the timestamp on the pc.
% pc time needs to be synced to internet before flying
% time_unix_usec_mavlink_system_time_t(:,2) is the pixhawk time when the
% message was sent.

%posixtime converts to number of seconds since jan 1 1970
%need to subtract a day here for some reason...
t1 = datetime(datestr(TLOG.time_unix_usec_mavlink_system_time_t(:,1))) - days(1);
t1.TimeZone = 'America/New_York';
latency = (((posixtime(t1)-...
    TLOG.time_unix_usec_mavlink_system_time_t(:,2).*1e-6)./86400)); 


TLOG.time_s_latency(:,1) = TLOG.time_boot_ms_mavlink_system_time_t(:,2)./1000;

TLOG.time_s_latency(:,2) = latency;

end