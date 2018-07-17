function table = syncTempSmth(database, referenceNode, targetNode, startDate, endDate)
%
%    function table = syncTempSmth(database, referenceNode, targetNode, startDate, endDate)
%
% INPUTS:
%   - database: the string containging the database path
%   - referenceNode: the number of the FK_Parameter of the reference parameter
%   - targetNode: the number of the FK_Parameter of the target parameter
%   - startDate: the beginning date of the measurements
%   - endDate: the ending date of the measurements

% addpath(genpathKPM(pwd))

%mksqlite('open',database);
dbid=sqlite(fullfile(pwd, database));

queryName = ['SELECT v.TempWin, v.PS1time, v.Hum, v.PS2time FROM ' ...
    '(SELECT PS1.Value as TempWin, PS2.Value as Hum, PS1.Time as PS1time, PS2.Time as PS2time, ' ...
    'abs(julianday(PS1.Time) - julianday(PS2.Time)) as difference ' ...
    'FROM Parameter_State PS1, Parameter_State PS2 ' ... 
    'WHERE PS1.FK_Parameter=%d AND PS2.FK_Parameter=%d AND PS1.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') ' ...
	'AND PS2.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') ) v, ' ...
    '(SELECT PS1.Time as PS1time, min(abs(julianday(PS1.Time) - julianday(PS2.Time))) as difference ' ...
    'FROM Parameter_State PS1, Parameter_State PS2 ' ...  
    'WHERE PS1.FK_Parameter=%d AND PS2.FK_Parameter=%d AND PS1.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') ' ...
	'AND PS2.Time BETWEEN Datetime(''%s'') AND Datetime(''%s'') ' ...
    'GROUP BY PS1.Time ) m ' ...
    'WHERE v.PS1time = m.PS1time AND v.difference = m.difference ORDER BY v.PS1time'];

queryName=sprintf(queryName, referenceNode, targetNode, startDate, endDate, startDate, endDate, referenceNode, targetNode, startDate, endDate, startDate, endDate);


%table=mksqlite(queryName);
table=fetch(dbid, queryName);
%mksqlite('close');
close(dbid);

end

