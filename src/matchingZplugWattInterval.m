function [ minZplug maxZplug avgZplug ] = matchingZplugWattInterval(ZplugActive, timeline, operation)
%
%    function res = matchingSensorInterval(sensActive, timeline)
%
% Per ogni intervallo temporale della timeline assegna 1 sse il sensore è attivo in quel determinato intervallo
%
% INPUTS:
%   - ZplugActive: cell 2xN containging the Watt power and the relevation instant
%               1,j Watt value
%               2,j relevation instant
%   - timeline: 1xN array containging some time instants
%   - operation: which operation made ok every batch
% OUTPUT:
%   - res: 1xN cell where res(i)=1 iff sensor is active in i-th temporal interval, 0 otherwise.

lenght = size(timeline);
lenghtTable=size(ZplugActive);

minZplug = zeros(1,lenght(2));
maxZplug = zeros(1,lenght(2));
avgZplug = zeros(1,lenght(2));

% to set up the first interval
startTimeline=addtodate(datenum(timeline(1,1)), -3, 'minute');
endTimeline=datenum(timeline(1,1));
nextJ=1;
for i=1:lenght(2)
    endInnerLoop=0;
    j=nextJ; % to avoid to check the previous intervals
    batch=zeros(90,1);
    k=1;
    while(j<=lenghtTable(2) && endInnerLoop==0)
        instant=datenum(ZplugActive(2,j));
        if(instant < startTimeline) % to avoid to check the previous intervals
            nextJ = j+1;
        elseif (endTimeline < instant) % to avoid to check the next intervals
            endInnerLoop=1;
        else
%             i
%             j
%             k
%             size(batch(k,1))
%             size(cell2num(ZplugActive(1,j)))
%             size(k)
            %disp('ciao')
            batch(k)=str2double(cell2num(ZplugActive(1,j)));
            k=k+1;
        end
        j=j+1;
    end
    if(k>1)
        minZplug(i)=min(batch(1:k-1));
        maxZplug(i)=max(batch(1:k-1));
        avgZplug(i)=mean(batch(1:k-1));
    else
        minZplug(i)=1;
        maxZplug(i)=1;
        avgZplug(i)=1;
    end
    startTimeline=datenum(timeline(1,i));
    if(i~=lenght(2)) % to avoid Out Of Bound Error
        endTimeline=datenum(timeline(1,i+1));
    end
end
res=num2cell(res);
end