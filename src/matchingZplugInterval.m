function [ res ] = matchingZplugInterval(ZplugActive, timeline)
%
%    function res = matchingSensorInterval(sensActive, timeline)
%
% Per ogni intervallo temporale della timeline assegna 1 sse il sensore è attivo in quel determinato intervallo
%
% INPUTS:
%   - ZplugActive: cell 1xN containging the active temporal instant of that appliance
%   - timeline: 1xN array containging some time instants
% OUTPUT:
%   - res: 1xN cell where res(i)=1 iff sensor is active in i-th temporal interval, 0 otherwise.

lenght = size(timeline);
lenghtTable=size(ZplugActive);
res = zeros(1,lenght(2));

% to set up the first interval
startTimeline=addtodate(datenum(timeline(1,1)), -3, 'minute');
endTimeline=datenum(timeline(1,1));
nextJ=1;
for i=1:lenght(2)
    endInnerLoop=0;
    j=nextJ; % to avoid to check the previous intervals
    while(j<=lenghtTable(2) && endInnerLoop==0)
        instant=datenum(ZplugActive(1,j));
        if(instant < startTimeline) % to avoid to check the previous intervals
            nextJ = j+1;
        elseif (endTimeline < instant) % to avoid to check the next intervals
            endInnerLoop=1;
        else
            res(i)=1;
            endInnerLoop=1;
        end
        j=j+1;
    end
    
    startTimeline=datenum(timeline(1,i));
    if(i~=lenght(2)) % to avoid Out Of Bound Error
        endTimeline=datenum(timeline(1,i+1));
    end
end
res=num2cell(res);
end