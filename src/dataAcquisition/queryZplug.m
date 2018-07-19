function [ kettle, waterDisp, microwave ] = queryZplug(database, startDate, endDate)
%
%       [ kettle, waterDisp, microwave ] = queryZplug(database, startDate, endDate)
% 
% Returns the query results of Zplug
%
%mksqlite('open', database);
dbid=sqlite(fullfile(pwd, database));

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

waterDisp = fetch(dbid,QwaterDisp);
kettle = fetch(dbid,Qkettle);
microwave = fetch(dbid,Qmicrowave);

%mksqlite('close');
close(dbid);


if isempty(waterDisp)
    waterDisp=cell(3,1);
    waterDisp(1,1)={0};
    waterDisp(2,1)={-1};
    waterDisp(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    waterDisp=transpose(waterDisp); 
    % the transpose of the (m×n) matrix A is the (n×m) matrix B such that 
    % B_(i, j) = A_(j, i): for backward compatability with the 2012 version
end
if isempty(microwave)
    microwave=cell(3,1);
    microwave(1,1)={0};
    microwave(2,1)={-1};
    microwave(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    microwave=transpose(microwave);
    % the transpose of the (mXn) matrix A is the (nXm) matrix B such that
    % B_(i, j) = A_(j, i): for backward compatability with the 2012 version
end
if isempty(kettle)
    kettle=cell(3,1);
    kettle(1,1)={0};
    kettle(2,1)={-1};
    kettle(3,1)=cellstr(datestr([1900, 01, 01, 00, 00, 00]));
else
    kettle=transpose(kettle);
    % the transpose of the (mXn) matrix A is the (nXm) matrix B such that
    % B_(i, j) = A_(j, i): for backward compatability with the 2012 version
end

end