function [ zPlug ] = unionZplug(database, startDate, endDate)

% addpath(genpathKPM(pwd))
%mksqlite('open', database);
dbid=sqlite(fullfile(pwd, database));

queryZplug = ['SELECT Parameter_State.Value, Parameter_State.Time FROM Parameter_State ' ... 
' JOIN Parameter ON Parameter_State.FK_Parameter=Parameter.ID WHERE Parameter.Name=''potenza'' AND ' ...
' Parameter_State.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'')' ...
' ORDER BY Parameter_State.Time'];

queryZplug=sprintf(queryZplug, startDate, endDate);

%zPlug = mksqlite(queryZplug);
zPlug =  fetch(dbid, queryZplug);
% mksqlite('close');
close(dbid);

zPlug = transpose(zPlug);
% the transpose of the (mxn) matrix A is the (nxm) matrix B such that
% B_(i, j) = A_(j, i). (For backward compatability with the 2012 version.)

end
