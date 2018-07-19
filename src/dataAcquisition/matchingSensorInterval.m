function [ res ] = matchingSensorInterval(sensActive, timeline)
%
%    function res = matchingSensorInterval(sensActive, timeline)
%
% For each timestamp 't_i' in the timeline, we set the value to 1 if, 
% in the time interval [t_i,t_(i-1)], the corresponding sensor has been 
% activated at least once.
%
% INPUTS:
%   - sensActive: cell 3xN containging the active temporal range of that sensor
%   - timeline: 1xN array containging some time instants
% OUTPUT:
%   - res: 1xN cell where res(i)=1 iff sensor is active in i-th temporal interval, 0 otherwise.

lenghtTimeline = size(timeline);
lenghtTable=size(sensActive);
res = zeros(1,lenghtTimeline(2));

% to set up the first interval
startTimeline=addtodate(datenum(timeline(1,1)), -3, 'minute');
endTimeline=datenum(timeline(1,1));
nextJ=1;
for i=1:lenghtTimeline(2)
    endInnerLoop=0;
    j=nextJ; % to avoid to check the previous intervals
    while(j<=lenghtTable(2) && endInnerLoop==0)
        startSens=datenum(sensActive(2,j));
        endSens=datenum(sensActive(3,j));
        if(endSens < startTimeline) % to avoid to check the previous intervals
            nextJ = j+1;
        elseif (endTimeline < startSens) % to avoid to check the next intervals
            endInnerLoop=1;
        elseif ~(endTimeline < startSens || endSens < startTimeline)
            res(i)=1;
            endInnerLoop=1;
        end
        j=j+1;
    end
    
    startTimeline=datenum(timeline(1,i));
    if(i~=lenghtTimeline(2)) % to avoid Out Of Bound Error
        endTimeline=datenum(timeline(1,i+1));
    end
end
res=num2cell(res);
end