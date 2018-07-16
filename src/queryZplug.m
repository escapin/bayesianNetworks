function [ kettle, waterDisp, microwave ] = queryZplug(database, startDate, endDate)
%
%       [ kettle, waterDisp, microwave ] = queryZplug(database, startDate, endDate)
% 
% Returns the query results of Zplug
%
mksqlite('open', database);

% Water Dispenser active: ~ [100W or 1300W or 1600W or 2600W]
QwaterDisp =['SELECT Parameter_State.ID, Parameter_State.Value, Parameter_State.Time FROM Parameter_State ' ... 
    'JOIN Parameter ON Parameter_State.FK_Parameter=Parameter.ID WHERE Parameter.Name=''potenza'' AND ' ...
    'Parameter_State.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') AND ' ...
    '(CAST(Parameter_State.Value as INT)>50 AND CAST(Parameter_State.Value as INT)<=150) OR ' ... 
    '(CAST(Parameter_State.Value as INT)>1250 AND CAST(Parameter_State.Value as INT)<=1350) OR ' ...
    '(CAST(Parameter_State.Value as INT)>1550 AND CAST(Parameter_State.Value as INT)<=1650) OR ' ...
    'CAST(Parameter_State.Value as INT)>2500 ORDER BY Parameter_State.Time'];

% Microwave active: ~ [1200W or 1300W or 2500W or 2600W]
Qmicrowave =['SELECT Parameter_State.ID, Parameter_State.Value, Parameter_State.Time FROM Parameter_State ' ... 
    'JOIN Parameter ON Parameter_State.FK_Parameter=Parameter.ID WHERE Parameter.Name=''potenza'' AND ' ...
    'Parameter_State.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') AND ' ...
    '(CAST(Parameter_State.Value as INT)>1150 AND CAST(Parameter_State.Value as INT)<=1350) OR ' ... 
    'CAST(Parameter_State.Value as INT)>2500 ORDER BY Parameter_State.Time'];

% Kettle active: ~ [1800W or 1600W or 2500W or 2600W]
Qkettle =['SELECT Parameter_State.ID, Parameter_State.Value, Parameter_State.Time FROM Parameter_State ' ... 
    'JOIN Parameter ON Parameter_State.FK_Parameter=Parameter.ID WHERE Parameter.Name=''potenza'' AND ' ...
    'Parameter_State.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') AND ' ...
    '(CAST(Parameter_State.Value as INT)>1750 AND CAST(Parameter_State.Value as INT)<=1950) OR ' ... 
    'CAST(Parameter_State.Value as INT)>2500 ORDER BY Parameter_State.Time'];

QwaterDisp=sprintf(QwaterDisp, startDate, endDate);
Qmicrowave=sprintf(Qmicrowave, startDate, endDate);
Qkettle=sprintf(Qkettle, startDate, endDate);

waterDisp = mksqlite(QwaterDisp);
kettle = mksqlite(Qkettle);
microwave = mksqlite(Qmicrowave);

if isempty(waterDisp)
    waterDisp=cell(3,1);
    waterDisp(1,1)={0};
    waterDisp(2,1)={-1};
    waterDisp(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    waterDisp=struct2cell(waterDisp);
end
if isempty(microwave)
    microwave=cell(3,1);
    microwave(1,1)={0};
    microwave(2,1)={-1};
    microwave(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    microwave=struct2cell(microwave);
end
if isempty(kettle)
    kettle=cell(3,1);
    kettle(1,1)={0};
    kettle(2,1)={-1};
    kettle(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    kettle=struct2cell(kettle);
end

mksqlite('close');
end