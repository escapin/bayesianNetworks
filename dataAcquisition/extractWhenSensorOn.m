function [ table ] = extractWhenSensorOn(database, sensorID, startDate, endDate)
%
%    function table = extractWhenSensorOn(database, targetNode, startDate, endDate)
%
% INPUTS:
%   - database: the string containging the database path
%   - targetNode: the number of the FK_Parameter of the target parameter
%                 sensorID==2 --> WindowOpen Sensor
%                 sensorID==7 --> Movement Sensor
%   - startDate: the beginning date of the measurements
%   - endDate: the ending date of the measurements
%
%  OUTPUT
%   - table: a 3x#time_interval matrix indicating: 
%               1st row --> the numer of row of the table 'Parameter_State' in the db 
%                           which reports an activation of the sensor   
%               2nd row --> the activation timestamp of the sensor
%               3rd row --> the disactivation timestamp of the sensor
% 

% addpath(genpathKPM(pwd))

%mksqlite('open',database);
dbid=sqlite(fullfile(pwd, database));

% 2 window sensor
% 9 movement sensor

queryName = ['SELECT PS1.ID, PS1.Time AS sensorOn, PS2.Time AS sensorOff ' ... 
             'FROM Parameter_State PS1, Parameter_State PS2 ' ...
             'WHERE PS1.FK_Parameter=%d AND PS2.FK_Parameter=%d AND PS1.Value=''on'' AND PS2.Value=''off'' AND ' ... 
             'PS1.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') AND PS2.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') AND ' ...
             'PS2.Time = ( SELECT  MIN(PS3.Time) FROM Parameter_State PS3 WHERE  PS3.FK_Parameter=%d AND PS3.Value=''off'' AND ' ...
             'PS3.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') AND PS3.Time > PS1.Time) ORDER BY PS1.Time'];

queryName=sprintf(queryName, sensorID, sensorID, startDate, endDate, startDate, endDate, sensorID, startDate, endDate);

%table=mksqlite(queryName);
table=fetch(dbid, queryName);
%mksqlite('close');
close(dbid);

if isempty(table)
    table=cell(3,1);
    table(1,1)={0};
    table(2,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
    table(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    table=transpose(table); 
    % the transpose of the (m×n) matrix A is the (n×m) matrix B such that 
    %B_(i, j) = A_(j, i): for backward compatability with the 2012 version
end
end

